//
//  ImageHelper.swift
//  PHCyclePictureView
//
//  Created by Master on 2017/6/20.
//  Copyright © 2017年 pighome. All rights reserved.
//

import UIKit

public extension UIImage {
    // MARK: Image with Text
    /**
     Creates a text label image.
     
     - Parameter text: The text to use in the label.
     - Parameter font: The font (default: System font of size 18)
     - Parameter color: The text color (default: White)
     - Parameter backgroundColor: The background color (default:Gray).
     - Parameter size: Image size (default: 10x10)
     - Parameter offset: Center offset (default: 0x0)
     
     - Returns A new image
     */
    convenience init?(text: String, font: UIFont = UIFont.systemFont(ofSize: 18), color: UIColor = UIColor.white, backgroundColor: UIColor = UIColor.gray, size: CGSize = CGSize(width: 100, height: 100), offset: CGPoint = CGPoint(x: 0, y: 0)) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        label.font = font
        label.text = text
        label.textColor = color
        label.textAlignment = .center
        label.backgroundColor = backgroundColor
        
        let image = UIImage(fromView: label)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image?.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        self.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        UIGraphicsEndImageContext()
    }
    
    // MARK: Image from UIView
    /**
     Creates an image from a UIView.
     
     - Parameter fromView: The source view.
     
     - Returns A new image
     */
    convenience init?(fromView view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
        //view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        self.init(cgImage:(UIGraphicsGetImageFromCurrentImageContext()?.cgImage!)!)
        UIGraphicsEndImageContext()
    }
}
