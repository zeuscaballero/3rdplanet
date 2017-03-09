//
//  PostController.swift
//  3rdplanet
//
//  Created by zeus on 3/8/17.
//  Copyright © 2017 justzeus. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

extension PostController {
    static let PostsChangedNotification = Notification.Name("PostsChangedNotification")
    static let PostCommentsChangedNotification = Notification.Name("PostCommentsChangedNotification")
}

class PostController {
    
    static let sharedController = PostController()
    
    var posts = [Post]() {
        didSet {
            DispatchQueue.main.async {
                let nc = NotificationCenter.default
                nc.post(name: PostController.PostsChangedNotification, object: self)
            }
        }
    }
    
    var comments: [Comment] {
        return posts.flatMap { $0.comments }
    }
    
    var sortedPosts: [Post] {
        return posts.sorted(by: { return $0.timestamp.compare($1.timestamp as Date) == .orderedDescending })
    }
    
    var isSyncing: Bool = false
    
    var cloudKitManager = CloudKitManager()
    
    
    
    init(){
        
        cloudKitManager = CloudKitManager()
        
        performFullSync()
        
        subscribeToNewPosts { (success, error) in
            if success {
                print("Successfully subscribed to new posts")
            }
        }
    }
    
    // CRUD
    
    func createPost(image: UIImage, caption: String, completion: ((Post) -> Void)? = nil)
    {
        // Sets the properties of the jpg image
        guard let data = UIImageJPEGRepresentation(image, 1.0) else { return }
        let post = Post(photoData: data)
        
        // adds post to first cell every time
        posts.insert(post, at: 0)
        
        cloudKitManager.saveRecord(CKRecord(post)) { (record, error) in
            guard let record = record else { return }
            post.cloudKitRecordID = record.recordID
            let _ = self.addComment(post: post, commentText: caption)
            if let error = error {
                print("Error saving new post to CloudKit: \(error)")
                
            }
            completion?(post)
        }
    }
    
    func addComment(post: Post, commentText: String, completion: @escaping ((Comment) -> Void) = { _ in }) -> Comment {
        let comment = Comment(post: post, text: commentText)
        post.comments.append(comment)
        
        
        
        cloudKitManager.saveRecord(CKRecord(comment)) { (record, error) in
            if let error = error {
                print("Error saving new comment to CloudKit: \(error)")
            }
            comment.cloudKitRecordID = record?.recordID
            completion(comment)
        }
        
        DispatchQueue.main.async {
            let nc = NotificationCenter.default
            nc.post(name: PostController.PostCommentsChangedNotification, object: post)
        }
        return comment
    }
    
    // Helper Functions
    
    private func recordsOf(type: String) -> [CloudKitSyncable] {
        switch type {
        case "Post":
            return posts.flatMap { $0 as CloudKitSyncable }
        case "Comment":
            return comments.flatMap { $0 as CloudKitSyncable }
        default:
            return []
        }
    }
    
    func syncedRecords(ofType type: String) -> [CloudKitSyncable] {
        
        return recordsOf(type: type).filter { $0.isSynced }
    }
    
    func unsyncedRecords(ofType type: String) -> [CloudKitSyncable] {
        return recordsOf(type: type).filter { !$0.isSynced }
    }
    
    func fetchNewRecords(ofType type: String, completion: @escaping (() -> Void) = { _ in }) {
        
        var referencesToExclude = [CKReference]()
        
        var predicate: NSPredicate
        
        referencesToExclude = self.syncedRecords(ofType: type).flatMap {$0.cloudKitReference }
        predicate = NSPredicate(format: "NOT(recordID IN %@)", argumentArray: [referencesToExclude])
        
        if referencesToExclude.isEmpty {
            predicate = NSPredicate(value: true)
        }
        
        cloudKitManager.fetchRecordsWithType(type, predicate: predicate, recordFetchedBlock: { (record) in
            switch type {
            case Post.kType:
                if let post = Post(record: record) {
                    self.posts.append(post)
                }
            case Comment.kType:
                guard let postReference = record[Comment.kPost] as? CKReference,
                    let comment = Comment(record: record) else { return }
                let matchingPost = PostController.sharedController.posts.filter({$0.cloudKitRecordID == postReference.recordID}).first
                matchingPost?.comments.append(comment)
            default:
                return
            }
            
        }) { (records, error) in
            if let error = error {
                print("Error fetching CloudKit records of type \(type): \(error)")
            }
            completion()
        }
        
    }
    
