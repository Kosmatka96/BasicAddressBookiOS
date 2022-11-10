//
//  UIHelper.swift
//  BasicAddressBook
//
//  This class provides some basic utility functions to help setup UI elements
//  resizing, image building, etc...
//
//

import Foundation
import UIKit

extension BinaryFloatingPoint {
    var radians : Self {
        return self * .pi / 180
    }
}

class UIHelper : NSObject {
    static let shared = UIHelper()
  
  // Estimates UILabel height based on label parameters
  func getLabelHeight(text:String, font:UIFont, width:CGFloat) -> CGFloat {
    let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    let attributes = [NSAttributedString.Key.font: font]
    let height = String(text).boundingRect(with: size, options: options, attributes: attributes, context: nil).height
    return height
  }
    
  // Builds a UILabel with constrained width, text, and font while allowing height to be
  // stretched out as far as possible. Returns configured UILabel
  func labelWithWrappedHeight(pos: CGVector, text:String, font:UIFont, width:CGFloat) -> UILabel
  {
    let height: CGFloat = getLabelHeight(text: text, font: font, width: width)
    let label: UILabel = UILabel(frame: CGRect(pos.dx, pos.dy, width, height))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    //label.sizeToFit()
    return label
  }
  
  func getStandardContainerView(cFrame: CGRect) -> UIView {
    //create view
    let containerView = UIView.init(frame: cFrame)
    containerView.isUserInteractionEnabled = true
    //containerView.layer.borderColor = .init(gray: 0, alpha: 0)
    containerView.backgroundColor = .white
    //add a drop shadow
    containerView.layer.cornerRadius = 8.0;
    containerView.layer.masksToBounds = false;
    containerView.layer.shadowColor = .init(red: 0, green: 0, blue: 0, alpha: 1)
    containerView.layer.shadowOpacity = 1.0;
    containerView.layer.shadowRadius = 3.0;
    containerView.layer.shadowOffset = CGSize(0.5, 0.5);
    containerView.layer.shadowPath = UIBezierPath.init(rect: containerView.bounds).cgPath
    containerView.layer.shouldRasterize = true;
    containerView.layer.rasterizationScale = UIScreen.main.scale
    // add a background selection view to color taps later
    let selectionSquare: UIView = UIView.init(frame: CGRect.zero)
    selectionSquare.isUserInteractionEnabled = false
    selectionSquare.backgroundColor = .clear
    selectionSquare.alpha = 0.5
    containerView.addSubview(selectionSquare)
    
    return containerView
  }
  
  func resizeStandardContainerView(view: UIView, frame: CGRect) {
    view.frame = frame
    view.layer.shadowPath = UIBezierPath.init(rect: view.bounds).cgPath
    // wrap selection square to fit new container
    // [0] will always be the selectionSquare if using a standard container view
    view.subviews[0].frame = CGRect(origin: CGPoint(x: 0, y: 0), size: view.frame.size)
  }
    
  func contactListImage() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(CGSize(30, 30), false, 0.0);
    let aPath: UIBezierPath = UIBezierPath.init()
    UIColor.white.setStroke()
    aPath.lineWidth = 2.0
    aPath.addArc(withCenter: CGPoint(11.0, 11.0), radius: 7.0, startAngle: 0, endAngle: 360.0.radians, clockwise: true)
    aPath.move(to: CGPoint(16, 16))
    aPath.addLine(to: CGPoint(25, 25))
    aPath.stroke()
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
    UIGraphicsEndImageContext();
    return image;
  }
  
  func createContactImage() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(CGSize(30, 30), false, 0.0);
    let aPath: UIBezierPath = UIBezierPath.init()
    UIColor.white.setStroke()
    aPath.lineWidth = 2.0
    aPath.addArc(withCenter: CGPoint(12.0, 7.0), radius: 5.0, startAngle: 50.radians, endAngle: 130.radians, clockwise: false)
    aPath.move(to: CGPoint(19, 19.5))
    aPath.addArc(withCenter: CGPoint(12.0, 16.5), radius: 7.0, startAngle: 0.radians, endAngle: 180.radians, clockwise: false)
    aPath.move(to: CGPoint(1, 18))
    aPath.addLine(to: CGPoint(27, 26))
    aPath.addLine(to: CGPoint(20, 20))
    aPath.move(to: CGPoint(27, 27))
    aPath.addLine(to: CGPoint(18, 27))
    aPath.stroke()
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
    UIGraphicsEndImageContext();
    return image;
  }
  
  func menuButtonImage() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(CGSize(44, 44), false, 0.0);
    let aPath: UIBezierPath = UIBezierPath.init()
    UIColor.white.setFill()
    aPath.addArc(withCenter: CGPoint(9, 22), radius: 3, startAngle: 0.radians, endAngle: 360.radians, clockwise: true)
    aPath.addArc(withCenter: CGPoint(18, 22), radius: 3, startAngle: 0.radians, endAngle: 360.radians, clockwise: true)
    aPath.addArc(withCenter: CGPoint(27, 22), radius: 3, startAngle: 0.radians, endAngle: 360.radians, clockwise: true)
    aPath.fill()
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
    UIGraphicsEndImageContext();
    return image;
  }
  
  func menuButtonImageHighlighted() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(CGSize(44, 44), false, 0.0);
    let aPath: UIBezierPath = UIBezierPath.init()
    UIColor.gray.setFill()
    aPath.addArc(withCenter: CGPoint(9, 22), radius: 3, startAngle: 0.radians, endAngle: 360.radians, clockwise: true)
    aPath.addArc(withCenter: CGPoint(18, 22), radius: 3, startAngle: 0.radians, endAngle: 360.radians, clockwise: true)
    aPath.addArc(withCenter: CGPoint(27, 22), radius: 3, startAngle: 0.radians, endAngle: 360.radians, clockwise: true)
    aPath.fill()
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
    UIGraphicsEndImageContext();
    return image;
  }
  
}

