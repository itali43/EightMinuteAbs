//
//  AgrippaExtensions.swift
//  Panick
//
//  Created by Elliott Williams on 6/27/18.
//  Copyright © 2018 AgrippaApps. All rights reserved.
//

import Foundation
import UIKit

// Defaults Project wide
let defaults = UserDefaults.standard

class Agrippa {


    
    static func defaultexists(forKey: String) -> Bool {
        if defaults.object(forKey: forKey) != nil {
            print("\(forKey) exists")
            return true
        } else {
            
            print("\(forKey) is nil")
            return false
        }
        
    }
    
    
}


// button outline extension
@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

// image
// button outline extension
@IBDesignable extension UIImageView {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}

// String Extensions
// for hexadecimal
extension String {
    // underlines text in a button or label
    /*
     Use in this fashion:
     How to use it on buttton:
     
     if let title = button.titleLabel?.text{
     button.setAttributedTitle(title.getUnderLineAttributedText(), for: .normal)
     }
     How to use it on Labels:
     
     if let title = label.text{
     label.attributedText = title.getUnderLineAttributedText()
     }

     https: //stackoverflow.com/questions/28053334/how-to-underline-a-uilabel-in-swift
     */
    func getUnderLineAttributedText() -> NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
    }

    
    init?(hexadecimal string: String, encoding: String.Encoding = .utf8) {
        guard let data = string.hexadecimal() else {
            return nil
        }
        
        self.init(data: data, encoding: encoding)
    }
    
    func hexadecimalString(encoding: String.Encoding = .utf8) -> String? {
        return data(using: encoding)?
            .hexadecimal()
    }
    
    /// Create `Data` from hexadecimal string representation
    ///
    /// This takes a hexadecimal representation and creates a `Data` object. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    ///
    /// - returns: Data represented by this hexadecimal string.
    
    func hexadecimal() -> Data? {
        var data = Data(capacity: characters.count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSMakeRange(0, utf16.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        guard data.count > 0 else { return nil }
        return data
    }
    
}



// Data Extensions
// for hexadecimal
extension Data {
    /// Create hexadecimal string representation of `Data` object.
    ///
    /// - returns: `String` representation of this `Data` object.
    func hexadecimal() -> String {
        return map { String(format: "%02x", $0) }
            .joined(separator: "")
    }
    
    // for Swift server notifications
    var hexString: String {
        guard count > 0 else {
            return ""
        }
        let deviceIdLen = count
        let deviceIdBytes = self.withUnsafeBytes {
            ptr in
            return UnsafeBufferPointer<UInt8>(start: ptr, count: self.count)
        }
        var hexStr = ""
        for n in 0..<deviceIdLen {
            let b = deviceIdBytes[n]
            hexStr.append(b.hexString)
        }
        return hexStr
    }

    
}

extension UIView {
    
    func startRotating(duration: CFTimeInterval = 3, repeatCount: Float = Float.infinity, clockwise: Bool = true) {
        
        if self.layer.animation(forKey: "transform.rotation.z") != nil {
            return
        }
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        let direction = clockwise ? 1.0 : -1.0
        animation.toValue = NSNumber(value: .pi * 2 * direction)
        animation.duration = duration
        animation.isCumulative = true
        animation.repeatCount = repeatCount
        self.layer.add(animation, forKey:"transform.rotation.z")
    }
    
    func stopRotating() {
        
        self.layer.removeAnimation(forKey: "transform.rotation.z")
        
    }
    //    //function can be placed in View Contoller, such that the keyboard will disappear when you tap outside of the keyboard space
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        self.view.endEditing(true)
    //        // This function makes it so that if you tap outside of the keyboard it will disappear.
    //    }
    
}
extension UIApplication {
    
    static func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        
        return base
    }
}


// utility for Notifications swift
extension UInt8 {
    var hexString: String {
        var s = ""
        let b = self >> 4
        s.append(String(UnicodeScalar(b > 9 ? b - 10 + 65 : b + 48)))
        let b2 = self & 0x0F
        s.append(String(UnicodeScalar(b2 > 9 ? b2 - 10 + 65 : b2 + 48)))
        return s
    }
}



