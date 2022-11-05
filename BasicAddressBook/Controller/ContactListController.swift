//
//  ContactListController.swift
//  BasicAddressBook
//
//  Controller for the Create Contact Screen
//

import Foundation
import UIKit
import MessageUI
import CoreLocation
import MapKit

protocol ContactListControllerDelegate : UISplitViewController {
  func contactListControllerDidTapDrawer(_ contactListController: ContactListController)
  func contactListControllerUpdateContact(_ contact: ContactModel)
}

class ContactListController : UIViewController, UIActionSheetDelegate, ContactListViewDelegate,
                              MFMailComposeViewControllerDelegate {

  var drawerDelegate: ContactListControllerDelegate?
  var contactListView: ContactListView!
  var contactListData: Array<ContactModel> = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // apply default value for sorting preference
    let savedSortPref = UserDefaults.standard.string(forKey: DbHelper.keySortPreference)
    if (savedSortPref == nil) {
      UserDefaults.standard.set(DbHelper.tagCustomerId, forKey: DbHelper.keySortPreference)
    }
    
    // apply default value for import style preference
    let savedImportPref = UserDefaults.standard.string(forKey: DbHelper.keyImportTypePreference)
    if (savedImportPref == nil) {
      UserDefaults.standard.set(DbHelper.importStyleXML, forKey: DbHelper.keyImportTypePreference)
    }
    
    // create custom view and pass delegate to handle menu options
    contactListView = ContactListView(frame: view.frame)
    view = contactListView
    contactListView.contactListControllerDelegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    refreshListTable(filterBy: nil)
  }
  
  func refreshListTable(filterBy: String?) {
    // replace list with new fetch from database, keeping in mind current ordering
    contactListData = DbHelper.shared.getAllContactsAsObjects(filterBy: filterBy)
    contactListView.updateContactListData(data: contactListData) // signal tableView to update with our new list
  }
  
  func removeData() {
    // actually remove data in database
    DbHelper.shared.removeAllContacts()
    contactListData.removeAll()
    contactListView.updateContactListData(data: nil)
  }
  
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    if let _ = error {
       self.dismiss(animated: true, completion: nil)
    }
    switch result {
       case .cancelled:
       print("Cancelled")
       break
       case .sent:
       print("Mail sent successfully")
       break
       case .failed:
       print("Sending mail failed")
       break
       default:
       break
    }
    controller.dismiss(animated: true, completion: nil)
  }
  
}

extension ContactListController {
  
  func contactListViewSearchTextChanged(_ contactListView: ContactListView, text: String) {
    refreshListTable(filterBy: text)
  }
  
  func contactListViewDidTapDrawer(_ contactListView: ContactListView) {
    drawerDelegate?.contactListControllerDidTapDrawer(self)
  }
  
  func didTapContact(contact: ContactModel) {
    let contactId: String = String(format: "%@ (#%d)", contact.customerId!, contact.groupId)
    let alertTitle = NSLocalizedString("Contact Selected: \(contactId)", comment: "")
    let alertMessage = NSLocalizedString("Please choose an option for this Contact", comment: "")
    let alertController:UIAlertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
    
    let updateAction:UIAlertAction = UIAlertAction(title: NSLocalizedString("Update", comment: ""), style: UIAlertAction.Style.default) { UIAlertAction in
      self.drawerDelegate?.contactListControllerUpdateContact(contact)
    }
    
    let deleteAction:UIAlertAction = UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive) { UIAlertAction in
      DbHelper.shared.deleteContactFromDatabase(contact)
      self.refreshListTable(filterBy: nil)
    }
    
