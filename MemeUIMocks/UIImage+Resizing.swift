//
//  UIImage+Resizing.swift
//  MemeEditor.V1
//
//  Created by Jeff Newell on 9/17/15.
//  Copyright © 2015 Jeff Newell. All rights reserved.
//

import UIKit

extension UIImage {
    public func resize(size:CGSize, completionHandler:(resizedImage:UIImage, data:NSData)->()) {
        if #available(iOS 8.0, *) {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
                let newSize:CGSize = size
                let rect = CGRectMake(0, 0, newSize.width, newSize.height)
                UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
                self.drawInRect(rect)
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                let imageData = UIImageJPEGRepresentation(newImage, 0.5)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler(resizedImage: newImage, data:imageData!)
                })
            })
        } else {
            // Fallback on earlier versions
        }
    }
    
    
}
