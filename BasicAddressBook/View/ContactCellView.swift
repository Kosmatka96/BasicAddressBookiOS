//
//  ContactItemView.swift
//  BasicAddressBook
//
//  Layout for Contact Card to display contact details. Handles initiating, configuring, and height
//  calculations to be added within a TableView
//

import Foundation
import UIKit

protocol ContactCellViewDelegate : UIView {
  func didTapContact(contact: ContactModel)
  func didTapEmailInCellView(email: String)
  func didTapPhoneInCellView(phone: String)
  func didTapAddressInCellView(address: String)
}

protocol ContactSingleCellViewDelegate : UIView {
  func didTapEditButton(relatedLabel: UILabel)
}

class ContactCellView : UITableViewCell {
  
  static let resourceGreenArrow: String = "green_arrow"
  static let resourceRedArrow: String = "red_arrow"
  
  var groupId: Int = 0
  var relatedContact: ContactModel?
  var isConfiguredForCreateView: Bool = false
  weak var contactListViewDelegate: ContactCellViewDelegate?
  weak var createViewDelegate: ContactSingleCellViewDelegate?
  private var containerView: UIView
  // prelabels marking each field of contact
  private var preCustomerIdLabel : UILabel?
  private var preCompanyNameLabel : UILabel?
  private var preContactNameLabel : UILabel?
  private var preContactTitleLabel : UILabel?
  private var preAddressLabel : UILabel?
  private var preCityLabel : UILabel?
  private var preEmailLabel : UILabel?
  private var prePostalCodeLabel : UILabel?
  private var preCountryLabel : UILabel?
  private var prePhoneLabel : UILabel?
  private var preFaxLabel : UILabel?
  // labels to have their text changed by contact
  private var customerIdLabel : UILabel?
  private var companyNameLabel : UILabel?
  private var contactNameLabel : UILabel?
  private var contactTitleLabel : UILabel?
  private var addressLabel : UILabel?
  private var cityLabel : UILabel?
  private var emailLabel : UILabel?
  private var postalCodeLabel : UILabel?
  private var countryLabel : UILabel?
  private var phoneLabel : UILabel?
  private var faxLabel : UILabel?
  // buttons to edit each field if within createView
  private var customerIdButton: UIButton?
  private var companyNameButton: UIButton?
  private var contactNameButton: UIButton?
  private var contactTitleButton: UIButton?
  private var addressButton: UIButton?
  private var cityButton: UIButton?
  private var emailButton: UIButton?
  private var postalCodeButton: UIButton?
  private var countryButton: UIButton?
  private var phoneButton: UIButton?
  private var faxButton: UIButton?
  
  // label parameters
  static let labelFont: UIFont = UIFont.boldSystemFont(ofSize: 18)
  static let preLabelFont: UIFont = UIFont.systemFont(ofSize: 18)
  static var lWidth: CGFloat = CGFloat.zero // to be overriden before use
  static let labelHeightPadding: CGFloat = 12 // padding in height between label rows
  static let labelHorizontalPadding: CGFloat = 8
  static let paddingPerCell: CGFloat = 10 // vertical padding between cells themselves
    
  required public init?(coder aDecoder: NSCoder) {
   fatalError("init(coder:) has not been implemented")
  }
  
  // Init as a cell within TableView of ContactListView
  override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    containerView = UIHelper.shared.getStandardContainerView(cFrame: CGRect.zero)
    
    super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
    
    initViews()
    
