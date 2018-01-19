//
//  PointOfInterest.swift
//  Pleyeces
//
//  Created by Igor Rinkovec on 19/10/2017.
//  Copyright © 2017 Kristiana. All rights reserved.
//

import Foundation
import ARCL

class PointOfInterest {

    var id: String
    var address: String
    var lat: Double
    var lng: Double
    var image: String?
    var workingHours: String?
    var type: PoiType?
    var offers: Array<Offer> = []
    var name: String
    var description: String
    var arNode: LocationAnnotationNode?
    
    
    init(id: String, name: String, address: String, details: String, lat: Double, lng: Double) {
        self.id = id
        self.name = name
        self.address = address
        self.description = details
        self.lat = lat
        self.lng = lng
    }
}
