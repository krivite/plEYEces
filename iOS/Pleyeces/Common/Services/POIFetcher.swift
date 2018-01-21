//
//  POIFetcher.swift
//  Pleyeces
//
//  Created by Igor Rinkovec on 20/10/2017.
//  Copyright © 2017 Kristiana. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyUserDefaults


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
    
    class func fetchByType(typeId: Int, success: @escaping (Array<PointOfInterest>) -> ()) {
        let parameters: Parameters = ["type": typeId]
        Alamofire.request("https://16e2a2a9.ngrok.io/api/pois/type",method: .get, parameters: parameters,  encoding: URLEncoding(destination: .queryString))
            .responseJSON { response in
                success(mapToModel(resp: response))
        }
    }
    
    class func mapToModel(resp: DataResponse<Any>) -> Array<PointOfInterest> {
        var poiList = [PointOfInterest]()
        
        guard resp.result.value != nil else {
            return []
        }
        var deactivatedCategory:Bool = false
        let responseJson = resp.result.value as! NSArray
        for poi in responseJson {
            let unpackedPoi = poi as! NSDictionary
            
            let model = PointOfInterest(
                id: unpackedPoi.value(forKey: "id") as! String,
                name: unpackedPoi.value(forKey: "name") as! String,
                address: unpackedPoi.value(forKey: "address") as! String,
                details: unpackedPoi.value(forKey: "details") as! String,
                lat: unpackedPoi.value(forKey: "latitude") as! Double,
                lng: unpackedPoi.value(forKey: "longitude") as! Double
            )
            let type = unpackedPoi.value(forKey: "type") as! NSDictionary;
            model.type = PoiTypeFetcher.mapToModel(data: type)
            model.workingHours = unpackedPoi.value(forKey: "working_hours") as? String
            model.image = unpackedPoi.value(forKey: "image") as? String
            model.offers = OfferMapper.mapToModelArray(data: unpackedPoi.value(forKey: "offers") as! NSArray)
            for id in Defaults[.disabledCategoryIds]
            {
                if (id==model.type!.id){
                    deactivatedCategory=true
                }
            }
            if (deactivatedCategory==false){
                poiList.append(model)
            }
            deactivatedCategory = false
        }
        
        return poiList
    }
    
}
