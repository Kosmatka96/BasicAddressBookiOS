//
//  DatabaseHelper.swift
//  BasicAddressBook
//
//  Created by Vaughn Kosmatka on 10/31/22.
//

import Foundation
import CoreData
import UIKit

class DbHelper {
  
  // singleston
  static let shared = DbHelper()
  
  // Contact-related fields
  static let tagContact = "Contact"
  static let tagCustomerId = "customerId"
  static let tagCompanyName = "companyName"
  static let tagContactName = "contactName"
  static let tagContactTitle = "contactTitle"
  static let tagAddress = "address"
  static let tagCity = "city"
  static let tagCountry = "country"
  static let tagPhone = "phone"
  static let tagFax = "fax"
  static let tagEmail = "email"
  static let tagPostalCode = "postalCode"
  static let importStyleXML = "XML"
  static let importStyleJSON = "JSON"
  static let entityName = "Contact"
  
  public func importAllContacts(formatInJSON: Bool) {
    
    // get object list of contacts from xml and json parsers
    let contactList: Array<ContactModel> =
    formatInJSON ? loadContactListFromJSONResource() : XMLHelper.shared.loadFromResource()
    
    // add this new list of objects to the database
    for contact in contactList {
      addContactToDatabase(contact)
    }
  }
  
  func loadContactListFromJSONResource() -> Array<ContactModel> {
    var contactList: Array<ContactModel> = []
    return contactList
  }
  
  func addContactToDatabase(_ c: ContactModel) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    
    // create new instance to be inserted into database
    let contact = NSEntityDescription.insertNewObject(forEntityName: DbHelper.entityName,
                                                      into: managedContext) as! Contact
    contact.customerId = c.customerId
    contact.companyName = c.companyName
    contact.contactTitle = c.contactTitle
    contact.contactName = c.contactName
    contact.address = c.address
    contact.postalCode = c.postalCode
    contact.city = c.city
    contact.email = c.email
    contact.country = c.country
    contact.phone = c.phone
    contact.fax = c.fax
    
    // save to database
    do {
        try managedContext.save()
    } catch {
        print("Could not save.", error.localizedDescription)
    }
  }
  
  public func removeAllContacts() {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    let DelAllReqVar = NSBatchDeleteRequest(
      fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: DbHelper.entityName))
    do {
        try managedContext.execute(DelAllReqVar)
    }
    catch {
        print(error)
    }
    
    // save to database
    do {
        try managedContext.save()
    } catch {
        print("Could not save.", error.localizedDescription)
    }
  }
  
  public func getAllContactsAsObjects(orderBy: String?) -> Array<ContactModel> {
    // fetch list of all contacts from database
    var dataList: Array<Contact> = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    let contactFetch = NSFetchRequest<NSFetchRequestResult>(entityName: DbHelper.entityName)
    
    let sortDescriptor = NSSortDescriptor(key: orderBy, ascending: true)
    let sortDescriptors = [sortDescriptor]
    contactFetch.sortDescriptors = sortDescriptors
     
    do {
      dataList = try managedContext.fetch(contactFetch) as! [Contact]
    } catch {
        fatalError("Failed to fetch contacts: \(error)")
    }
    
    // convert data instance list to normal object list for easier handling
    var list: Array<ContactModel> = []
    for c in dataList {
      if (c.customerId != nil) {
        list.append(ContactModel(c: c))
      }
    }
    
    return list
  }
}

extension Bundle {
    func getFileData(_ file: String) -> Data {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) in bundle")
        }
        
        return data
    }
}
