//
//  ContactListController.swift
//  BasicAddressBook
//
//  Created by Vaughn Kosmatka on 10/31/22.
//

import Foundation
import UIKit

class ContactListController : UIViewController {
  
  var contactListView: ContactListView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    contactListView = ContactListView(frame: CGRect(x: 0, y: 0,
                                                    width: view.frame.size.width,
                                                    height: view.frame.height))
    view.addSubview(contactListView!)
    
  }
  
}
