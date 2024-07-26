//
//  UIColor.swift
//  iMedicines2
//
//  Created by Asadbek Yoldoshev on 25/07/24.
//

import UIKit

extension UIColor {
    // Convert UIColor to hex string
    func toHexString() -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "%02X%02X%02X",
            Int(r * 0xFF),
            Int(g * 0xFF),
            Int(b * 0xFF)
        )
    }
    
    // Create UIColor from hex string
    convenience init?(hexString: String) {
        var hexFormatted = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted.remove(at: hexFormatted.startIndex)
        }
        
        guard hexFormatted.count == 6 else { return nil }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension UIColor {
    static var appColor = AppColor()
    
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static func rgbAll(_ value: CGFloat) -> UIColor {
        UIColor(red: value/255, green: value/255, blue: value/255, alpha: 1)
    }
}

struct AppColor {
    let gradientColor: UIColor = .rgb(124, 208, 247)
    let primaryButton: UIColor = .rgb(0, 122, 255)
    let secondaryButton: UIColor = .rgb(76, 217, 100)
    let deleteAction: UIColor = .rgb(255, 69, 58)
    let greenColor: UIColor = .rgb(76, 217, 100)
    let orangeColor: UIColor = .rgb(255, 159, 0)
    let redColor: UIColor = .rgb(255, 59, 48)
}

