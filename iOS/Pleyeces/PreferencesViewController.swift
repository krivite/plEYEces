//
//  PreferencesViewController.swift
//  Pleyeces
//
//  Created by Kristiana on 18/01/2018.
//  Copyright © 2018 Kristiana. All rights reserved.
//

import UIKit

class PreferencesViewController: UIViewController {

    
    @IBOutlet weak var radiusText: UITextField!
    @IBOutlet weak var radiusSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        radiusText.layer.cornerRadius = 11.0
        radiusText.text = "\(Int(radiusSlider.value)) meters"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let value = Int(radiusSlider.value)
        radiusText.text = "\(value) meters"
    }

}
