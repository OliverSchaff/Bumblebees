//
//  ProtocolsAndExtensions.swift
//  Bumblebees
//
//  Created by Oliver Schaff on 10.06.18.
//  Copyright © 2018 Oliver Schaff. All rights reserved.
//

import Foundation
import UIKit

protocol JSONExportable {
    func exportAsJSON(callback: (Result<Bool>)->())
    var displayText: String { get }
}

protocol ObjectsTableViewDelegate: class {
    func didTapAccessoryForObject(_ object: ObjectStudied)
}

protocol Blinkable {
    func blink()
    func shrink()
    func unshrink()
}

extension String: Error {}

extension Blinkable where Self: UIView {
    func blink() {
        UIView.animate(withDuration: 0.05, delay: 0.0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha *= 0.5
        }) { (finished) in
            UIView.animate(withDuration: 0.15, delay: 0.0, options: [.curveEaseOut, .allowUserInteraction], animations: {
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.alpha /= 0.5
            }, completion: nil)
        }
    }
    
    func shrink() {
        UIView.animate(withDuration: 0.05, delay: 0.0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha *= 0.5
        }, completion: nil)
    }
    
    func unshrink() {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: [.curveEaseOut, .allowUserInteraction], animations: {
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.alpha /= 0.5
        }, completion: nil)
    }
}

extension UIColor {
    
    static let lightGreenDay = BBColors.bbLightGreen!
    static let lightGreenNight = BBColors.bbLightGreenDark!
    static let darkGreenDay = BBColors.bbDarkGreen!
    static let darkGreenNight = BBColors.bbDarkGreenDark!
    
    struct BBColors {
        static let bbLightGreen = UIColor(hexString: "#CCF14DFF")
        static let bbLightGreenDark = UIColor(hexString: "#9DB93BFF")
        static let bbDarkGreen = UIColor(hexString: "#B2D242FF")
        static let bbDarkGreenDark = UIColor(hexString: "#758A2BFF")
    }

    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIAlertController {
    static func ok(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK",
                                         style: .default)
        alert.addAction(okAction)
        return alert
    }
    
}
