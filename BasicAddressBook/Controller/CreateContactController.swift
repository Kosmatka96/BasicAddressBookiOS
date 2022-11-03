//
//  CreateContactController.swift
//  BasicAddressBook
//
//  Controller for the Contact List Screen
//

import Foundation
import UIKit

protocol CreateContactControllerDelegate : UISplitViewController {
  func createContactControllerDidTapDrawer(_ createContactController: CreateContactController)
}

class CreateContactController : UIViewController, UIActionSheetDelegate, CreateContactViewDelegate {
  
  var createContactView: CreateContactView!
  var drawerDelegate: CreateContactControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    createContactView = CreateContactView(frame: view.frame)
    view = createContactView
    createContactView.createContactControllerDelegate = self
  }
}

extension CreateContactController {
  func createContactViewDidTapDrawer(_ createContactView: CreateContactView) {
    drawerDelegate?.createContactControllerDidTapDrawer(self)
  }
  
  func createContactViewDidTapMenu(_ createContactView: CreateContactView) {
    let mainAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

    mainAlert.addAction(UIAlertAction(title: NSLocalizedString("Add Contact", comment: ""),
                                  style: .default , handler:{ (UIAlertAction)in
        
    }))
    
    mainAlert.addAction(UIAlertAction(title: NSLocalizedString("Reset Entry", comment: ""),
                                  style: .destructive, handler:{ (UIAlertAction)in
      
    }))
    
    mainAlert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""),
                                  style: .cancel, handler:{ (UIAlertAction)in
    }))

    self.present(mainAlert, animated: true, completion: {
      
    })
  }
}
