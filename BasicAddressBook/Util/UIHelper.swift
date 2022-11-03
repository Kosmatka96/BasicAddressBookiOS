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
  
  // Helper method to make it easier to assign width
  func setViewWidth(view: UIView, width: CGFloat) {
    view.frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y,
                        width: width, height: view.frame.size.height)
  }
  
  // Helper method to make it easier to assign origin X
  func setViewX(view: UIView, originX: CGFloat) {
    view.frame = CGRect(x: originX, y: view.frame.origin.y,
                        width: view.frame.size.width, height: view.frame.size.height)
  }
  
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
    let label: UILabel = UILabel(frame: CGRectMake(pos.dx, pos.dy, width, height))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    //label.sizeToFit()
    return label
  }
    
  // Places changeView under topView with some padding. Adjusts with topView height, and y pos
  func placeViewUnderWithPadding(padding: CGFloat, changeView: UIView?, topView: UIView?) {
    if (changeView != nil && topView != nil) {
      let maxY: CGFloat = (topView?.frame.maxY)!
      let newYPos = maxY + padding
      let curX = (changeView?.frame.origin.x)!
      let curWidth = (changeView?.frame.size.width)!
      let curHeight = (changeView?.frame.size.height)!
      changeView?.frame = CGRectMake(curX, newYPos, curWidth, curHeight)
    }
    else {
      NSLog("[ERROR]: cannot place UI Label under, UILabel = nil!")
    }
  }
    
  func contactListImage() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 30), false, 0.0);
    let aPath: UIBezierPath = UIBezierPath.init()
    UIColor.white.setStroke()
    aPath.lineWidth = 2.0
    aPath.addArc(withCenter: CGPointMake(11.0, 11.0), radius: 7.0, startAngle: 0, endAngle: 360.0.radians, clockwise: true)
    aPath.move(to: CGPointMake(16, 16))
    aPath.addLine(to: CGPointMake(25, 25))
    aPath.stroke()
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
    UIGraphicsEndImageContext();
    return image;
  }
  
  func createContactImage() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 30), false, 0.0);
    let aPath: UIBezierPath = UIBezierPath.init()
    UIColor.white.setStroke()
    aPath.lineWidth = 2.0
    aPath.addArc(withCenter: CGPointMake(12.0, 7.0), radius: 5.0, startAngle: 50.radians, endAngle: 130.radians, clockwise: false)
    aPath.move(to: CGPointMake(19, 19.5))
    aPath.addArc(withCenter: CGPointMake(12.0, 16.5), radius: 7.0, startAngle: 0.radians, endAngle: 180.radians, clockwise: false)
    aPath.move(to: CGPointMake(1, 18))
    aPath.addLine(to: CGPointMake(27, 26))
    aPath.addLine(to: CGPointMake(20, 20))
    aPath.move(to: CGPointMake(27, 27))
    aPath.addLine(to: CGPointMake(18, 27))
    aPath.stroke()
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
    UIGraphicsEndImageContext();
    return image;
  }
  
  func menuButtonImage() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(44, 44), false, 0.0);
    let aPath: UIBezierPath = UIBezierPath.init()
    UIColor.white.setFill()
    aPath.addArc(withCenter: CGPointMake(9, 22), radius: 3, startAngle: 0.radians, endAngle: 360.radians, clockwise: true)
    aPath.addArc(withCenter: CGPointMake(18, 22), radius: 3, startAngle: 0.radians, endAngle: 360.radians, clockwise: true)
    aPath.addArc(withCenter: CGPointMake(27, 22), radius: 3, startAngle: 0.radians, endAngle: 360.radians, clockwise: true)
    aPath.fill()
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
    UIGraphicsEndImageContext();
    return image;
  }
  
  func menuButtonImageHighlighted() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(44, 44), false, 0.0);
    let aPath: UIBezierPath = UIBezierPath.init()
    UIColor.gray.setFill()
    aPath.addArc(withCenter: CGPointMake(9, 22), radius: 3, startAngle: 0.radians, endAngle: 360.radians, clockwise: true)
    aPath.addArc(withCenter: CGPointMake(18, 22), radius: 3, startAngle: 0.radians, endAngle: 360.radians, clockwise: true)
    aPath.addArc(withCenter: CGPointMake(27, 22), radius: 3, startAngle: 0.radians, endAngle: 360.radians, clockwise: true)
    aPath.fill()
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
    UIGraphicsEndImageContext();
    return image;
  }
  
}

