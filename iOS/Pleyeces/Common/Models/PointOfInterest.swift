//
//  PointOfInterest.swift
//  Pleyeces
//
//  Created by Igor Rinkovec on 19/10/2017.
//  Copyright © 2017 Kristiana. All rights reserved.
//

import Foundation

class PointOfInterest {

    var id: Int
    var address: String
    var lat: Double
    var lng: Double
    var image: String?
    var workingHours: String?
    var type: PoiType?
    var name: String
    var description: String
    
    
    init(id: Int, name: String, address: String, details: String, lat: Double, lng: Double) {
        self.id = id
        self.name = name
        self.address = address
        self.description = details
        self.lat = lat
        self.lng = lng
    }
}
