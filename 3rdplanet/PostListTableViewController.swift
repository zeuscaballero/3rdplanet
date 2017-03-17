//
//  PostListTableViewController.swift
//  3rdplanet
//
//  Created by zeus on 3/8/17.
//  Copyright © 2017 justzeus. All rights reserved.
//

import UIKit
import CloudKit

class PostListTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var searchController = UISearchController()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    let publicDatabase = CKContainer.default().publicCloudDatabase
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestFullSync()
        
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(self.activityIndicator)
        
        self.activityIndicator.startAnimating()

        
        setupSearchController()
        
        
        if tableView.numberOfRows(inSection: 0) > 0 {
            tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(postsChanged(_:)), name: PostController.PostsChangedNotification, object: nil)
        
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        let image = #imageLiteral(resourceName: "geography (1)")
        imageView.image = image
        navigationItem.titleView = imageView
        
    }
    
    func deleteRecordWithID(_ recordID: CKRecordID, completion: ((_ recordID: CKRecordID?, _ error: Error?) -> Void)?) {
        
        publicDatabase.delete(withRecordID: recordID) { (recordID, error) in
            completion?(recordID, error)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostController.sharedController.posts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell
        
        let post = PostController.sharedController.posts[indexPath.row]
        cell?.updateWithPost(post: post)
        
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.delete){
            let post = PostController.sharedController.posts[indexPath.row]
            
            PostController.sharedController.deletePost(post: post)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
            // take post.recordID and remove it from cloudkit
            // update your PostController.shared.posts to remove the post object
            
    }
  
    
    //MARK: - Actions
    
    
    func postsChanged(_ notification: Notification) {
        tableView.reloadData()
         self.activityIndicator.stopAnimating()
    }
    
    func setupSearchController() {
        
        let resultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultsTableViewController")
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.barTintColor = .white
        tableView.tableHeaderView = searchController.searchBar
        
        definesPresentationContext = true
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let resultsViewController = searchController.searchResultsController as? SearchResultsTableViewController,
            let searchTerm = searchController.searchBar.text?.lowercased() {
            let posts = PostController.sharedController.posts
            let filteredPosts = posts.filter {$0.matches(searchTerm: searchTerm) }.map { $0 as SearchableRecord }
            resultsViewController.resultsArray = filteredPosts
            resultsViewController.tableView.reloadData()
        }
    }
    
    
    @IBAction func refreshControlValueChanged(_ sender: UIRefreshControl) {
        requestFullSync {
            self.refreshControl?.endRefreshing()
        }
    }
    
    func requestFullSync(_ completion: (() -> Void)? = nil) {
        
         PostController.sharedController.performFullSync {
           
            completion?()
            
        }
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPostDetail" {
            
            if let detailViewController = segue.destination as? PostDetailTableViewController,
                let indexPath = self.tableView.indexPathForSelectedRow {
                
                let post = PostController.sharedController.posts[indexPath.row]
                detailViewController.post = post
            }
        }
        
        if segue.identifier == "toPostDetailFromSearch" {
            if let detailViewController = segue.destination as? PostDetailTableViewController,
                let sender = sender as? PostTableViewCell,
                let selectedIndexPath = (searchController.searchResultsController as? SearchResultsTableViewController)?.tableView.indexPath(for: sender),
                let searchTerm = searchController.searchBar.text?.lowercased() {
                
                let posts = PostController.sharedController.posts.filter({ $0.matches(searchTerm: searchTerm) })
                let post = posts[selectedIndexPath.row]
                
                detailViewController.post = post
            }
        }
    }
}
