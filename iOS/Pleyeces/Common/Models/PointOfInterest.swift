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
    var name: String
    var address: String
    var details: String
    var lat: Double
    var lng: Double
    var workingHours: String?
    var image: String?
    
    init(id: Int, name: String, address: String, details: String, lat: Double, lng: Double) {
        self.id = id
        self.name = name
        self.address = address
        self.details = details
        self.lat = lat
        self.lng = lng
    }
}
