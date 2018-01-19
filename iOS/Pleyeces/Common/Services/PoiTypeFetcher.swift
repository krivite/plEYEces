//
//  PoiTypeFetcher.swift
//  Pleyeces
//
//  Created by Igor Rinkovec on 18/01/2018.
//  Copyright © 2018 Kristiana. All rights reserved.
//

import Foundation
import Alamofire

class PoiTypeFetcher {
    class func mapToModel(data: NSDictionary) -> PoiType? {
        
        let model = PoiType(
            id: data.value(forKey: "id") as! Int,
            name: data.value(forKey: "name") as! String,
            color: Color.colorWithHexString(hex: data.value(forKey: "color") as! String),
            image: data.value(forKey: "icon") as! String
        )
        model.poiCount = data.value(forKey: "poiCount") as? Int
        
        return model
    }
    
   
    
    class func fetchAll(success: @escaping (Array<PoiType>) -> ()) {
        Alamofire.request("https://pleyec.es/api/categories",method: .get)
            .responseJSON { response in
                var poiTypes: Array<PoiType> = []
                let responseJson = response.result.value as! NSArray
                for poiJson in responseJson{
                    let poiType = poiJson as! NSDictionary
                    poiTypes.append(self.mapToModel(data: poiType)!)
                   
                }
                success(poiTypes)
                
        }
    }
}
