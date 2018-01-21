//
//  POIDisplayView.swift
//  Pleyeces
//
//  Created by Igor Rinkovec on 21/01/2018.
//  Copyright © 2018 Kristiana. All rights reserved.
//

import Foundation
import UIKit

protocol POIDisplayView where Self: UIViewController {
    
    var displayPois: Array<PointOfInterest> {get set}
    
    func loadNearbyPOIs()
    func displayPOIs()

}
