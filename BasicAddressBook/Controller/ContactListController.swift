//
//  ContactListController.swift
//  BasicAddressBook
//
//  Controller for the Create Contact Screen
//

import Foundation
import UIKit

protocol ContactListControllerDelegate : UISplitViewController {
  func contactListControllerDidTapDrawer(_ contactListController: ContactListController)
}

class ContactListController : UIViewController, UIActionSheetDelegate, ContactListViewDelegate {

  var drawerDelegate: ContactListControllerDelegate?
  var contactListView: ContactListView!
  var contactListData: Array<ContactModel> = []
  var sortPreference: String = DbHelper.tagCustomerId
  var importStylePreference: String = DbHelper.importStyleXML
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    contactListView = ContactListView(frame: view.frame)
    view = contactListView
    contactListView.contactListControllerDelegate = self
    contactListView.updateContactListData(data: contactListData)
  }
  
  func refreshListTable() {
    // replace list with new fetch from database, keeping in mind current ordering
    contactListData = DbHelper.shared.getAllContactsAsObjects(orderBy: self.sortPreference)
    contactListView.updateContactListData(data: contactListData) // signal tableView to update with our new list
  }
  
  func removeData() {
    // actually remove data in database
    DbHelper.shared.removeAllContacts()
    contactListData.removeAll()
    contactListView.updateContactListData(data: nil)
  }
  
}

extension ContactListController {
  func contactListViewDidTapDrawer(_ contactListView: ContactListView) {
    drawerDelegate?.contactListControllerDidTapDrawer(self)
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
      title: NSLocalizedString("Import All Contacts", comment: ""),
      style: .default ,
      handler:{ (UIAlertAction)in
        // perform database operation to import all contacts from a resource file
        DbHelper.shared.importAllContacts(formatInJSON: self.importStylePreference.caseInsensitiveCompare(DbHelper.importStyleJSON) == .orderedSame)
        self.refreshListTable()
    })
    
    let removeAllAction: UIAlertAction = UIAlertAction(
      title: NSLocalizedString("Remove All Contacts", comment: ""),
      style: .destructive,
      handler:{ (UIAlertAction)in
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
    
    self.present(mainAlert, animated: true, completion: {
      
    })
  }
  
  func displayImportStyleMenu() {
    let importStyleAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let xmlAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Import as XML", comment: ""),
                                                 style: .default , handler:{ (UIAlertAction)in
      self.importStylePreference = DbHelper.importStyleXML
    })
    let jsonAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Import as JSON", comment: ""),
                                  style: .default, handler:{ (UIAlertAction)in
      self.importStylePreference = DbHelper.importStyleJSON
    })
    let dismissAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""),
                                  style: .cancel, handler:{ (UIAlertAction)in
    })
    
    importStyleAlert.addAction(xmlAction)
    importStyleAlert.addAction(jsonAction)
    importStyleAlert.addAction(dismissAction)
    
    // disable the currently selected option
    if (importStylePreference.caseInsensitiveCompare(DbHelper.importStyleXML) == .orderedSame) {
      xmlAction.isEnabled = false
      jsonAction.isEnabled = true
    }
    else {
      xmlAction.isEnabled = true
      jsonAction.isEnabled = false
    }
    
    self.present(importStyleAlert, animated: true, completion: { })
  }
  
  func displaySortMenu() {
    let sortAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let customerIdAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Sort by Customer ID", comment: ""),
                                  style: .default , handler:{ (UIAlertAction)in
      self.sortPreference = DbHelper.tagCustomerId
      self.refreshListTable()
    })
    let companyNameAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Sort by Company Name", comment: ""),
                                  style: .default , handler:{ (UIAlertAction)in
      self.sortPreference = DbHelper.tagCompanyName
      self.refreshListTable()
    })
    let contactNameAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Sort by Contact Name", comment: ""),
                                  style: .default , handler:{ (UIAlertAction)in
      self.sortPreference = DbHelper.tagContactName
      self.refreshListTable()
    })
    let contactTitleAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Sort by Contact Title", comment: ""),
                                  style: .default , handler:{ (UIAlertAction)in
      self.sortPreference = DbHelper.tagContactTitle
      self.refreshListTable()
    })
    let addressAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Sort by Address", comment: ""),
                                  style: .default , handler:{ (UIAlertAction)in
      self.sortPreference = DbHelper.tagAddress
      self.refreshListTable()
    })
    let cityAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Sort by City", comment: ""),
                                  style: .default , handler:{ (UIAlertAction)in
      self.sortPreference = DbHelper.tagCity
      self.refreshListTable()
    })
    let emailAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Sort by Email", comment: ""),
                                  style: .default , handler:{ (UIAlertAction)in
      self.sortPreference = DbHelper.tagEmail
      self.refreshListTable()
    })
    let postalCodeAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Sort by Postal Code", comment: ""),
                                  style: .default , handler:{ (UIAlertAction)in
      self.sortPreference = DbHelper.tagPostalCode
      self.refreshListTable()
    })
    let countryAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Sort by Country", comment: ""),
                                  style: .default , handler:{ (UIAlertAction)in
      self.sortPreference = DbHelper.tagCountry
      self.refreshListTable()
    })
    let phoneAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Sort by Phone", comment: ""),
                                  style: .default , handler:{ (UIAlertAction)in
      self.sortPreference = DbHelper.tagPhone
      self.refreshListTable()
    })
    let faxAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Sort by Fax", comment: ""),
                                  style: .default , handler:{ (UIAlertAction)in
      self.sortPreference = DbHelper.tagFax
      self.refreshListTable()
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
    if (sortPreference.caseInsensitiveCompare(DbHelper.tagCustomerId) == .orderedSame) {
      customerIdAction.isEnabled = false
    }
    else if (sortPreference.caseInsensitiveCompare(DbHelper.tagCompanyName) == .orderedSame) {
      companyNameAction.isEnabled = false
    }
    else if (sortPreference.caseInsensitiveCompare(DbHelper.tagContactName) == .orderedSame) {
      contactNameAction.isEnabled = false
    }
    else if (sortPreference.caseInsensitiveCompare(DbHelper.tagContactTitle) == .orderedSame) {
      contactTitleAction.isEnabled = false
    }
    else if (sortPreference.caseInsensitiveCompare(DbHelper.tagAddress) == .orderedSame) {
      addressAction.isEnabled = false
    }
    else if (sortPreference.caseInsensitiveCompare(DbHelper.tagCity) == .orderedSame) {
      cityAction.isEnabled = false
    }
    else if (sortPreference.caseInsensitiveCompare(DbHelper.tagEmail) == .orderedSame) {
      emailAction.isEnabled = false
    }
    else if (sortPreference.caseInsensitiveCompare(DbHelper.tagPostalCode) == .orderedSame) {
      postalCodeAction.isEnabled = false
    }
    else if (sortPreference.caseInsensitiveCompare(DbHelper.tagCountry) == .orderedSame) {
      countryAction.isEnabled = false
    }
    else if (sortPreference.caseInsensitiveCompare(DbHelper.tagPhone) == .orderedSame) {
      phoneAction.isEnabled = false
    }
    else if (sortPreference.caseInsensitiveCompare(DbHelper.tagFax) == .orderedSame) {
      faxAction.isEnabled = false
    }
    
    self.present(sortAlert, animated: true, completion: {
      
    })
  }
  
}
