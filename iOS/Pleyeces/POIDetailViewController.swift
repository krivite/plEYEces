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
    @IBOutlet var scrollView: UIScrollView!
    
    var poi: PointOfInterest?
    var hideButton = false;

    func setPoi(poi: PointOfInterest) {
        self.poi = poi
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: 1000)
        }
        
        self.poiName.text = poi?.name
        self.poiAddress.text = poi?.address
        self.poiHours.text = "Working hours: " + (poi?.workingHours)!
        self.poiInfo.text = poi?.description
        
        var h = [String]()
        if(poi?.offers.isEmpty == false){
            let offersNum = poi?.offers.count
            for var i in (0 ..< offersNum!) {
                h.append((poi?.offers[i].text)!)
            }
            self.poiOfferInfo.text = h.joined(separator: "\n")
        } else {
            self.poiOfferInfo.text = "No current offers."
        }

        let url = URL(string: "\(poi!.image ?? "")")
        let data = try? Data(contentsOf: url!)
        if(data != nil) {
        self.poiImage.image = UIImage(data: data!)
        }

        doneButton.isHidden = hideButton

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
