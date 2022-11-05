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
  func createContactControllerDidAddContact(_ createContactController: CreateContactController)
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
  
  public func updateWithPassedContact(_ contact: ContactModel) {
    createContactView.updateWithContact(contact: contact)
  }
}

extension CreateContactController {
  func createContactViewDidTapDrawer(_ createContactView: CreateContactView) {
    drawerDelegate?.createContactControllerDidTapDrawer(self)
  }
  
  // Display Create Contact menu options
  func createContactViewDidTapMenu(_ createContactView: CreateContactView) {
    let mainAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

    let addContactAction = UIAlertAction(title: NSLocalizedString("Add Contact", comment: ""),
                                  style: .default , handler:{ (UIAlertAction)in
      let addedContact = createContactView.getCurrentContact()
      if (DbHelper.shared.doesContactExistInDatabase(addedContact)) {
        // Duplicate exists in database, ask to duplicate, update, or cancel operation
        self.openDuplicateContactAlert(contact: addedContact)
      }
      else {
        // Contact does not exist in database, add immediately
        DbHelper.shared.addContactToDatabase(addedContact)
        self.openContactWasAddedAlert()
      }
    })
    
    let resetEntryAction = UIAlertAction(title: NSLocalizedString("Reset Entry", comment: ""),
                                  style: .destructive, handler:{ (UIAlertAction)in
      // set layout for an empty contact
      createContactView.updateWithContact(contact: ContactModel())
    })
    
    let dismissAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""),
                                  style: .cancel, handler:{ (UIAlertAction)in
    })

    mainAlert.addAction(addContactAction)
    mainAlert.addAction(resetEntryAction)
    mainAlert.addAction(dismissAction)
    
    // disable addContactAction if invalid customerId value
    let currentContact = createContactView.getCurrentContact()
    if (currentContact.customerId == nil || currentContact.customerId!.isEmpty) {
      addContactAction.isEnabled = false
    }
    
    self.present(mainAlert, animated: true, completion: {
      
    })
  }
  
  // Display contact was added, offer to navigate to contact list
  func openContactWasAddedAlert() {
    // getting to this alert means the entered contact was used, reset layout
    createContactView.updateWithContact(contact: ContactModel())
    
    let alertTitle = NSLocalizedString("Contact Added", comment: "")
    let alertMessage = NSLocalizedString("Navigate to contact list?", comment: "")
    let contactAddedAlert:UIAlertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
    contactAddedAlert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""),
                                  style: .default , handler:{ (UIAlertAction)in
      self.drawerDelegate?.createContactControllerDidAddContact(self)
    }))
    
    contactAddedAlert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""),
                                  style: .destructive, handler:{ (UIAlertAction)in
    }))

    self.present(contactAddedAlert, animated: true, completion: { })
  }
  
  // Display duplicate contact options
  func openDuplicateContactAlert(contact: ContactModel) {
    let alertTitle = NSLocalizedString("Duplicate Contact found!", comment: "")
    let alertMessage = NSLocalizedString("Update this contact or create duplicate? (update added to original instance)", comment: "")
    let duplicateAlertController:UIAlertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
    
    let updateAction:UIAlertAction = UIAlertAction(title: NSLocalizedString("Update", comment: ""), style: UIAlertAction.Style.default) { UIAlertAction in
      DbHelper.shared.updateSpecificContactInDatbase(contact)
      self.openContactWasAddedAlert()
    }
    
    let duplicate:UIAlertAction = UIAlertAction(title: "Duplicate", style: UIAlertAction.Style.default) { UIAlertAction in
      DbHelper.shared.addDuplicateContactToDatabase(contact)
      self.openContactWasAddedAlert()
    }
    
    let dismissAction:UIAlertAction = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default) { UIAlertAction in
      
    }
    
    duplicateAlertController.addAction(updateAction)
    duplicateAlertController.addAction(duplicate)
    duplicateAlertController.addAction(dismissAction)
    present(duplicateAlertController, animated: true)
  }
  
  // Display editable field to change associated label
  func openAlertToEditLabel(_ label: UILabel) {
    let alertTitle = NSLocalizedString("Edit Contact field", comment: "")
    let alertController:UIAlertController = UIAlertController(title: alertTitle, message: nil, preferredStyle: UIAlertController.Style.alert)
    
    alertController.addTextField { UITextField in
      UITextField.text = label.text
    }
    
    let saveAction:UIAlertAction = UIAlertAction(title: NSLocalizedString("Save", comment: ""), style: UIAlertAction.Style.default) { UIAlertAction in
      label.text = alertController.textFields?[0].text
    }
    
    let deleteAction:UIAlertAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive) { UIAlertAction in
      label.text = ""
    }
    
    let dismissAction:UIAlertAction = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default) { UIAlertAction in
      
    }
    
    alertController.addAction(saveAction)
    alertController.addAction(deleteAction)
    alertController.addAction(dismissAction)
    
    present(alertController, animated: true)
  }
}
