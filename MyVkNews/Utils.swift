//
//  Utils.swift
//  MyVkNews
//
//  Created by Apple on 22.06.17.
//  Copyright © 2017 flatstack. All rights reserved.
//

import Foundation
import UIKit

class DataCheck {
    static func validatePhoneNumber(_ candidate: String) -> Bool {
        let phoneNumberRegex = "\\d{10}"
        
        let isValid = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex).evaluate(with: candidate)
        
        return isValid
    }
}


class Utils {
    static func percentEscapeString(_ str: String) -> String {
        return CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                       str as CFString!,
                                                       nil,
                                                       ":/?@!$&'()*+,;=" as CFString!,
                                                       CFStringBuiltInEncodings.UTF8.rawValue) as String;
    }
    
    static func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        
        let days = (interval / (3600 * 24))
        
        if days == 1 { return "вчера" }
        
        let hours = (interval / 3600) % 24
        
        if hours == 0 {
            let minutes = interval / 60
            return String(format: "%d минут назад", minutes)
        }
        if hours == 1 { return "час назад" }
        if hours == 2 { return "2 часа назад" }
        if hours == 3 { return "3 часа назад" }
        if hours == 4 { return "4 часа назад" }
        
        return String(format: "%d часов назад", hours)
    }
    
    static func scaleImage(image: UIImage, maximumWidth: CGFloat) -> UIImage {
        let prop = maximumWidth / image.size.width
        
        let rect = CGSize(width: maximumWidth, height: image.size.height * prop)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(rect, false, 1.0)
        image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: rect))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    

    static func showError(_ message : String, viewController : UIViewController) {
        let alertController = UIAlertController(title: "", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Назад", style: UIAlertActionStyle.default,handler: nil))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    static func askUser(_ question: String, viewController: UIViewController, actionNo: @escaping (UIAlertAction) -> Void, actionYes: @escaping (UIAlertAction) -> Void){
        let alertController = UIAlertController(title: question, message:
            "", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Нет", style: UIAlertActionStyle.default, handler: actionNo))
        alertController.addAction(UIAlertAction(title: "Да", style: UIAlertActionStyle.default, handler: actionYes))
        viewController.present(alertController, animated: true, completion: nil)
    }
}
