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
  func openAlertToEditLabel( _ label: UILabel)
}

class CreateContactView : UIView, ContactSingleCellViewDelegate {
  
  var cellView: ContactCellView!
  var scrollView: UIScrollView!
  
  weak var createContactControllerDelegate: CreateContactViewDelegate?
    
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init (frame : CGRect) {
  
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
    
    // Add scroll view as contact fields might overcome screen bounds
    scrollView = UIScrollView.init(frame: frame)
    scrollView.setUnderView(topBannerView, withPadding: 0)
    scrollView.setHeight(height: frame.height - topBannerView.frame.maxY)
    scrollView.isUserInteractionEnabled = true
    addSubview(scrollView)
    
    // Configure Single Contact Cell View
    ContactCellView.lWidth = frame.size.width * 0.45; // required override for margins
    cellView = ContactCellView(createView: self)
    cellView.createViewDelegate = self
    let mockContact: ContactModel = ContactModel()
    cellView.renderCellWithContact(contact: mockContact)
    cellView.setY(10)
    scrollView.addSubview(cellView)
  }
  
  public func getCurrentContact() -> ContactModel {
    return cellView.relatedContact ?? ContactModel()
  }
  
  public func updateWithContact(contact: ContactModel) {
    cellView.renderCellWithContact(contact: contact)
    scrollView.contentSize = CGSize(width: frame.width, height: cellView.getMaxHeightOfCell() + 50)
  }
  
  @objc func didTapMenu(_ sender: UIButton!) { handleMenuTap() }
  
  @objc func didTapDrawer(_ sender: UIButton!) { handleDrawerTap() }
}

extension CreateContactView {
  @objc fileprivate func handleDrawerTap() {
    createContactControllerDelegate?.createContactViewDidTapDrawer(self)
  }
  @objc fileprivate func handleMenuTap() {
    createContactControllerDelegate?.createContactViewDidTapMenu(self)
  }
  
  func didTapEditButton(relatedLabel: UILabel) {
    createContactControllerDelegate?.openAlertToEditLabel(relatedLabel)
  }
}

