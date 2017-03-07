//
//  CloudKitSyncable.swift
//  3rdplanet
//
//  Created by zeus on 2/9/17.
//  Copyright © 2017 justzeus. All rights reserved.
//

import Foundation
import CloudKit

protocol CloudKitSyncable {
    
    init?(record: CKRecord)
    
    var cloudKitRecordID: CKRecordID? { get set }
    var recordType: String { get }
}

extension CloudKitSyncable {
    
    var isSynced: Bool {
        return cloudKitRecordID != nil
    }
    var cloudKitReference:  CKReference? {
        guard let recordID = cloudKitRecordID else { return nil }
        
        return CKReference(recordID: recordID, action: .deleteSelf)
    }
}