    func pushChangesToCloudKit(completion: @escaping ((_ success: Bool, Error?) -> Void) = { _,_ in }) {
        
        let unsavedPosts = unsyncedRecords(ofType: Post.kType) as? [Post] ?? []
        let unsavedComments = unsyncedRecords(ofType: Comment.kType) as? [Comment] ?? []
        var unsavedObjectsByRecord = [CKRecord: CloudKitSyncable]()
        
        for post in unsavedPosts {
            let record = CKRecord(post)
            unsavedObjectsByRecord[record] = post
        }
        for comment in unsavedComments {
            let record = CKRecord(comment)
            unsavedObjectsByRecord[record] = comment
        }
        
        let unsavedRecords = Array(unsavedObjectsByRecord.keys)
        
        cloudKitManager.saveRecords(unsavedRecords, perRecordCompletion: { (record, error) in
            
            guard let record = record else { return }
            unsavedObjectsByRecord[record]?.cloudKitRecordID = record.recordID
            
        }) { (records, error) in
            
            let success = records != nil
            completion(success, error)
        }
    }
    
    //MARK: - Sync
    
    func performFullSync(completion: @escaping (() -> Void) = { _ in }) {
        
        guard !isSyncing else {
            completion()
            return
        }
        
        isSyncing = true
        
        pushChangesToCloudKit { (success, error) in
            if success {
                self.fetchNewRecords(ofType: Post.kType) {
                    
                    self.fetchNewRecords(ofType: Comment.kType) {
                        
                        self.isSyncing = false
                        
                        completion()
                    }
                }
            }
        }
    }
    
    //MARK: - Subscription functions
    
    func subscribeToNewPosts(completion: @escaping (( _ success: Bool, Error?) -> Void) = { _,_ in }) {
        
        let predicate = NSPredicate(value: true)
        
        cloudKitManager.subscribe(Post.kType, predicate: predicate, subscriptionID: "allPosts", contentAvailable: true, options: .firesOnRecordCreation) { (subscription, error) in
            let success = subscription != nil
            completion(success, error)
        }
        
    }
    
    func addSubscriptionToPostComments(post: Post, alertBody: String?, completion: @escaping ((Bool, Error?) -> Void) = { _, _ in }) {
        
        guard let recordID = post.cloudKitRecordID else { fatalError("Unable to create reference for subscription.") }
        
        let predicate = NSPredicate(format: "post == %@", argumentArray: [recordID])
        
        cloudKitManager.subscribe(Comment.kType, predicate: predicate, subscriptionID: recordID.recordName, contentAvailable: true, alertBody: alertBody, desiredKeys: [Comment.kText, Comment.kPost], options: .firesOnRecordCreation) { (subscription, error) in
            
            let success = subscription != nil
            completion(success, error)
        }
    }
    
    func removeSubscriptionToPostComments(post: Post, completion: @escaping ((Bool, Error?) -> Void) = { _,_ in}) {
        
        guard let subscriptionID = post.cloudKitRecordID?.recordName else {
            completion(true, nil)
            return
        }
        
        cloudKitManager.unsubscribe(subscriptionID) { (subscriptionID, error) in
            let success = subscriptionID != nil && error == nil
            completion(success, error)
        }
    }
    
    func checkSubscriptionToPostComments(post: Post, completion: @escaping ((_ subscribed: Bool) -> Void) = { _ in}) {
        
        guard let subscriptionID = post.cloudKitRecordID?.recordName else {
            completion(false)
            return
        }
        
        cloudKitManager.fetchSubscription(subscriptionID) { (subscription, error) in
            let subscribed = subscription != nil
            completion(subscribed)
        }
        
    }
    
    func togglePostCommentSubscription(post: Post, completion: @escaping ((_ success: Bool, _ isSubscribed: Bool, Error?) -> Void) = { _,_,_ in }) {
        
        guard let subscriptionID = post.cloudKitRecordID?.recordName else {
            completion(false, false, nil)
            return
        }
        
        cloudKitManager.fetchSubscription(subscriptionID) { (subscription, error) in
            
            if subscription != nil {
                self.removeSubscriptionToPostComments(post: post, completion: { (success, error) in
                    completion(success, false, error)
                })
            } else {
                self.addSubscriptionToPostComments(post: post, alertBody: "Someone commented on a post you follow! 😎") { (success, error) in
                    completion(success, true, error)
                }
            }
        }
    }
}

