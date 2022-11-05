//
//  DrawerController.swift
//  BasicAddressBook
//
//  This Controller handles the two other controllers in the app and handles their
//  drawer taps to display the drawer menu.
//

import UIKit

class DrawerController: UISplitViewController, DrawerViewDelegate,
                        ContactListControllerDelegate, CreateContactControllerDelegate {
  
  var drawerView: DrawerView? // layout of the menu
  let overlayView = UIView() // view that tints background under menu, handles gesture events
  var isMenuExpanded: Bool = false
  
  fileprivate var contactListController: ContactListController = ContactListController()
  fileprivate var createContactController: CreateContactController = CreateContactController()
  fileprivate var selectedScreen: String = ""
  
  init(mainViewController: UIViewController) {
    self.drawerView = nil
    super.init(nibName: nil, bundle: nil)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidAppear(_ animated: Bool) {
    // by default start at contact list screen
    menuOptionSelectedInDrawerView(optionTitle: DrawerView.kMainMenuContactList)
    toggleMenu() //re-toggle to hide menu
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Configure overlayView
    overlayView.backgroundColor = .black
    overlayView.alpha = 0
    view.insertSubview(overlayView, at: 4)
    
    // Configure drawerView
    drawerView = DrawerView(frame: view.frame)
    drawerView!.drawerDelegate = self
    drawerView!.updateLayout(isMenuExpanded: isMenuExpanded)
    view.insertSubview(drawerView!, at:6)
    
    // Configure gestures, one for tapping the faded background behind menu,
    // and the other for swiping menu left, both will call toggleMenu()
    let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft))
    swipeLeftGesture.direction = .left
    drawerView?.addGestureRecognizer(swipeLeftGesture)
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOverlay))
    overlayView.addGestureRecognizer(tapGesture)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    overlayView.frame = self.view.bounds
  }
  
  @objc fileprivate func didSwipeLeft() { toggleMenu() }
    
  @objc fileprivate func didTapOverlay() { toggleMenu() }
  
  func toggleMenu() {
    overlayView.bounds = self.view.bounds
    isMenuExpanded = !isMenuExpanded
    
    UIView.animate(withDuration: 0.3, animations: { [self] in
      overlayView.alpha = (isMenuExpanded) ? 0.5 : 0.0
    }) { (success) in }
    
    self.drawerView!.transform = CGAffineTransformIdentity;
    drawerView!.animateLayout(isMenuExpanded: isMenuExpanded)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
  }
}

extension DrawerController {
  
  func contactListControllerDidTapDrawer(_ contactListController: ContactListController) {
    toggleMenu()
  }
  
  func contactListControllerUpdateContact(_ contact: ContactModel) {
    toggleMenu()
    menuOptionSelectedInDrawerView(optionTitle: DrawerView.kMainMenuCreateContact)
    createContactController.updateWithPassedContact(contact)
  }
  
  func createContactControllerDidTapDrawer(_ createContactController: CreateContactController) {
    toggleMenu()
  }
  
  func createContactControllerDidAddContact(_ createContactController: CreateContactController) {
    toggleMenu()
    menuOptionSelectedInDrawerView(optionTitle: DrawerView.kMainMenuContactList)
  }
  
  func menuOptionSelectedInDrawerView(optionTitle: String) {
    if (selectedScreen.caseInsensitiveCompare(optionTitle) == .orderedSame) {
      // nothing to do, already at this screen!
      NSLog("Already at screen... not performing action")
    }
    else {
      selectedScreen = optionTitle
      
      // swap controllers
      if (selectedScreen.caseInsensitiveCompare(DrawerView.kMainMenuContactList) == .orderedSame) {
        // replace createContact screen with contactList screen
        createContactController.view.removeFromSuperview()
        createContactController.removeFromParent()
        
        addChild(contactListController)
        contactListController.view.frame = view.frame
        contactListController.drawerDelegate = self
        view.insertSubview(contactListController.view, at: 1)
        contactListController.didMove(toParent: self)
      }
      else {
        // replace contactList screen with createContact screen
        contactListController.view.removeFromSuperview()
        contactListController.removeFromParent()
        
        addChild(createContactController)
        createContactController.view.frame = view.frame
        createContactController.drawerDelegate = self
        view.insertSubview(createContactController.view, at: 1)
        createContactController.didMove(toParent: self)
      }
    }
    toggleMenu()
  }
  
}



