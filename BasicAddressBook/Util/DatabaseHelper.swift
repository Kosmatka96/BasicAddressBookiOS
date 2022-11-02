//
//  DatabaseHelper.swift
//  BasicAddressBook
//
//  Created by Vaughn Kosmatka on 10/31/22.
//

import Foundation

class DatabaseHelper {
    let shared = DatabaseHelper()
    
    func importAllContacts(formatInJSON: Bool) {
        if (formatInJSON) {
            // import contact list from JSON resource
        }
        else {
            // import contact list from XML resource
        }
    }
}