    let dismissAction:UIAlertAction = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default) { UIAlertAction in
      
    }
    
    alertController.addAction(updateAction)
    alertController.addAction(deleteAction)
    alertController.addAction(dismissAction)
    present(alertController, animated: true)
  }
  
  func didTapEmail(email: String) {
    if (!email.isEmpty) {
      if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.setToRecipients(["\(email)"])
            mail.setSubject("Sample Subject")
            mail.setMessageBody("Sample Body", isHTML: true)
            mail.mailComposeDelegate = self
            present(mail, animated: true)
      }
      else { print("[ERROR]: Email cannot be sent") }
    }
  }
  
  func didTapPhone(phone: String) {
    if (!phone.isEmpty) {
      if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
          if #available(iOS 10, *) {
              UIApplication.shared.open(url)
          } else {
              UIApplication.shared.openURL(url)
          }
      }
    }
  }
  
  func didTapAddress(address: String) {
    if (!address.isEmpty) {
      let geoCoder = CLGeocoder()
      geoCoder.geocodeAddressString(address) { (placemarks, error) in
          guard
              let placemarks = placemarks,
              let location = placemarks.first?.location
          else {
              print("[ERROR]: NO location found for: \(address)")
              return
          }
          
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate, addressDictionary: nil))
        mapItem.name = "Destination"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
      }
    }
  }
  
  func contactListViewDidTapMenu(_ contactListView: ContactListView) {
    let mainAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    let sortAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Sort", comment: ""),
                                  style: .default , handler:{ (UIAlertAction)in
      self.displaySortMenu()
    })
    
    let importStyleAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Import Style", comment: ""),
                                  style: .default , handler:{ (UIAlertAction)in
      self.displayImportStyleMenu()
    })
    
    let importAllAction: UIAlertAction = UIAlertAction(
      title: NSLocalizedString("Import All Contacts", comment: ""), style: .default, handler:{ (UIAlertAction)in
        // perform database operation to import all contacts from a resource file
        DbHelper.shared.importAllContacts()
        self.refreshListTable(filterBy: nil)
    })
    
    let removeAllAction: UIAlertAction = UIAlertAction(
      title: NSLocalizedString("Remove All Contacts", comment: ""), style: .destructive, handler:{ (UIAlertAction)in
        self.removeData()
    })
    
    let dismissAllAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""),
                                  style: .cancel, handler:{ (UIAlertAction)in
    })

    mainAlert.addAction(sortAction)
    mainAlert.addAction(importStyleAction)
    mainAlert.addAction(importAllAction)
    mainAlert.addAction(removeAllAction)
    mainAlert.addAction(dismissAllAction)
    
    self.present(mainAlert, animated: true, completion: { })
  }
  
  func displayImportStyleMenu() {
    let importStyleAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let xmlAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Import as XML", comment: ""),
                                                 style: .default , handler:{ (UIAlertAction)in
      UserDefaults.standard.set(DbHelper.importStyleXML, forKey: DbHelper.keyImportTypePreference)
    })
    let jsonAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Import as JSON", comment: ""),
                                  style: .default, handler:{ (UIAlertAction)in
      UserDefaults.standard.set(DbHelper.importStyleJSON, forKey: DbHelper.keyImportTypePreference)

    })
    let dismissAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""),
                                  style: .cancel, handler:{ (UIAlertAction)in
    })
    
    importStyleAlert.addAction(xmlAction)
    importStyleAlert.addAction(jsonAction)
    importStyleAlert.addAction(dismissAction)
    
    // disable the currently selected option
    let formatInJSON: Bool = UserDefaults.standard.string(forKey: DbHelper.keyImportTypePreference)?.caseInsensitiveCompare(DbHelper.importStyleJSON) == .orderedSame
    if (formatInJSON) {
      xmlAction.isEnabled = true
      jsonAction.isEnabled = false
    }
    else {
      xmlAction.isEnabled = false
      jsonAction.isEnabled = true
    }
    
    self.present(importStyleAlert, animated: true, completion: { })
  }
  
  func displaySortMenu() {
    let sortAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let customerIdAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Sort by Customer ID", comment: ""),
                                  style: .default , handler:{ (UIAlertAction)in
      UserDefaults.standard.set(DbHelper.tagCustomerId, forKey: DbHelper.keySortPreference)
      self.refreshListTable(filterBy: nil)
    })
    let companyNameAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Sort by Company Name", comment: ""),
                                  style: .default , handler:{ (UIAlertAction)in
      UserDefaults.standard.set(DbHelper.tagCompanyName, forKey: DbHelper.keySortPreference)
      self.refreshListTable(filterBy: nil)
    })
    let contactNameAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Sort by Contact Name", comment: ""),
                                  style: .default , handler:{ (UIAlertAction)in
      UserDefaults.standard.set(DbHelper.tagContactName, forKey: DbHelper.keySortPreference)
      self.refreshListTable(filterBy: nil)
    })
    let contactTitleAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Sort by Contact Title", comment: ""),
                                  style: .default , handler:{ (UIAlertAction)in
      UserDefaults.standard.set(DbHelper.tagContactTitle, forKey: DbHelper.keySortPreference)
      self.refreshListTable(filterBy: nil)
    })
    let addressAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Sort by Address", comment: ""),
                                  style: .default , handler:{ (UIAlertAction)in
      UserDefaults.standard.set(DbHelper.tagAddress, forKey: DbHelper.keySortPreference)
      self.refreshListTable(filterBy: nil)
    })
    let cityAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Sort by City", comment: ""),
                                  style: .default , handler:{ (UIAlertAction)in
      UserDefaults.standard.set(DbHelper.tagCity, forKey: DbHelper.keySortPreference)
      self.refreshListTable(filterBy: nil)
    })
    let emailAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Sort by Email", comment: ""),
                                  style: .default , handler:{ (UIAlertAction)in
      UserDefaults.standard.set(DbHelper.tagEmail, forKey: DbHelper.keySortPreference)
      self.refreshListTable(filterBy: nil)
    })
    let postalCodeAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Sort by Postal Code", comment: ""),
                                  style: .default , handler:{ (UIAlertAction)in
      UserDefaults.standard.set(DbHelper.tagPostalCode, forKey: DbHelper.keySortPreference)
      self.refreshListTable(filterBy: nil)
    })
    let countryAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Sort by Country", comment: ""),
                                  style: .default , handler:{ (UIAlertAction)in
      UserDefaults.standard.set(DbHelper.tagCountry, forKey: DbHelper.keySortPreference)
      self.refreshListTable(filterBy: nil)
    })
    let phoneAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Sort by Phone", comment: ""),
                                  style: .default , handler:{ (UIAlertAction)in
      UserDefaults.standard.set(DbHelper.tagPhone, forKey: DbHelper.keySortPreference)
      self.refreshListTable(filterBy: nil)
    })
    let faxAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Sort by Fax", comment: ""),
                                  style: .default , handler:{ (UIAlertAction)in
      UserDefaults.standard.set(DbHelper.tagFax, forKey: DbHelper.keySortPreference)
      self.refreshListTable(filterBy: nil)
    })
    let dismissAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""),
                                  style: .cancel, handler:{ (UIAlertAction)in
    })
    
    sortAlert.addAction(customerIdAction)
    sortAlert.addAction(companyNameAction)
    sortAlert.addAction(contactNameAction)
    sortAlert.addAction(contactTitleAction)
    sortAlert.addAction(addressAction)
    sortAlert.addAction(cityAction)
    sortAlert.addAction(emailAction)
    sortAlert.addAction(postalCodeAction)
    sortAlert.addAction(countryAction)
    sortAlert.addAction(phoneAction)
    sortAlert.addAction(faxAction)
    sortAlert.addAction(dismissAction)
    
    // disable the currently selected sorting preference
    let savedImportPref = UserDefaults.standard.string(forKey: DbHelper.keySortPreference)!
    
    if (savedImportPref.caseInsensitiveCompare(DbHelper.tagCustomerId) == .orderedSame) {
      customerIdAction.isEnabled = false
    }
    else if (savedImportPref.caseInsensitiveCompare(DbHelper.tagCompanyName) == .orderedSame) {
      companyNameAction.isEnabled = false
    }
    else if (savedImportPref.caseInsensitiveCompare(DbHelper.tagContactName) == .orderedSame) {
      contactNameAction.isEnabled = false
    }
    else if (savedImportPref.caseInsensitiveCompare(DbHelper.tagContactTitle) == .orderedSame) {
      contactTitleAction.isEnabled = false
    }
    else if (savedImportPref.caseInsensitiveCompare(DbHelper.tagAddress) == .orderedSame) {
      addressAction.isEnabled = false
    }
    else if (savedImportPref.caseInsensitiveCompare(DbHelper.tagCity) == .orderedSame) {
      cityAction.isEnabled = false
    }
    else if (savedImportPref.caseInsensitiveCompare(DbHelper.tagEmail) == .orderedSame) {
      emailAction.isEnabled = false
    }
    else if (savedImportPref.caseInsensitiveCompare(DbHelper.tagPostalCode) == .orderedSame) {
      postalCodeAction.isEnabled = false
    }
    else if (savedImportPref.caseInsensitiveCompare(DbHelper.tagCountry) == .orderedSame) {
      countryAction.isEnabled = false
    }
    else if (savedImportPref.caseInsensitiveCompare(DbHelper.tagPhone) == .orderedSame) {
      phoneAction.isEnabled = false
    }
    else if (savedImportPref.caseInsensitiveCompare(DbHelper.tagFax) == .orderedSame) {
      faxAction.isEnabled = false
    }
    
    self.present(sortAlert, animated: true, completion: { })
  }
  
}
