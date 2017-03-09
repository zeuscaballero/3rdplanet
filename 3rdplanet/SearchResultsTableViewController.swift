//
//  SearchResultsTableViewController.swift
//  3rdplanet
//
//  Created by zeus on 3/8/17.
//  Copyright © 2017 justzeus. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
    
    
    
    
    var resultsArray: [SearchableRecord] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchResultsCell", for: indexPath) as? PostTableViewCell,
            let result = resultsArray[indexPath.row] as? Post else { return UITableViewCell() }
        
        
        cell.post = result
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        self.presentingViewController?.performSegue(withIdentifier: "toPostDetailFromSearch", sender: cell)
    }
}
