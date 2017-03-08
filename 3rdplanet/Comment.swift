//
//  Comment.swift
//  3rdplanet
//
//  Created by zeus on 3/7/17.
//  Copyright © 2017 justzeus. All rights reserved.
//

import Foundation
import CloudKit

class Comment: SearchableRecord, CloudKitSyncable {
    
    static let kType = "Comment"
    static let kText = "text"
    static let kTimestamp = "timestamp"
    static let kPost = "post"
    
    var text: String
    var timestamp: Date
    var post: Post?
    
    init(post: Post?, text: String, timestamp: Date = Date()) {
        self.text = text
        self.timestamp = timestamp
        self.post = post
        
    }
    
    //MARK: - CloudKitSyncable
    
    var cloudKitRecordID: CKRecordID?
    var recordType: String {
        return Comment.kType
    }
    
    convenience required init?(record: CKRecord) {
        
        guard let timestamp = record.creationDate,
            let text = record[Comment.kText] as? String else { return nil }
        
        self.init( post: nil, text: text, timestamp: timestamp)
        cloudKitRecordID = record.recordID
        
    }
    // SearchableRecord Delegate function
    func matches(searchTerm: String) -> Bool {
        return text.contains(searchTerm)
    }
}


extension CKRecord {
    
    convenience init(_ comment: Comment) {
        guard let post = comment.post else {
            fatalError("Comment does not have a Post relationship")
        }
        let postRecordID = post.cloudKitRecordID ?? CKRecord(post).recordID
        let recordID = CKRecordID(recordName: UUID().uuidString)
        
        self.init(recordType: comment.recordType, recordID: recordID)
        
        self[Comment.kTimestamp] = comment.timestamp as CKRecordValue?
        self[Comment.kText] = comment.text as CKRecordValue?
        self[Comment.kPost] = CKReference(recordID: postRecordID, action: .deleteSelf)
    }
    
    
}


