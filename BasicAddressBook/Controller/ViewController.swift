//
//  ViewController.swift
//  BasicAddressBook
//
//  Created by Vaughn Kosmatka on 10/31/22.
//

import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let mainVC = UIViewController()
    mainVC.view.backgroundColor = .white
    
    let rootController = RootViewController(mainViewController: mainVC, topNavigationLeftImage: UIImage(named: "hamburger-menu-icon"))
    
    let drawerVC = DrawerController(rootViewController: rootController)
    self.addChild(drawerVC)
    view.addSubview(drawerVC.view)
    drawerVC.didMove(toParent: self)
  }
}


