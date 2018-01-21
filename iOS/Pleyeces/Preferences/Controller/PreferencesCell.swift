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
    private var isEnabled: Bool = true
    
    @IBOutlet weak var poiNameLbl: UILabel!
    @IBOutlet weak var poiBtn: UIButton!
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if(isEnabled) {
            Defaults[.disabledCategoryIds].append((poiType?.id)!)
            self.setEnabled(isEnabled: !isEnabled)
        }
        else {
            Defaults[.disabledCategoryIds].remove(at: Defaults[.disabledCategoryIds].index(of: (poiType?.id)!)!)
            self.setEnabled(isEnabled: !isEnabled)
        }
    }
    
    func setEnabled(isEnabled: Bool) {
        self.isEnabled = isEnabled
        if(isEnabled) {
            poiBtn.backgroundColor = poiType!.color
        }
        else {
            poiBtn.backgroundColor = UIColor.lightGray
        }
    }
    
}
