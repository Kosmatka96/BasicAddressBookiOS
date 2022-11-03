//
//  CreateContactView.swift
//  BasicAddressBook
//
//  View layout for the Create Contact Screen
//

import Foundation
import UIKit

protocol CreateContactViewDelegate: UIViewController {
  func createContactViewDidTapDrawer(_ createContactView: CreateContactView)
  func createContactViewDidTapMenu(_ createContactView: CreateContactView)
}

class CreateContactView : UIView {
  var customerIdLabel : UILabel?
  var companyNameLabel : UILabel?
  var contactNameLabel : UILabel?
  var contactTitleLabel : UILabel?
  var addressLabel : UILabel?
  var cityLabel : UILabel?
  var emailLabel : UILabel?
  var postalCodeLabel : UILabel?
  var countryLabel : UILabel?
  var phoneLabel : UILabel?
  var faxLabel : UILabel?
  var lWidth: CGFloat
  
  weak var createContactControllerDelegate: CreateContactViewDelegate?
    
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init (frame : CGRect) {
    lWidth = frame.size.width*0.5
    super.init(frame : frame)
    backgroundColor = .white
    
    // Title Label + top banner
    let titleLabel: UILabel = UIHelper.shared.labelWithWrappedHeight(
      pos: CGVector(dx: frame.midX, dy: frame.height*0.068),
      text: NSLocalizedString("Create Contact", comment: ""),
      font: UIFont.boldSystemFont(ofSize: 28),
      width: frame.width)
    titleLabel.textColor = .white
    titleLabel.sizeToFit()
    titleLabel.center.x = center.x
    let topBannerView: UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: titleLabel.frame.maxY + 10))
    topBannerView.backgroundColor = .systemBlue
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
    
    // build labels and prelabels, and add them to the view while getting handles for the editable labels
    customerIdLabel = getRowLabel(preLabelText: NSLocalizedString("Customer ID:", tableName: nil, comment: ""), column: 1)
    companyNameLabel = getRowLabel(preLabelText: NSLocalizedString("Company Name:", tableName: nil, comment: ""),column: 2)
    contactNameLabel = getRowLabel(preLabelText: NSLocalizedString("Contact Name:", tableName: nil, comment: ""),column: 3)
    contactTitleLabel = getRowLabel(preLabelText: NSLocalizedString("Contact Title:", tableName: nil, comment: ""),column: 4)
    addressLabel = getRowLabel(preLabelText: NSLocalizedString("Address:", tableName: nil, comment: ""),column: 5)
    cityLabel = getRowLabel(preLabelText: NSLocalizedString("City:", tableName: nil, comment: ""),column: 6)
    emailLabel = getRowLabel(preLabelText: NSLocalizedString("Email:", tableName: nil, comment: ""),column: 7)
    postalCodeLabel = getRowLabel(preLabelText: NSLocalizedString("Postal Code:", tableName: nil, comment: ""),column: 8)
    countryLabel = getRowLabel(preLabelText: NSLocalizedString("Country:", tableName: nil, comment: ""),column: 9)
    phoneLabel = getRowLabel(preLabelText: NSLocalizedString("Phone:", tableName: nil, comment: ""),column: 10)
    faxLabel = getRowLabel(preLabelText: NSLocalizedString("Fax:", tableName: nil, comment: ""),column: 11)
    
    // set specific labels to have different colors
    addressLabel?.textColor = UIColor.purple
    emailLabel?.textColor = UIColor.green
    phoneLabel?.textColor = UIColor.blue
  }
  
  @objc func didTapMenu(_ sender: UIButton!) { handleMenuTap() }
  
  @objc func didTapDrawer(_ sender: UIButton!) { handleDrawerTap() }
  
  private func getRowLabel(preLabelText: String, column: CGFloat) -> UILabel {
      let yPos = 3*column
      
      let preLabel: UILabel = UILabel(frame: CGRect(x: 0, y: yPos, width: lWidth, height: 22))
      preLabel.textAlignment = NSTextAlignment.right
      preLabel.textColor = UIColor.gray
      preLabel.font = UIFont.systemFont(ofSize: 18)
      addSubview(preLabel)
      
      let label: UILabel = UILabel(frame: CGRect(x: lWidth, y: yPos, width: lWidth, height: 22))
      label.textAlignment = NSTextAlignment.left
      label.textColor = UIColor.darkGray
      label.font = UIFont.boldSystemFont(ofSize: 18)
      addSubview(label)
      return label
  }
    
}

extension CreateContactView {
  @objc
  fileprivate func handleDrawerTap() {
    createContactControllerDelegate?.createContactViewDidTapDrawer(self)
  }
  fileprivate func handleMenuTap() {
    createContactControllerDelegate?.createContactViewDidTapMenu(self)
  }
}

