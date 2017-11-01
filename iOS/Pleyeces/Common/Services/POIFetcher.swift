//
//  POIFetcher.swift
//  Pleyeces
//
//  Created by Igor Rinkovec on 20/10/2017.
//  Copyright © 2017 Kristiana. All rights reserved.
//

import Foundation

class POIFetcher {
    
    // Currently mocked - ToDo: Implement
    class func getByCurrentLocation(callback: (Array<PointOfInterest>) -> ()) {
        callback([
            PointOfInterest(id: 1, name: "The Office Bar", address: "Trg Kralja Tomislava 2, Varaždin", details: "Kava 2+1 GRATIS", lat: 46.3084084, lng: 16.3379733),
            PointOfInterest(id: 2, name: "Kavana Grofica Marica", address: "Trg Kralja Tomislava 2, Varaždin", details: "Kava + Cedevita 15kn", lat: 46.3082384, lng: 16.3358223),
            PointOfInterest(id: 3, name: "Kino Gaj", address: "Ul. Ljudevita Gaja 1, 42000, Varaždin", details: "Kava + Cedevita 15kn", lat: 46.3087733, lng: 16.3354629),
        ])
    }
    
}
