//
//  AccessingPOIsService.swift
//  Pleyeces
//
//  Created by FOI on 31/10/2017.
//  Copyright © 2017 Kristiana. All rights reserved.
//kopyrajt plEYEces
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

        var POIsList=[PointOfInterest]()
        let json=resp.result.value as! NSArray
       
        for poi in json{
            
            
                let x=poi as! NSDictionary
                let newPOI=PointOfInterest(name: x.value(forKey: "name") as! String, description: x.value(forKey: "details") as! String)
            
                newPOI.id = x.value(forKey: "id") as! Int
                newPOI.address = x.value(forKey: "address") as! String
                newPOI.latitude = x.value(forKey: "latitude") as! Double
                newPOI.longitude = x.value(forKey: "longitude") as! Double
                newPOI.image = x.value(forKey: "image") as! String
                newPOI.workingHours = x.value(forKey: "working_hours") as! String
            // TO DO dok netko promijeni poije u bazi kak treba, onda se treba ispod vrijednost promijeniti na tip x.value(forKey: "type") as! Int
                newPOI.type = 1
            
                POIsList.append(newPOI)
            
        }
       
        return POIsList
    }
}



