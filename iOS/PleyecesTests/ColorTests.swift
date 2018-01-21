//
//  ColorTests.swift
//  PleyecesTests
//
//  Created by Igor Rinkovec on 21/01/2018.
//  Copyright © 2018 Kristiana. All rights reserved.
//

import XCTest
@testable import Pleyeces

class ColorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func compareColors (c1:UIColor, c2:UIColor) -> Bool{
        var red:CGFloat = 0
        var green:CGFloat  = 0
        var blue:CGFloat = 0
        var alpha:CGFloat  = 0
        c1.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        var red2:CGFloat = 0
        var green2:CGFloat  = 0
        var blue2:CGFloat = 0
        var alpha2:CGFloat  = 0
        c2.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)
        
        return (Int(red*255) == Int(red*255) && Int(green*255) == Int(green2*255) && Int(blue*255) == Int(blue*255))
    }
    
    func testColorConversion() {
        assert(compareColors(c1: Color.colorWithHexString(hex: "#000000"), c2: UIColor.black))
    }
    
    func testColorDarken() {
        assert(compareColors(c1: Color.darken(color: UIColor.white, percentage: 100)!, c2: UIColor.black))
    }
    
    func testColorLighten() {
        assert(compareColors(c1: Color.lighten(color: UIColor.black, percentage: 100)!, c2: UIColor.white))
    }
    
}
