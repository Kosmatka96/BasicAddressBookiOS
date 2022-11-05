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

  // Constants
  static let entityName = "Contact"
  static let filePathXmlResource = "resource_xml.xml"
  static let filePathJsonResource = "resource_json.json"
  static let importStyleXML = "xml"
  static let importStyleJSON = "json"
  
  // UserDefault keys for storing user preferences
  static let keyImportTypePreference = "userDefaults_importTylePreference"
  static let keySortPreference = "userDefaults_sortPreference"
  
  // Contact-related fields
  static let tagAddressBook = "AddressBook"
  static let tagContact = "Contact"
  static let tagCustomerId = "customerId"
  static let tagCompanyName = "companyName"
  static let tagContactName = "contactName"
  static let tagContactTitle = "contactTitle"
  static let tagAddress = "address"
  static let tagCity = "city"
  static let tagCountry = "country"
  static let tagPhone = "phone"
  static let tagEmail = "email"
  static let tagPostalCode = "postalCode"
  static let tagFax = "fax"
  static let tagGroupId = "groupId"
  
  // singleton
  static let shared = DbHelper()
  
  
  public func importAllContacts() {
    // check which style of import is set
    let formatInJSON: Bool = UserDefaults.standard.string(forKey: DbHelper.keyImportTypePreference)?.caseInsensitiveCompare(DbHelper.importStyleJSON) == .orderedSame
    
    // get object list of contacts from xml and json parsers
    let contactList: Array<ContactModel> =
    formatInJSON ? loadContactListFromJSONResource() : XMLHelper.shared.loadFromResource()
    
    // add this new list of objects to the database
    for contact in contactList {
      addContactToDatabase(contact)
    }
  }
  
  public func addContactToDatabase(_ c: ContactModel) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    
    // create new instance to be inserted into database
    let contact = NSEntityDescription.insertNewObject(forEntityName: DbHelper.entityName,
                                                      into: managedContext) as! Contact
    updateContactDataObjectWithModel(contact: contact, c: c)
    saveToDatabase(managedContext: managedContext)
  }
  
  public func doesContactExistInDatabase(_ c: ContactModel) -> Bool {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    let contactFetch = NSFetchRequest<NSFetchRequestResult>(entityName: DbHelper.entityName)
    let predicate = NSPredicate(format:  "\(DbHelper.tagCustomerId) = %@", c.customerId!)
    contactFetch.predicate = predicate
    
    // count all instances of matching contact in database using customerId
    do {
      let contactList = try managedContext.fetch(contactFetch) as! [Contact]
      if (!contactList.isEmpty) {
        return true
      }
    } catch {
        fatalError("Failed to determine if duplicate contact exists: \(error)")
    }

    saveToDatabase(managedContext: managedContext)
    return false
  }
  
  public func addDuplicateContactToDatabase(_ c: ContactModel) {
    // using the customerId get a list of all matching contacts to figure out what groupId to assign
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    let contactFetch = NSFetchRequest<NSFetchRequestResult>(entityName: DbHelper.entityName)
    let predicate = NSPredicate(format:  "\(DbHelper.tagCustomerId) = %@", c.customerId!)
    contactFetch.predicate = predicate
    
    // make sure to order by groupId so the last index will have the greatest value
    let orderBy: String = DbHelper.tagGroupId
    let sortDescriptor = NSSortDescriptor(key: orderBy, ascending: true)
    let sortDescriptors = [sortDescriptor]
    contactFetch.sortDescriptors = sortDescriptors
    
    // increment the greatest groupId found in table by 1 to ensure unique groupId
    do {
      let contactList = try managedContext.fetch(contactFetch) as! [Contact]
      // print error if there is more or less than a single instance
      if (contactList.isEmpty) {
        print("[ERROR]: Unable to add duplicate contact! matched contacts:\(contactList.count)")
      }
      else {
        // increment groupId to be unique and add to database
        var duplicateContact = c
        duplicateContact.groupId = Int64(contactList.last!.groupId + 1)
        addContactToDatabase(duplicateContact)
      }
      
    } catch {
        fatalError("Failed to fetch contacts: \(error)")
    }

    saveToDatabase(managedContext: managedContext)
  }
  
  public func updateSpecificContactInDatbase(_ c: ContactModel) {
    // find the specific matching contact, based on customerId and the smallest groupId
    // and apply all other incoming values to it
    // using the customerId get a list of all matching contacts to figure out what groupId to assign
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    let contactFetch = NSFetchRequest<NSFetchRequestResult>(entityName: DbHelper.entityName)
    let predicate = NSPredicate(format:  "\(DbHelper.tagCustomerId) = %@", c.customerId!)
    contactFetch.predicate = predicate
    
    do {
      let contactList = try managedContext.fetch(contactFetch) as! [Contact]
      // print error if there is more or less than a single instance
      if (contactList.isEmpty) {
        print("[ERROR]: Unable to update specific contact! No existing contact found!")
      }
      else {
        var contactModel = c
        contactModel.groupId = contactList[0].groupId // override groupId with fetched contact
        updateContactDataObjectWithModel(contact: contactList[0], c: contactModel)
      }
      
    } catch {
        fatalError("Failed to fetch contacts: \(error)")
    }

    saveToDatabase(managedContext: managedContext)
  }
  
  func updateContactDataObjectWithModel(contact: Contact, c: ContactModel) {
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
    contact.groupId = c.groupId
  }
  
  public func getAllContactsAsObjects(filterBy: String?) -> Array<ContactModel> {
    // fetch list of all contacts from database
    var dataList: Array<Contact> = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    let contactFetch = NSFetchRequest<NSFetchRequestResult>(entityName: DbHelper.entityName)
    
    let orderBy: String = UserDefaults.standard.string(forKey: DbHelper.keySortPreference) ?? DbHelper.tagCustomerId
     
    if (filterBy != nil && !filterBy!.isEmpty) {
      let predicate = NSPredicate(format: "\(orderBy) LIKE[c] %@ OR \(orderBy) CONTAINS[c] %@", filterBy!, filterBy!)
      contactFetch.predicate = predicate
    }
    else {
      let sortDescriptor = NSSortDescriptor(key: orderBy, ascending: true)
      let sortDescriptors = [sortDescriptor]
      contactFetch.sortDescriptors = sortDescriptors
    }
    
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
  
  func deleteContactFromDatabase(_ c: ContactModel) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext = appDelegate.persistentContainer.viewContext
    
    // using the customerId and groupId we should find a single Contact to delete
    let contactFetch = NSFetchRequest<NSFetchRequestResult>(entityName: DbHelper.entityName)
    let predicate = NSPredicate(format:  "\(DbHelper.tagCustomerId) = %@ AND \(DbHelper.tagGroupId) = %d", c.customerId!, c.groupId)
    contactFetch.predicate = predicate
    
    do {
      let contactList = try managedContext.fetch(contactFetch) as! [Contact]
      // print error if there is more or less than a single instance
      if (contactList.isEmpty || contactList.count > 1) {
        print("[ERROR]: Unable to delete contact! contactListCount:\(contactList.count)")
      }
      else {
        managedContext.delete(contactList[0])
      }
      
    } catch {
        fatalError("Failed to fetch contacts: \(error)")
    }

    saveToDatabase(managedContext: managedContext)
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
    
    saveToDatabase(managedContext: managedContext)
  }
  
  func saveToDatabase(managedContext: NSManagedObjectContext) {
    do {
        try managedContext.save()
    } catch {
        print("Could not save.", error.localizedDescription)
    }
  }
  
  func loadContactListFromJSONResource() -> Array<ContactModel> {
    var contactList: Array<ContactModel> = []
    let jsonData = Bundle.main.getFileData(DbHelper.filePathJsonResource)
    do {
      
      let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options:
                          JSONSerialization.ReadingOptions.mutableContainers)
      
      if let jsonResult = jsonResult as? [String: Any] {
        
        let firstVal = jsonResult.first
        if (firstVal?.key == DbHelper.tagAddressBook) {
          let addressBookDict = firstVal?.value as? [String: Any]
          if (addressBookDict?.first?.key == DbHelper.tagContact) {
            let jsonDictArr: [[String: Any]] = (addressBookDict?.first?.value as? [[String: Any]])!
            contactList = jsonDictArr.map { ContactModel(details: $0) }
          }
          
        }
      }
    }
    catch {
      print("Could not load json data.", error)
    }
  
    return contactList
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
