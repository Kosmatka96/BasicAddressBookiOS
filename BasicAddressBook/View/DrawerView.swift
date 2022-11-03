//
//  MenuView.swift
//  BasicAddressBook
//
//  Created by Vaughn Kosmatka on 10/31/22.
//

import Foundation
import UIKit

protocol DrawerViewDelegate : AnyObject {
  func menuOptionSelectedInDrawerView(optionTitle: String)
}

class DrawerView: UIView, UITableViewDelegate, UITableViewDataSource {
  static let kMainMenuContactList: String = NSLocalizedString("Contact List", comment: "")
  static let kMainMenuCreateContact: String = NSLocalizedString("Create Contact", comment: "")
  let cellId: String = "cell_menu"
  var menuOptions = [kMainMenuContactList, kMainMenuCreateContact]
  var countOfContactsStr: String?
  var originalFrame: CGRect // the customized smaller bounds to contain menu panel
  var menuTableView: UITableView!  // contains menu options
  weak var drawerDelegate: DrawerViewDelegate?

  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init (frame : CGRect) {
    originalFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.width * 2 / 3, frame.size.height)
    super.init(frame : frame)
    
    // override view color and width
    backgroundColor = UIColor.systemBlue
    UIHelper.shared.setViewWidth(view: self, width: originalFrame.width)
    
    // Add a welcome image
    let welcomeImageView: UIImageView = UIImageView(image: UIImage(named: "address-icon"))
    welcomeImageView.frame = CGRectMake(20, originalFrame.height*0.08, originalFrame.width*0.35, originalFrame.width*0.35)
    addSubview(welcomeImageView)
    
    // Add a welcome label
    let welcomeLabel: UILabel = UIHelper.shared.labelWithWrappedHeight(
      pos: CGVector(dx: 20, dy: 0),
        text: "Basic Address Book by Theodore Kosmatka",
        font: UIFont.boldSystemFont(ofSize: 20),
        width: originalFrame.width)
    welcomeLabel.textColor = UIColor.white
    UIHelper.shared.placeViewUnderWithPadding(padding: 15,
                          changeView: welcomeLabel, topView: welcomeImageView)
    addSubview(welcomeLabel)
    
    // Add tableView for menu options
    menuTableView = UITableView(frame: CGRect(x: 0, y: 0, width: originalFrame.width, height: frame.height))
    menuTableView.isUserInteractionEnabled = true
    menuTableView.delegate = self
    menuTableView.dataSource = self
    menuTableView.backgroundColor = UIColor.blue
    menuTableView.autoresizingMask = AutoresizingMask.flexibleHeight
    menuTableView.tableHeaderView =
    UIView.init(frame: CGRect(x: 0, y: 0, width: originalFrame.width, height: 20))
    UIHelper.shared.placeViewUnderWithPadding(padding: 20, changeView: menuTableView, topView: welcomeLabel)
    addSubview(menuTableView)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuOptions.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell: UITableViewCell! =
    tableView.dequeueReusableCell(withIdentifier: cellId)

    if (cell == nil) {
      cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellId)
    
      // Add background colors, and text color
      cell.textLabel?.textColor = UIColor.white
      cell.backgroundColor = UIColor.clear
      let bgColorView = UIView()
      bgColorView.backgroundColor = UIColor.white
      cell.selectedBackgroundView = bgColorView
      
      // Add tap gesture
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapMenuOption(_:)))
      cell.addGestureRecognizer(tapGesture)
    }
    
    cell.tag = indexPath.row
    return renderCell(cell, menuOptions[indexPath.row])
  }
  
  @objc func didTapMenuOption(_ sender: UITapGestureRecognizer? = nil) {
    let cell: UITableViewCell = sender?.view as! UITableViewCell
    let text: String = (cell.textLabel?.text)!
    
    // Perform Menu item click
    cell.isSelected = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
      cell.isSelected = false
    }
    
    // Checking with menu title, perform menu navigation
    if (text.caseInsensitiveCompare(DrawerView.kMainMenuContactList) == .orderedSame ||
        text.caseInsensitiveCompare(DrawerView.kMainMenuCreateContact) == .orderedSame) { handleMenuOption(optionTitle: text)
    }
  }
  
  func renderCell(_ cell: UITableViewCell, _ title:String) -> UITableViewCell {
    // Contact List
    if (title.caseInsensitiveCompare(DrawerView.kMainMenuContactList) == .orderedSame) {
      cell.imageView?.image = UIHelper.shared.contactListImage()
      cell.textLabel?.text = DrawerView.kMainMenuContactList
      cell.detailTextLabel?.text = ""
      cell.accessoryType = UITableViewCell.AccessoryType.none
    }
    // Create Contact
    else if (title.caseInsensitiveCompare(DrawerView.kMainMenuCreateContact) == .orderedSame) {
      cell.imageView?.image = UIHelper.shared.createContactImage()
      cell.textLabel?.text = DrawerView.kMainMenuCreateContact
      cell.detailTextLabel?.text = ""
      cell.accessoryType = UITableViewCell.AccessoryType.none
    }
    return cell;
  }
  
  func updateLayout(isMenuExpanded: Bool) {
    let originX: CGFloat = (isMenuExpanded) ? 0 : -originalFrame.width*2
    UIHelper.shared.setViewX(view: self, originX: originX)
  }
  
  func animateLayout(isMenuExpanded: Bool) {
    let originX: CGFloat = (isMenuExpanded) ? 0 : -originalFrame.width
    UIView.animate(withDuration: 0.3, animations: { [self] in
      self.layoutIfNeeded()
      UIHelper.shared.setViewX(view: self, originX: originX)
    }) { (success) in }
  }
    
}

extension DrawerView {
  @objc fileprivate func handleMenuOption(optionTitle: String) { drawerDelegate?.menuOptionSelectedInDrawerView(optionTitle: optionTitle)
  }
}

