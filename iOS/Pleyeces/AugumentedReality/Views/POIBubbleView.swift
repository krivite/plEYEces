//
//  POIBubbleView.swift
//  Pleyeces
//
//  Created by Igor Rinkovec on 19/10/2017.
//  Copyright © 2017 Kristiana. All rights reserved.
//

import Foundation
import UIKit

class POIBubbleView: UIView {
    
    var poi: PointOfInterest?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size.height = 200
        self.frame.size.width = 266
        
        addGradientBackground()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.frame.size.height = 200
        self.frame.size.width = 266
    
        addGradientBackground()
    }
    
    func addGradientBackground() {
        
        let gradient = CAGradientLayer()
        gradient.backgroundColor = nil
        gradient.frame = self.bounds
        gradient.colors = [Color.colorWithHexString(hex: "FAD961").cgColor, Color.colorWithHexString(hex: "FF9500").cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.cornerRadius = 50.0
        gradient.opacity = 0.7
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func setPOI(poi: PointOfInterest) {
        self.poi = poi
        
        self.nameLabel.text = poi.name
        self.descriptionLabel.text = poi.description
    }
    
    class func instanceFromNib() -> POIBubbleView {
        return UINib(nibName: "POIBubbleView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! POIBubbleView
    }
    
}
