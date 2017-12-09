//
//  POIFetcher.swift
//  Pleyeces
//
//  Created by Igor Rinkovec on 20/10/2017.
//  Copyright © 2017 Kristiana. All rights reserved.
//

import Foundation
import Alamofire

class POIFetcher {
    
    class func fetchByGeolocation(lat: Double, lng: Double, radius: Float, success: @escaping (Array<PointOfInterest>) -> ()) {
        let parameters: Parameters = ["longitude": lng, "latitude": lat, "radius": radius]
        Alamofire.request("https://pleyec.es/api/pois/location",method: .get, parameters: parameters,  encoding: URLEncoding(destination: .queryString))
            .responseJSON { response in
                success(mapToModel(resp: response))
            }
    }
    
    class func fetchAll(success: @escaping (Array<PointOfInterest>) -> ()) {
        Alamofire.request("https://pleyec.es/api/pois",method: .get)
            .responseJSON { response in
                success(mapToModel(resp: response))
                
        }
    }
    
    class func fetchSinglePOI(id: Int, success: @escaping (Array<PointOfInterest>) -> ()) {
        let url="https://pleyec.es/api/poi/" + String(id)
        Alamofire.request(url,method: .get)
            .responseJSON { response in
                success(mapToModel(resp: response))
        }
    }
    
    class func mapToModel(resp: DataResponse<Any>) -> Array<PointOfInterest> {
        var poiList = [PointOfInterest]()
        
        guard resp.result.value != nil else {
            return []
        }
        
        let responseJson = resp.result.value as! NSDictionary
        let pois = responseJson.value(forKey: <#T##String#>)
        for poi in pois {
            let unpackedPoi = poi as! NSDictionary
            
            let model = PointOfInterest(
                id: unpackedPoi.value(forKey: "id") as! Int,
                name: unpackedPoi.value(forKey: "name") as! String,
                address: unpackedPoi.value(forKey: "address") as! String,
                details: "",
                lat: unpackedPoi.value(forKey: "latitude") as! Double,
                lng: unpackedPoi.value(forKey: "longitude") as! Double
            )
            /*
            let type = unpackedPoi.value(forKey: "type") as! NSDictionary;
            model.type = type["id"] as? Int;*/
            poiList.append(model)
        }
        
        return poiList
    }
    
}
