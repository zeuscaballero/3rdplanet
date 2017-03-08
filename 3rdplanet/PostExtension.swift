//
//  PostExtension.swift
//  3rdplanet
//
//  Created by zeus on 3/8/17.
//  Copyright © 2017 justzeus. All rights reserved.
//

import Foundation


extension Post: SearchableRecord {
    
    func matches(searchTerm: String) -> Bool {
        let matchedComments = comments.filter { $0.matches(searchTerm: searchTerm) }
        return !matchedComments.isEmpty
    }
}
