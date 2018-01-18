//
//  PoiTypeFetcher.swift
//  Pleyeces
//
//  Created by Igor Rinkovec on 18/01/2018.
//  Copyright © 2018 Kristiana. All rights reserved.
//

import Foundation

class PoiTypeFetcher {
    class func mapToModel(data: NSDictionary) -> PoiType? {
        
        let model = PoiType(
            id: data.value(forKey: "id") as! Int,
            name: data.value(forKey: "name") as! String,
            color: Color.colorWithHexString(hex: data.value(forKey: "color") as! String),
            image: data.value(forKey: "icon") as! String
        )
        
        return model
    }
}
