//
//  OfferMapper.swift
//  Pleyeces
//
//  Created by Igor Rinkovec on 19/01/2018.
//  Copyright © 2018 Kristiana. All rights reserved.
//

import Foundation

class OfferMapper {
    
    class func mapToModelArray(data: NSArray) -> Array<Offer> {
        var offers: Array<Offer> = []
        
        for offerData in data {
            offers.append(self.mapToModel(data: offerData as! NSDictionary)!)
        }
        
        return offers
    }
    
    class func mapToModel(data: NSDictionary) -> Offer? {
        
        let model = Offer(
            id: data.value(forKey: "id") as! Int,
            text: data.value(forKey: "name") as! String
        )
        
        return model
    }
    
}