    // Add main card tap gesture
    let containerTap = UITapGestureRecognizer(target: self, action: #selector(didTapContact(_:)))
    containerView.addGestureRecognizer(containerTap)
    
    // Add email tap gesture
    let emailTap = UITapGestureRecognizer(target: self, action: #selector(didTapEmail(_:)))
    emailLabel!.addGestureRecognizer(emailTap)
    
    // Add phone tap gesture
    let phoneTap = UITapGestureRecognizer(target: self, action: #selector(didTapPhone(_:)))
    phoneLabel!.addGestureRecognizer(phoneTap)
    
    // Add address tap gesture
    let addressTap = UITapGestureRecognizer(target: self, action: #selector(didTapAddress(_:)))
    addressLabel!.addGestureRecognizer(addressTap)
  }
  
  // Init when cell is to be used stand-alone in CreateView screen
  public init(createView: UIView) {
    containerView = UIHelper.shared.getStandardContainerView(cFrame: CGRect.zero)
    isConfiguredForCreateView = true
    super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "create_cell_contact")
    
    initViews()
    
    // Add gestures for each speficic button to edit related label in parent controller
    customerIdButton!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(didTapCustomerIdButton(_:))))
    companyNameButton!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(didTapCompanyNameButton(_:))))
    contactNameButton!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(didTapContactNameButton(_:))))
    contactTitleButton!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(didTapContactTitleButton(_:))))
    addressButton!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(didTapAddressButton(_:))))
    cityButton!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(didTapCityButton(_:))))
    emailButton!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(didTapEmailButton(_:))))
    postalCodeButton!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(didTapPostalCodeButton(_:))))
    countryButton!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(didTapCountryButton(_:))))
    phoneButton!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(didTapPhoneButton(_:))))
    faxButton!.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(didTapFaxButton(_:))))
    
    // Add observers to match button icon with related label text
    customerIdLabel!.addObserver(self, forKeyPath: "text", options: [.old, .new], context: nil)
    companyNameLabel!.addObserver(self, forKeyPath: "text", options: [.old, .new], context: nil)
    contactNameLabel!.addObserver(self, forKeyPath: "text", options: [.old, .new], context: nil)
    contactTitleLabel!.addObserver(self, forKeyPath: "text", options: [.old, .new], context: nil)
    addressLabel!.addObserver(self, forKeyPath: "text", options: [.old, .new], context: nil)
    cityLabel!.addObserver(self, forKeyPath: "text", options: [.old, .new], context: nil)
    emailLabel!.addObserver(self, forKeyPath: "text", options: [.old, .new], context: nil)
    postalCodeLabel!.addObserver(self, forKeyPath: "text", options: [.old, .new], context: nil)
    countryLabel!.addObserver(self, forKeyPath: "text", options: [.old, .new], context: nil)
    phoneLabel!.addObserver(self, forKeyPath: "text", options: [.old, .new], context: nil)
    faxLabel!.addObserver(self, forKeyPath: "text", options: [.old, .new], context: nil)
  }
  
  // Helper method that just initializes and colors views
  func initViews() {
    backgroundColor = UIColor.white
    selectedBackgroundView?.backgroundColor = .clear
    
    // remove the default background selected color
    let bgSelectedView = UIView()
    bgSelectedView.backgroundColor = .clear
    bgSelectedView.isUserInteractionEnabled = false
    selectedBackgroundView = bgSelectedView
    
    // buid each 'row' where there is a prelabel followed by label
    preCustomerIdLabel = getPreRowLabel(preLabelText: NSLocalizedString("Customer ID:", tableName: nil, comment: ""))
    preCompanyNameLabel = getPreRowLabel(preLabelText: NSLocalizedString("Company Name:", tableName: nil, comment: ""))
    preContactNameLabel = getPreRowLabel(preLabelText: NSLocalizedString("Contact Name:", tableName: nil, comment: ""))
    preContactTitleLabel = getPreRowLabel(preLabelText: NSLocalizedString("Contact Title:", tableName: nil, comment: ""))
    preAddressLabel = getPreRowLabel(preLabelText: NSLocalizedString("Address:", tableName: nil, comment: ""))
    preCityLabel = getPreRowLabel(preLabelText: NSLocalizedString("City:", tableName: nil, comment: ""))
    preEmailLabel = getPreRowLabel(preLabelText: NSLocalizedString("Email:", tableName: nil, comment: ""))
    prePostalCodeLabel = getPreRowLabel(preLabelText: NSLocalizedString("Postal Code:", tableName: nil, comment: ""))
    preCountryLabel = getPreRowLabel(preLabelText: NSLocalizedString("Country:", tableName: nil, comment: ""))
    prePhoneLabel = getPreRowLabel(preLabelText: NSLocalizedString("Phone:", tableName: nil, comment: ""))
    preFaxLabel = getPreRowLabel(preLabelText: NSLocalizedString("Fax:", tableName: nil, comment: ""))
    customerIdLabel = getRowLabel()
    companyNameLabel = getRowLabel()
    contactNameLabel = getRowLabel()
    contactTitleLabel = getRowLabel()
    addressLabel = getRowLabel()
    cityLabel = getRowLabel()
    emailLabel = getRowLabel()
    postalCodeLabel = getRowLabel()
    countryLabel = getRowLabel()
    phoneLabel = getRowLabel()
    faxLabel = getRowLabel()

    // set specific labels to have different colors and accept touches
    addressLabel?.textColor = UIColor.purple
    emailLabel?.textColor = UIColor.green
    phoneLabel?.textColor = UIColor.blue
    addressLabel?.isUserInteractionEnabled = true
    emailLabel?.isUserInteractionEnabled = true
    phoneLabel?.isUserInteractionEnabled = true
    
    // init buttons if appropriate
    if (isConfiguredForCreateView) {
      let dim: CGFloat = (preCustomerIdLabel?.frame.height)!
      customerIdButton = getEditButton(dim: dim)
      companyNameButton = getEditButton(dim: dim)
      contactNameButton = getEditButton(dim: dim)
      contactTitleButton = getEditButton(dim: dim)
      addressButton = getEditButton(dim: dim)
      cityButton = getEditButton(dim: dim)
      emailButton = getEditButton(dim: dim)
      postalCodeButton = getEditButton(dim: dim)
      countryButton = getEditButton(dim: dim)
      phoneButton = getEditButton(dim: dim)
      faxButton = getEditButton(dim: dim)
    }
    
    contentView.addSubview(containerView)
  }
  
  // This method actually applies values to the labels and repositions/wraps them for the cell
  func renderCellWithContact(contact: ContactModel) {
    relatedContact = contact
    
    // apply new text for each field
    customerIdLabel?.text = contact.customerId
    companyNameLabel?.text = contact.companyName
    contactNameLabel?.text = contact.contactName
    contactTitleLabel?.text = contact.contactTitle
    addressLabel?.text = contact.address
    cityLabel?.text = contact.city
    emailLabel?.text = contact.email
    postalCodeLabel?.text = contact.postalCode
    countryLabel?.text = contact.country
    phoneLabel?.text = contact.phone
    faxLabel?.text = contact.fax
    
    fitAllUIElements()
  }
  
  // wraps all UI elements to fit within container
  private func fitAllUIElements() {
    let lWidth = ContactCellView.lWidth
    let labelFont = ContactCellView.labelFont
    let vPadding = ContactCellView.labelHeightPadding * (isConfiguredForCreateView ? 2.5 : 1)
    let hPadding = ContactCellView.labelHorizontalPadding
    
    // apply new frames to labels to make them wrap
    customerIdLabel?.frame = CGRectMake(ContactCellView.lWidth + hPadding, 0, ContactCellView.lWidth, UIHelper.shared.getLabelHeight(text: customerIdLabel?.text ?? "", font: labelFont, width: lWidth))
    companyNameLabel?.frame = CGRectMake(ContactCellView.lWidth + hPadding, 0, ContactCellView.lWidth, UIHelper.shared.getLabelHeight(text: companyNameLabel?.text ?? "", font: labelFont, width: lWidth))
    contactNameLabel?.frame = CGRectMake(ContactCellView.lWidth + hPadding, 0, ContactCellView.lWidth, UIHelper.shared.getLabelHeight(text: contactNameLabel?.text ?? "", font: labelFont, width: lWidth))
    contactTitleLabel?.frame = CGRectMake(ContactCellView.lWidth + hPadding, 0, ContactCellView.lWidth, UIHelper.shared.getLabelHeight(text: contactTitleLabel?.text ?? "", font: labelFont, width: lWidth))
    addressLabel?.frame = CGRectMake(ContactCellView.lWidth + hPadding, 0, ContactCellView.lWidth, UIHelper.shared.getLabelHeight(text: addressLabel?.text ?? "", font: labelFont, width: lWidth))
    cityLabel?.frame = CGRectMake(ContactCellView.lWidth + hPadding, 0, ContactCellView.lWidth, UIHelper.shared.getLabelHeight(text: cityLabel?.text ?? "", font: labelFont, width: lWidth))
    emailLabel?.frame = CGRectMake(ContactCellView.lWidth + hPadding, 0, ContactCellView.lWidth, UIHelper.shared.getLabelHeight(text: emailLabel?.text ?? "", font: labelFont, width: lWidth))
    postalCodeLabel?.frame = CGRectMake(ContactCellView.lWidth + hPadding, 0, ContactCellView.lWidth, UIHelper.shared.getLabelHeight(text: postalCodeLabel?.text ?? "", font: labelFont, width: lWidth))
    countryLabel?.frame = CGRectMake(ContactCellView.lWidth + hPadding, 0, ContactCellView.lWidth, UIHelper.shared.getLabelHeight(text: countryLabel?.text ?? "", font: labelFont, width: lWidth))
    phoneLabel?.frame = CGRectMake(ContactCellView.lWidth + hPadding, 0, ContactCellView.lWidth, UIHelper.shared.getLabelHeight(text: phoneLabel?.text ?? "", font: labelFont, width: lWidth))
    faxLabel?.frame = CGRectMake(ContactCellView.lWidth + hPadding, 0, ContactCellView.lWidth, UIHelper.shared.getLabelHeight(text: faxLabel?.text ?? "", font: labelFont, width: lWidth))
    
    // reposition labels in descending order
    customerIdLabel?.setY(ContactCellView.paddingPerCell) // manually set first label y position
    companyNameLabel?.setUnderView(customerIdLabel, withPadding: vPadding)
    contactNameLabel?.setUnderView(companyNameLabel, withPadding: vPadding)
    contactTitleLabel?.setUnderView(contactNameLabel, withPadding: vPadding)
    addressLabel?.setUnderView(contactTitleLabel, withPadding: vPadding)
    cityLabel?.setUnderView(addressLabel, withPadding: vPadding)
    emailLabel?.setUnderView(cityLabel, withPadding: vPadding)
    postalCodeLabel?.setUnderView(emailLabel, withPadding: vPadding)
    countryLabel?.setUnderView(postalCodeLabel, withPadding: vPadding)
    phoneLabel?.setUnderView(countryLabel, withPadding: vPadding)
    faxLabel?.setUnderView(phoneLabel, withPadding: vPadding)
    // reposition preLabels in descending order
    preCustomerIdLabel?.setY(ContactCellView.paddingPerCell) // manually set first preLabel y position
    preCompanyNameLabel?.setUnderView(customerIdLabel, withPadding: vPadding)
    preContactNameLabel?.setUnderView(companyNameLabel, withPadding: vPadding)
    preContactTitleLabel?.setUnderView(contactNameLabel, withPadding: vPadding)
    preAddressLabel?.setUnderView(contactTitleLabel, withPadding: vPadding)
    preCityLabel?.setUnderView(addressLabel, withPadding: vPadding)
    preEmailLabel?.setUnderView(cityLabel, withPadding: vPadding)
    prePostalCodeLabel?.setUnderView(emailLabel, withPadding: vPadding)
    preCountryLabel?.setUnderView(postalCodeLabel, withPadding: vPadding)
    prePhoneLabel?.setUnderView(countryLabel, withPadding: vPadding)
    preFaxLabel?.setUnderView(phoneLabel, withPadding: vPadding)
    
    // wrap container view to fit all elements
    let containerFrame = CGRectMake(9, 5, UIScreen.main.bounds.width-18, (faxLabel?.frame.maxY)! + ContactCellView.paddingPerCell)
    UIHelper.shared.resizeStandardContainerView(view: containerView, frame: containerFrame)
    
    // reposition buttons if appropriate
    if (isConfiguredForCreateView) {
      customerIdButton?.setY((preCustomerIdLabel?.frame.origin.y)!)
      companyNameButton?.setY((preCompanyNameLabel?.frame.origin.y)!)
      contactNameButton?.setY((preContactNameLabel?.frame.origin.y)!)
      contactTitleButton?.setY((preContactTitleLabel?.frame.origin.y)!)
      addressButton?.setY((preAddressLabel?.frame.origin.y)!)
      cityButton?.setY((preCityLabel?.frame.origin.y)!)
      emailButton?.setY((preEmailLabel?.frame.origin.y)!)
      postalCodeButton?.setY((prePostalCodeLabel?.frame.origin.y)!)
      countryButton?.setY((preCountryLabel?.frame.origin.y)!)
      phoneButton?.setY((prePhoneLabel?.frame.origin.y)!)
      faxButton?.setY((preFaxLabel?.frame.origin.y)!)
      updateEditButtonImage(customerIdButton!, relatedLabel: customerIdLabel!)
      updateEditButtonImage(companyNameButton!, relatedLabel: companyNameLabel!)
      updateEditButtonImage(contactNameButton!, relatedLabel: contactNameLabel!)
      updateEditButtonImage(contactTitleButton!, relatedLabel: contactTitleLabel!)
      updateEditButtonImage(addressButton!, relatedLabel: addressLabel!)
      updateEditButtonImage(cityButton!, relatedLabel: cityLabel!)
      updateEditButtonImage(emailButton!, relatedLabel: emailLabel!)
      updateEditButtonImage(postalCodeButton!, relatedLabel: postalCodeLabel!)
      updateEditButtonImage(countryButton!, relatedLabel: countryLabel!)
      updateEditButtonImage(phoneButton!, relatedLabel: phoneLabel!)
      updateEditButtonImage(faxButton!, relatedLabel: faxLabel!)
      
      self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: containerView.frame.maxY + 20)
    }
  }
  
  static func getHeight(contact: ContactModel) -> CGFloat {
    // helper method to calculate the height a cell should be, requires labelWidth and labelFont to be set elsewhere
    let lWidth = ContactCellView.lWidth
    let labelFont = ContactCellView.labelFont
    let paddingBetweenCells: CGFloat = 16
    let height: CGFloat = ContactCellView.paddingPerCell + (ContactCellView.labelHeightPadding*11) + paddingBetweenCells +
    UIHelper.shared.getLabelHeight(text: contact.customerId ?? "", font: labelFont, width: lWidth) +
    UIHelper.shared.getLabelHeight(text: contact.companyName ?? "", font: labelFont, width: lWidth) +
    UIHelper.shared.getLabelHeight(text: contact.contactName ?? "", font: labelFont, width: lWidth) +
    UIHelper.shared.getLabelHeight(text: contact.contactTitle ?? "", font: labelFont, width: lWidth) +
    UIHelper.shared.getLabelHeight(text: contact.address ?? "", font: labelFont, width: lWidth) +
    UIHelper.shared.getLabelHeight(text: contact.city ?? "", font: labelFont, width: lWidth) +
    UIHelper.shared.getLabelHeight(text: contact.email ?? "", font: labelFont, width: lWidth) +
    UIHelper.shared.getLabelHeight(text: contact.postalCode ?? "", font: labelFont, width: lWidth) +
    UIHelper.shared.getLabelHeight(text: contact.country ?? "", font: labelFont, width: lWidth) +
    UIHelper.shared.getLabelHeight(text: contact.phone ?? "", font: labelFont, width: lWidth) +
    UIHelper.shared.getLabelHeight(text: contact.fax ?? "", font: labelFont, width: lWidth)
    return height
  }
  
  // For use in CreateView as standalone as scrollview needs max height for contentSize
  public func getMaxHeightOfCell() -> CGFloat {
    return containerView.frame.maxY
  }
  
  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "text" {
      // match held contactModel object to current label values
      relatedContact?.customerId = customerIdLabel?.text
      relatedContact?.companyName = companyNameLabel?.text
      relatedContact?.contactName = contactNameLabel?.text
      relatedContact?.contactTitle = contactTitleLabel?.text
      relatedContact?.address = addressLabel?.text
      relatedContact?.city = cityLabel?.text
      relatedContact?.email = emailLabel?.text
      relatedContact?.postalCode = postalCodeLabel?.text
      relatedContact?.country = countryLabel?.text
      relatedContact?.phone = phoneLabel?.text
      relatedContact?.fax = faxLabel?.text
      fitAllUIElements()
    }
  
  }
  
  // Helper method to quickly create label in a cell 'row'
  private func getRowLabel() -> UILabel {
    let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: ContactCellView.lWidth, height: 0))
    label.textAlignment = NSTextAlignment.left
    label.textColor = UIColor.darkGray
    label.font = ContactCellView.labelFont
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.isUserInteractionEnabled = false
    containerView.addSubview(label)
    return label
  }
  
  // Helper method to quickly create pre label in a cell 'row'
  private func getPreRowLabel(preLabelText: String) -> UILabel {
    let preLabelHeight = UIHelper.shared.getLabelHeight(text: "Test", font: ContactCellView.preLabelFont, width: ContactCellView.lWidth)
    let preLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: ContactCellView.lWidth, height: preLabelHeight))
    preLabel.textAlignment = NSTextAlignment.right
    preLabel.textColor = UIColor.gray
    preLabel.font = ContactCellView.preLabelFont
    preLabel.text = preLabelText
    preLabel.isUserInteractionEnabled = false
    containerView.addSubview(preLabel)
    return preLabel
  }
  
  // Helper method to quickly create edit buttons for a ContactCellView within CreateView
  private func getEditButton(dim: CGFloat) -> UIButton {
    let button: UIButton = UIButton.init(frame: CGRect(x: 10, y: 0, width: dim, height: dim))
    button.isUserInteractionEnabled = true
    containerView.addSubview(button)
    return button
  }
  
  private func updateEditButtonImage(_ button: UIButton, relatedLabel: UILabel) {
    // change icon of button based on its related labels text
    if (relatedLabel.text != nil && !relatedLabel.text!.isEmpty) {
      // set green arrow
      button.setImage(UIImage(named: ContactCellView.resourceGreenArrow), for: UIControl.State.normal)
    }
    else {
      // set red arrow
      button.setImage(UIImage(named: ContactCellView.resourceRedArrow), for: UIControl.State.normal)
    }
  }
}

