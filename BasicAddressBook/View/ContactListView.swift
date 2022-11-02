//
//  ContactListView.swift
//  BasicAddressBook
//
//  Created by Vaughn Kosmatka on 10/31/22.
//

import Foundation
import UIKit

class ContactListView : UIView {
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init (frame : CGRect) {
    super.init(frame : frame)
    backgroundColor = UIColor.clear
  }
}
