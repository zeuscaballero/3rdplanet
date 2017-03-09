//
//  PostDetailTableViewController.swift
//  3rdplanet
//
//  Created by zeus on 3/8/17.
//  Copyright © 2017 justzeus. All rights reserved.
//

import UIKit

class PostDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var followButton: UIBarButtonItem!
    
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        
        updateView()
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(postCommentsChanged(notification:)), name: PostController.PostCommentsChangedNotification, object: nil)
        
    }
    
    
    func updateView() {
        guard let post = post, isViewLoaded else { return }
        
        imageView.image = post.photo
        tableView.reloadData()
        
        
        
        PostController.sharedController.checkSubscriptionToPostComments(post: post) { (subscribed) in
            
            DispatchQueue.main.async {
                self.followButton.title = subscribed ? "Unfollow " : "Follow"
            }
        }
    }
    
    func postCommentsChanged(notification: Notification) {
        guard let notificationPost = notification.object as? Post,
            let post = post, notificationPost === post else { return }
        updateView()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return post?.comments.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        guard let post = post else { return cell }
        let comment = post.comments[indexPath.row]
        
        cell.textLabel?.text = comment.text
        cell.detailTextLabel?.text = comment.cloudKitRecordID?.recordName
        return cell
        
    }
    
    // Actions
    
    @IBAction func commentButtonTapped(_ sender: Any) {
        
        var commentTextField: UITextField?
        
        let alertController = UIAlertController(title: "Add Comment", message: "Enter a comment below", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter comment..."
            commentTextField = textField
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let addCommentAction = UIAlertAction(title: "OK", style: .default) { (_) in
            guard let comment = commentTextField?.text, !comment.isEmpty,
                let post = self.post else { return }
            
            let _ = PostController.sharedController.addComment(post: post, commentText: comment)
            self.tableView.reloadData()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addCommentAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func presentActivityViewController() {
        
        guard let photo = post?.photo,
            let comment = post?.comments.first else { return }
        
        let text = comment.text
        let activityViewController = UIActivityViewController(activityItems: [photo, text], applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func followButtonTapped(_ sender: Any) {
        
        guard let post = post else { return }
        PostController.sharedController.togglePostCommentSubscription(post: post) { (_, _, _) in
            self.updateView()
        }
        
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        
        presentActivityViewController()
    }
    
    
    
    
}
