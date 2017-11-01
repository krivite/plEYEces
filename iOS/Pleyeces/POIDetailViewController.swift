//
//  POIDetailViewController.swift
//  Pleyeces
//
//  Created by Kristiana on 01/11/2017.
//  Copyright © 2017 Kristiana. All rights reserved.
//

import UIKit
import SwiftyJSON

class POIDetailViewController: UIViewController {

    var dict = NSDictionary()
    
    @IBOutlet weak var poiName: UILabel!
    @IBOutlet weak var poiImage: UIImageView!
    @IBOutlet weak var poiAddress: UILabel!
    @IBOutlet weak var poiHours: UILabel!
    @IBOutlet weak var poiInfo: UITextView!
    @IBOutlet weak var poiOfferInfo: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let urlString = "http://pleyec.es/api/poi/1"
        
        if let url = NSURL(string: urlString) {
            
            if let data = try? NSData(contentsOf: url as URL, options: []) {
                
                let json = JSON(data: data as Data)
                
                print(json)
        
                let name = json["name"].stringValue
                let address = json["address"].stringValue
                let workingHours = json["working_hours"].stringValue
//                let poiInfo = json["details"].stringValue
//                let offerInfo = json["offers"].stringValue
                
                poiName.text = name
                poiAddress.text = address
                poiHours.text = workingHours
                
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
