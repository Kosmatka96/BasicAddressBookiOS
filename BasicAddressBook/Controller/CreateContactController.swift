//
//  CreateContactController.swift
//  BasicAddressBook
//
//  Created by Vaughn Kosmatka on 10/31/22.
//

import Foundation
import UIKit

class CreateContactController : UIViewController {
  
  var createContactView: CreateContactView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    createContactView = CreateContactView(frame: CGRect(x: 0, y: 0,
                                                    width: view.frame.size.width,
                                                    height: view.frame.height))
    view.addSubview(createContactView!)
  }
}
