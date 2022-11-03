//
//  ContactListView.swift
//  BasicAddressBook
//
//  View layout for the Contact List Screen
//

import Foundation
import UIKit

protocol ContactListViewDelegate: UIViewController {
  func contactListViewDidTapDrawer(_ contactListView: ContactListView)
  func contactListViewDidTapMenu(_ contactListView: ContactListView)
}

class ContactListView : UIView, UITableViewDelegate, UITableViewDataSource {
  
  var titleLabel: UILabel!
  var contactTableView: UITableView?  // contains contact list
  let cellId: String = "cell_contact"
  var contactListData: Array<ContactModel> = []
  weak var contactListControllerDelegate: ContactListViewDelegate?
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init (frame : CGRect) {
    super.init(frame : frame)
    backgroundColor = .white
    
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
    
    // ContactTableView
    contactTableView = UITableView(frame: frame)
    contactTableView?.isUserInteractionEnabled = true
    contactTableView?.delegate = self
    contactTableView?.dataSource = self
    contactTableView?.backgroundColor = .clear
    contactTableView?.tableHeaderView =
    UIView.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: 20))
    UIHelper.shared.placeViewUnderWithPadding(padding: 0,
                          changeView: contactTableView, topView: topBannerView)
    addSubview(contactTableView!)
    
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
    let cell: ContactCellView? =
    tableView.dequeueReusableCell(withIdentifier: cellId) as? ContactCellView
    return cell?.getHeight() ?? 320
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell: ContactCellView? =
    tableView.dequeueReusableCell(withIdentifier: cellId) as? ContactCellView

    if (cell == nil) {
      cell = ContactCellView(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellId)
    
      // Add background colors
      cell?.backgroundColor = UIColor.clear
      let bgColorView = UIView()
      bgColorView.backgroundColor = UIColor.white
      cell?.selectedBackgroundView = bgColorView
      
      // Add tap gesture
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapContact(_:)))
      cell?.addGestureRecognizer(tapGesture)
    }
    
    cell?.tag = indexPath.row
    cell?.renderCellWithContact(contact: contactListData[indexPath.row])
    return cell!
  }
  
  @objc func didTapContact(_ sender: UITapGestureRecognizer? = nil) {
    let cell: ContactCellView = sender?.view as! ContactCellView
  
    // Perform Menu item click
    cell.isSelected = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
      cell.isSelected = false
    }
  }
}

extension ContactListView {
  @objc
  fileprivate func handleDrawerTap() {
    contactListControllerDelegate?.contactListViewDidTapDrawer(self)
  }
  fileprivate func handleMenuTap() {
    contactListControllerDelegate?.contactListViewDidTapMenu(self)
  }
}