extension UIView {
  // Helper method to make it easier to assign different parts of a views frame
  func setX(originX: CGFloat) {
    frame = CGRect(x: originX, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
  }
  func setY(_ y: CGFloat) {
    frame = CGRect(frame.origin.x, y, frame.width, frame.height)
  }
  func setWidth(width: CGFloat) {
    frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: width, height: frame.size.height)
  }
  func setHeight(height: CGFloat) {
    frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: height)
  }
  
  // Places view under another view with some padding
  func setUnderView(_ topView: UIView?, withPadding: CGFloat) {
    if (topView != nil) {
      let newYPos = (topView?.frame.maxY)! + withPadding
      setY(newYPos)
    }
    else { NSLog("[ERROR]: cannot place View under, as topView is nil!") }
  }
  
  func animateButtonExpand() {
    UIView.animate(withDuration: 0.2, delay: 0.0) {
        self.transform = CGAffineTransform(scaleX: 2.2, y: 2.2)
    }
    UIView.animate(withDuration: 0.1, delay: 0.2) {
        self.transform = CGAffineTransform(scaleX: 1.0,y: 1.0)
    }
  }
  
  func animateTap() {
    UIView.animate(withDuration: 0.115, delay: 0.0) {
        self.transform = CGAffineTransform(scaleX: 0.915,y: 0.915)
    }
    UIView.animate(withDuration: 0.115, delay: 0.115) {
        self.transform = CGAffineTransform(scaleX: 1.0,y: 1.0)
    }
  }
  
  func animateTapWithColor(selectColor: UIColor) {
    let originalColor = backgroundColor
    UIView.animate(withDuration: 0.115, delay: 0.0) {
        self.transform = CGAffineTransform(scaleX: 0.915,y: 0.915)
      self.backgroundColor = selectColor
    }
    UIView.animate(withDuration: 0.115, delay: 0.115) {
        self.transform = CGAffineTransform(scaleX: 1.0,y: 1.0)
    }
    UIView.animate(withDuration: 0, delay: 0.23) {
      self.backgroundColor = originalColor
    }
  }
  
  func animateTapWithSubSelectionView(subSelectionView: UIView, selectColor: UIColor) {
    let originalColor = subSelectionView.backgroundColor
    UIView.animate(withDuration: 0.115, delay: 0.0) {
        self.transform = CGAffineTransform(scaleX: 0.915,y: 0.915)
      subSelectionView.backgroundColor = selectColor
    }
    UIView.animate(withDuration: 0.115, delay: 0.115) {
        self.transform = CGAffineTransform(scaleX: 1.0,y: 1.0)
    }
    UIView.animate(withDuration: 0, delay: 0.23) {
      subSelectionView.backgroundColor = originalColor
    }
  }
}

extension CGRect{
    init(_ x:CGFloat,_ y:CGFloat,_ width:CGFloat,_ height:CGFloat) {
        self.init(x:x,y:y,width:width,height:height)
    }

}
extension CGSize{
    init(_ width:CGFloat,_ height:CGFloat) {
        self.init(width:width,height:height)
    }
}
extension CGPoint{
    init(_ x:CGFloat,_ y:CGFloat) {
        self.init(x:x,y:y)
    }
}
