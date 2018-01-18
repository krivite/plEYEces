//
//  PoiType.swift
//  Pleyeces
//
//  Created by Igor Rinkovec on 18/01/2018.
//  Copyright © 2018 Kristiana. All rights reserved.
//

import Foundation
import UIKit

class PoiType {
    
    var id: Int
    var name: String
    var color: UIColor
    var image: String
    
    
    init(id: Int, name: String, color: UIColor, image: String) {
        self.id = id
        self.name = name
        self.color = color
        self.image = image
    }
}
