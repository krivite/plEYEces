//
//  AccessingPOIsService.swift
//  Pleyeces
//
//  Created by FOI on 31/10/2017.
//  Copyright © 2017 Kristiana. All rights reserved.
//

import Foundation
import Alamofire


class AccessingPOIsService {
    
    class func fetchBygeolocation(longitude: Float, latitude: Float, radius: Float) -> Array<PointOfInterest>{
        var listOfPOIs=[PointOfInterest]()
        
        let parameters: Parameters=["pois": longitude, "latitude": latitude, "radius": radius]
        Alamofire.request("http://pleyec.es/api/pois/location",method: .get, parameters: parameters, encoding: JSONEncoding.default)
           
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                
                listOfPOIs=generatePOIModels(resp: response)
                
        }
        return listOfPOIs
    }
    
    class func fetchAllPOIs()-> Array<PointOfInterest>{
        var listOfPOIs=[PointOfInterest]()
        Alamofire.request("http://pleyec.es/api/pois",method: .get, encoding: JSONEncoding.default)
           
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                listOfPOIs=generatePOIModels(resp: response)

        }
        for poi in listOfPOIs{
            debugPrint(poi.name)
        }
        return listOfPOIs

    }
    
    class func fetchSinglePOI(id: Int)-> Array<PointOfInterest>{
        
        var listOfPOIs=[PointOfInterest]()
        let url="http://pleyec.es/api/poi/"+String(id)
        Alamofire.request(url,method: .get,  encoding: JSONEncoding.default)
            
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON { response in
                
                listOfPOIs=generatePOIModels(resp: response)
            
        }
        return listOfPOIs
    }
    
    class func generatePOIModels(resp: DataResponse<Any>) -> Array<PointOfInterest> {

        var POIsList = [PointOfInterest]()
        let json = resp.result.value as! NSArray
       
        for poi in json {
            let x=poi as! NSDictionary
            
            let newPOI=PointOfInterest(
                id: x.value(forKey: "id") as! Int,
                name: x.value(forKey: "name") as! String,
                address: x.value(forKey: "address") as! String,
                details: "",
                lat: x.value(forKey: "latitude") as! Double,
                lng: x.value(forKey: "longitude") as! Double
            )
            let type = x.value(forKey: "type") as! NSDictionary;
            newPOI.type = type["id"] as? Int;
            POIsList.append(newPOI)
        }
       
        return POIsList
    }
}



