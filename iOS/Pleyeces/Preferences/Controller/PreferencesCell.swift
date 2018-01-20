//
//  PreferencesCell.swift
//  Pleyeces
//
//  Created by Kristiana on 19/01/2018.
//  Copyright © 2018 Kristiana. All rights reserved.
//

import Foundation
import UIKit
import SwiftyUserDefaults

class PreferencesCell: UICollectionViewCell {
    
    var poiType: PoiType?
    var isEnabled: Bool = true
    
    @IBOutlet weak var poiNameLbl: UILabel!
    @IBOutlet weak var poiBtn: UIButton!
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if(isEnabled) {
            isEnabled = false
            poiBtn.backgroundColor = UIColor.lightGray
            Defaults[.disabledCategoryIds].append((poiType?.id)!)
            
        }
        else {
            isEnabled = true
            poiBtn.backgroundColor = poiType!.color
            Defaults[.disabledCategoryIds].remove(at: Defaults[.disabledCategoryIds].index(of: (poiType?.id)!)!)
        }
    }
    
}
