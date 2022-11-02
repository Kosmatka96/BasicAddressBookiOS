//
//  ContactItemView.swift
//  BasicAddressBook
//
//  Created by Vaughn Kosmatka on 10/31/22.
//

import Foundation
import UIKit

class ContactCellView : UITableViewCell {
    var customerIdLabel : UILabel
    var companyNameLabel : UILabel
    var contactNameLabel : UILabel
    var contactTitleLabel : UILabel
    var addressLabel : UILabel
    var cityLabel : UILabel
    var emailLabel : UILabel
    var postalCodeLabel : UILabel
    var countryLabel : UILabel
    var phoneLabel : UILabel
    var faxLabel : UILabel
    var groupId: Int
    
    required public init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        backgroundColor = UIColor.clear
        textLabel?.textColor = UIColor.white
        
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
        addressLabel.textColor = UIColor.purple
        emailLabel.textColor = UIColor.green
        phoneLabel.textColor = UIColor.blue

    }
    
    private func getRowLabel(preLabelText: String, column: CGFloat) -> UILabel {
        let yPos = 3*column
        let lWidth: CGFloat = self.frame.size.width*0.5;
        
        let preLabel: UILabel = UILabel(frame: CGRect(x: 0, y: yPos, width: lWidth, height: 22))
        preLabel.textAlignment = NSTextAlignment.right
        preLabel.textColor = UIColor.gray
        preLabel.font = UIFont.systemFont(ofSize: 18)
        self.addSubview(preLabel)
        
        let label: UILabel = UILabel(frame: CGRect(x: lWidth, y: yPos, width: lWidth, height: 22))
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 18)
        self.addSubview(label)
        return label
    }
    
}