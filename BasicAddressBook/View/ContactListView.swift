//
//  ContactListView.swift
//  BasicAddressBook
//
//  View layout for the Contact List Screen, contains list of ContactCellViews and captures
//  when they are selected through ContactCellViewDelegate
//

import Foundation
import UIKit

protocol ContactListViewDelegate: UIViewController {
  func contactListViewDidTapDrawer(_ contactListView: ContactListView)
  func contactListViewDidTapMenu(_ contactListView: ContactListView)
  func contactListViewSearchTextChanged(_ contactListView: ContactListView, text: String)
  func didTapEmail(email: String)
  func didTapPhone(phone: String)
  func didTapAddress(address: String)
  func didTapContact(contact: ContactModel)
}

class ContactListView : UIView, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,
                        ContactCellViewDelegate {

  var titleLabel: UILabel!
  var contactTableView: UITableView?  // contains contact list
  let cellId: String = "cell_contact"
  let searchBar: UISearchBar
  var contactListData: Array<ContactModel> = []
  weak var contactListControllerDelegate: ContactListViewDelegate?
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init (frame : CGRect) {
    searchBar = UISearchBar.init(frame: frame)
    super.init(frame : frame)
    backgroundColor = .clear
    
    // Title Label + top banner
    titleLabel = UIHelper.shared.labelWithWrappedHeight(
      pos: CGVector(dx: frame.midX, dy: frame.height*0.068),
      text: NSLocalizedString("Contact List", comment: ""),
      font: UIFont.boldSystemFont(ofSize: 28),
      width: frame.width)
    titleLabel.textAlignment = NSTextAlignment.center
    titleLabel.center.x = center.x
    titleLabel.textColor = .white
    titleLabel.isUserInteractionEnabled = false
    let topBannerView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: titleLabel.frame.maxY + 10))
    topBannerView.backgroundColor = .systemBlue
    topBannerView.isUserInteractionEnabled = false
    addSubview(topBannerView)
    addSubview(titleLabel)
    
    // Menu Button
    let menuImage: UIImage = UIHelper.shared.menuButtonImage()
    let menuButton: UIButton = UIButton.init(frame: CGRect(x: frame.size.width-50, y: titleLabel.frame.origin.y-5, width: menuImage.size.width, height: menuImage.size.height))
    menuButton.setImage(menuImage, for: UIControl.State.normal)
    menuButton.setImage(UIHelper.shared.menuButtonImageHighlighted(), for: UIControl.State.highlighted)
    menuButton.isUserInteractionEnabled = true
    menuButton.isEnabled = true
    menuButton.addTarget(self, action: #selector(self.didTapMenu(_:)), for: UIControl.Event.touchUpInside)
    addSubview(menuButton)
    
    // Drawer Button
    let drawerImage: UIImage = UIImage(named: "hamburger-menu-icon")!
    let drawerButton: UIButton = UIButton.init(frame: CGRect(x: 15, y: titleLabel.frame.minY + drawerImage.size.height*0.5, width: drawerImage.size.width, height: drawerImage.size.height))
    drawerButton.setImage(drawerImage, for: UIControl.State.normal)
    //drawerButton.setImage(UIHelper.shared.menuButtonImageHighlighted(), for: UIControl.State.highlighted)
    drawerButton.isUserInteractionEnabled = true
    drawerButton.isEnabled = true
    drawerButton.addTarget(self, action: #selector(self.didTapDrawer(_:)), for: UIControl.Event.touchUpInside)
    addSubview(drawerButton)
    
    // Search Bar
    searchBar.sizeToFit()
    searchBar.delegate = self
    searchBar.setUnderView(topBannerView, withPadding: 0)
    addSubview(searchBar)
    
    // ContactTableView
    contactTableView = UITableView(frame: CGRectMake(0,0,frame.width,frame.height - topBannerView.frame.height))
    contactTableView?.isUserInteractionEnabled = true
    contactTableView?.delegate = self
    contactTableView?.dataSource = self
    contactTableView?.separatorColor = .clear
    contactTableView?.backgroundColor = .white
    contactTableView?.tableHeaderView =
    UIView.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: 10))
    contactTableView?.setUnderView(searchBar, withPadding: 0)
    contactTableView?.setHeight(height: frame.height - searchBar.frame.maxY)
    ContactCellView.lWidth = (contactTableView?.frame.size.width)!*0.45; // required override
    addSubview(contactTableView!)
  }
  
  @objc func didTapMenu(_ sender: UIButton!) { handleMenuTap() }
  
  @objc func didTapDrawer(_ sender: UIButton!) { handleDrawerTap() }
  
  func updateContactListData(data: Array<ContactModel>?) {
    // Update table data and get count of contacts
    var count: Int = 0
    if (data != nil && data!.count > 0) {
      count = data!.count
      contactListData = data!
    }
    else {
      contactListData.removeAll()
    }
    contactTableView?.reloadData()
    
    // Update title label with number of contacts
    titleLabel.text = "\((NSLocalizedString("Contact List", comment: ""))) (\(count))"
    titleLabel.center.x = center.x
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return contactListData.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return ContactCellView.getHeight(contact: contactListData[indexPath.row])
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell: ContactCellView? =
    tableView.dequeueReusableCell(withIdentifier: cellId) as? ContactCellView

    if (cell == nil) {
      cell = ContactCellView(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellId)
      cell?.contactListViewDelegate = self
    }
    
    cell?.tag = indexPath.row
    cell?.renderCellWithContact(contact: contactListData[indexPath.row])
    return cell!
  }
}

extension ContactListView {
  fileprivate func handleDrawerTap() {
    contactListControllerDelegate?.contactListViewDidTapDrawer(self)
  }
  
  fileprivate func handleMenuTap() {
    contactListControllerDelegate?.contactListViewDidTapMenu(self)
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    contactListControllerDelegate?.contactListViewSearchTextChanged(self, text: searchText)
  }
  
  func didTapContact(contact: ContactModel) {
    contactListControllerDelegate?.didTapContact(contact: contact)
  }
  
  func didTapEmailInCellView(email: String) {
    contactListControllerDelegate?.didTapEmail(email: email)
  }
  
  func didTapPhoneInCellView(phone: String) {
    contactListControllerDelegate?.didTapPhone(phone: phone)
  }
  
  func didTapAddressInCellView(address: String) {
    contactListControllerDelegate?.didTapAddress(address: address)
  }
}
