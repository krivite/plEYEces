//
//  POIBubbleView.swift
//  Pleyeces
//
//  Created by Igor Rinkovec on 19/10/2017.
//  Copyright © 2017 Kristiana. All rights reserved.
//

import Foundation
import UIKit

class DistantPOIBubbleView: UIView {
    
    @IBOutlet weak var nameLabel: UILabel!
    var poi: PointOfInterest?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size.height = 50
        self.frame.size.width = 200
        
        addGradientBackground()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.frame.size.height = 50
        self.frame.size.width = 200
        
        addGradientBackground()
    }
    
    func addGradientBackground() {
        
        let gradient = CAGradientLayer()
        gradient.backgroundColor = nil
        gradient.frame = self.bounds
        gradient.colors = [Color.colorWithHexString(hex: "FAD961").cgColor, Color.colorWithHexString(hex: "FF9500").cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.cornerRadius = 10.0
        gradient.opacity = 0.7
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func setPOI(poi: PointOfInterest) {
        self.poi = poi
        
        self.nameLabel.text = poi.name
    }
    
    class func instanceFromNib() -> DistantPOIBubbleView {
        return UINib(nibName: "DistantPOIBubbleView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DistantPOIBubbleView
    }
    
}

