//
//  PostTableViewCell.swift
//  3rdplanet
//
//  Created by zeus on 3/8/17.
//  Copyright © 2017 justzeus. All rights reserved.
//

import Foundation
import UIKit


class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    
    
    func updateWithPost(post: Post){
        postImageView.image = post.photo
        
    }
    
    var post: Post? {
        didSet {
            guard let post = post else { return }
            updateWithPost(post: post)
        }
    }
}
