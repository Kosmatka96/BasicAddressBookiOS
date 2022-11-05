//
//  ContactModel.swift
//  BasicAddressBook
//
//  Model for object use, represnets Contact in database
//

import Foundation

struct ContactModel : Decodable {
  var customerId: String?
  var companyName: String?
  var contactName: String?
  var contactTitle: String?
  var address: String?
  var city: String?
  var email: String?
  var postalCode: String?
  var country: String?
  var phone: String?
  var fax: String?
  var groupId: Int64 = 1
  
  init(details: [String: Any]) {
    let tagCustomerId = "CustomerID"
    let tagCompanyName = "CompanyName"
    let tagContactName = "ContactName"
    let tagContactTitle = "ContactTitle"
    let tagAddress = "Address"
    let tagCity = "City"
    let tagCountry = "Country"
    let tagPhone = "Phone"
    let tagFax = "Fax"
    let tagEmail = "Email"
    let tagPostalCode = "PostalCode"
    
    self.customerId = details[tagCustomerId] as? String ?? ""
    self.companyName = details[tagCompanyName] as? String ?? ""
    self.contactName = details[tagContactName] as? String ?? ""
    self.contactTitle = details[tagContactTitle] as? String ?? ""
    self.address = details[tagAddress] as? String ?? ""
    self.city = details[tagCity] as? String ?? ""
    self.email = details[tagEmail] as? String ?? ""
    self.postalCode = details[tagPostalCode] as? String ?? ""
    self.country = details[tagCountry] as? String ?? ""
    self.phone = details[tagPhone] as? String ?? ""
    self.fax = details[tagFax] as? String ?? ""
  }
  
  init() {
    
  }
  
  init(c: Contact) {
    self.customerId = c.customerId
    self.companyName = c.companyName
    self.contactTitle = c.contactTitle
    self.contactName = c.contactName
    self.address = c.address
    self.postalCode = c.postalCode
    self.city = c.city
    self.email = c.email
    self.country = c.country
    self.phone = c.phone
    self.fax = c.fax
    self.groupId = c.groupId
  }
}
