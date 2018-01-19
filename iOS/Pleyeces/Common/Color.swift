//
//  Color.swift
//  Pleyeces
//
//  Created by Igor Rinkovec on 19/10/2017.
//  Copyright © 2017 Kristiana. All rights reserved.
//

import Foundation
import UIKit

class Color {
    static func colorWithHexString (hex:String) -> UIColor {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            return .clear
        }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    class func lighten(color: UIColor, percentage:CGFloat=30.0) -> UIColor? {
        return adjust(color: color, percentage: abs(percentage) )
    }
    
    class func darken(color: UIColor, percentage:CGFloat=30.0) -> UIColor? {
        return adjust(color: color, percentage: -1 * abs(percentage) )
    }
    
    class func adjust(color: UIColor, percentage:CGFloat=30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(color.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        }else{
            return nil
        }
    }

}