extension ContactCellView {
  @objc func didTapContact(_ sender: UITapGestureRecognizer? = nil) {
    // animate cell tap, and coloring selectionview during animation
    containerView.animateTapWithSubSelectionView(
      subSelectionView: containerView.subviews[0], selectColor: .lightGray)
    
    if (relatedContact != nil) {
      contactListViewDelegate?.didTapContact(contact: relatedContact!)
    }
    else { print("[ERROR]: missing related contact model!") }
  }
  
  @objc func didTapEmail(_ sender: UITapGestureRecognizer? = nil) {
    emailLabel?.animateTap()
    contactListViewDelegate?.didTapEmailInCellView(email: emailLabel?.text ?? "")
  }
  @objc func didTapAddress(_ sender: UITapGestureRecognizer? = nil) {
    addressLabel?.animateTap()
    contactListViewDelegate?.didTapAddressInCellView(address: addressLabel?.text ?? "")
  }
  @objc func didTapPhone(_ sender: UITapGestureRecognizer? = nil) {
    phoneLabel?.animateTap()
    contactListViewDelegate?.didTapPhoneInCellView(phone: phoneLabel?.text ?? "")
  }
  
  func handleEditButtonTap(_ button: UIButton, relatedLabel: UILabel) {
    button.animateButtonExpand()
    createViewDelegate?.didTapEditButton(relatedLabel: relatedLabel)
    updateEditButtonImage(button, relatedLabel: relatedLabel)
  }
  
