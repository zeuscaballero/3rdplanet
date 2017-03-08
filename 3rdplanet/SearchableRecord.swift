//
//  SearchableRecord.swift
//  3rdplanet
//
//  Created by zeus on 3/8/17.
//  Copyright © 2017 justzeus. All rights reserved.
//

import Foundation

protocol SearchableRecord {
    func matches(searchTerm: String) -> Bool
}
