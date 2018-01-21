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
    @IBOutlet weak var doneButton: UIButton!
    
    var poi: PointOfInterest?
    var hideButton = false;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.poiName.text = poi?.name
        self.poiAddress.text = poi?.address
        self.poiHours.text = poi?.workingHours
        doneButton.isHidden = hideButton
        
    }
    
    func setPoi(poi: PointOfInterest) {
        self.poi = poi
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