  @objc func didTapCustomerIdButton(_ sender: UITapGestureRecognizer? = nil) {
    handleEditButtonTap(customerIdButton!, relatedLabel: customerIdLabel!)
  }
  
  @objc func didTapCompanyNameButton(_ sender: UITapGestureRecognizer? = nil) {
    handleEditButtonTap(companyNameButton!, relatedLabel: companyNameLabel!)
  }
  
  @objc func didTapContactNameButton(_ sender: UITapGestureRecognizer? = nil) {
    handleEditButtonTap(contactNameButton!, relatedLabel: contactNameLabel!)
  }
  
  @objc func didTapContactTitleButton(_ sender: UITapGestureRecognizer? = nil) {
    handleEditButtonTap(contactTitleButton!, relatedLabel: contactTitleLabel!)
  }
  
  @objc func didTapAddressButton(_ sender: UITapGestureRecognizer? = nil) {
    handleEditButtonTap(addressButton!, relatedLabel: addressLabel!)
  }
  
  @objc func didTapCityButton(_ sender: UITapGestureRecognizer? = nil) {
    handleEditButtonTap(cityButton!, relatedLabel: cityLabel!)
  }
  
  @objc func didTapPostalCodeButton(_ sender: UITapGestureRecognizer? = nil) {
    handleEditButtonTap(postalCodeButton!, relatedLabel: postalCodeLabel!)
  }
  
  @objc func didTapEmailButton(_ sender: UITapGestureRecognizer? = nil) {
    handleEditButtonTap(emailButton!, relatedLabel: emailLabel!)
  }
  
  @objc func didTapCountryButton(_ sender: UITapGestureRecognizer? = nil) {
    handleEditButtonTap(countryButton!, relatedLabel: countryLabel!)
  }
  
  @objc func didTapPhoneButton(_ sender: UITapGestureRecognizer? = nil) {
    handleEditButtonTap(phoneButton!, relatedLabel: phoneLabel!)
  }
  
  @objc func didTapFaxButton(_ sender: UITapGestureRecognizer? = nil) {
    handleEditButtonTap(faxButton!, relatedLabel: faxLabel!)
  }
}

