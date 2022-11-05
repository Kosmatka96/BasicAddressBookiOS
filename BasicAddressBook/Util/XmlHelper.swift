//
//  XmlHelper.swift
//  BasicAddressBook
//
//  Helper class that parses the xml speicfically for Contacts
//

import Foundation

class XMLHelper: NSObject, XMLParserDelegate {
  
  static let shared = XMLHelper()

  var contactList: Array<ContactModel> = []
  var xmlDict = [String: Any]()
  var xmlDictArr = [[String: Any]]()
  var currentElement = ""
  
  func loadFromResource() -> Array<ContactModel> {
    let xmlResponseData = Bundle.main.getFileData(DbHelper.filePathXmlResource)
    let parser = XMLParser(data: xmlResponseData)
    parser.delegate = self
    parser.parse()
    return contactList
  }
  
  func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:])
  {
    if elementName == "AddressBook" {
      contactList.removeAll()
      xmlDictArr.removeAll()
    }
    else if elementName == DbHelper.tagContact {
      xmlDict = [:]
    }
    else {
      currentElement = elementName
    }
  }
  
  func parser(_ parser: XMLParser, foundCharacters string: String) {
      if !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
          if xmlDict[currentElement] == nil {
              xmlDict.updateValue(string, forKey: currentElement)
          }
      }
  }
  
  func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    if elementName == DbHelper.tagContact {
      xmlDictArr.append(xmlDict)
    }
  }
  
  func parserDidEndDocument(_ parser: XMLParser) {
      contactList = xmlDictArr.map { ContactModel(details: $0) }
  }
  
}
