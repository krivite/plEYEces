//
//  PreferencesViewController.swift
//  Pleyeces
//
//  Created by Kristiana on 18/01/2018.
//  Copyright © 2018 Kristiana. All rights reserved.
//

import Foundation
import UIKit

class PreferencesViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var radiusText: UITextField!
    @IBOutlet weak var radiusSlider: UISlider!
    var types: Array<PoiType> = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "preferencesCell", for: indexPath) as! PreferencesCell
        cell.poiNameLbl.text = types[indexPath.item].name
        cell.poiBtn.backgroundColor = types[indexPath.item].color
        cell.poiBtn.layer.cornerRadius = 0.5 * cell.poiBtn.bounds.size.width
        cell.poiBtn.clipsToBounds = true
        
        let imageUrl = URL(string: "\(types[indexPath.item].image)")
        if let data = try? Data(contentsOf: imageUrl!)
        {
            let image: UIImage = UIImage(data: data)!
            cell.poiBtn.setImage(image, for: UIControlState.normal)
        }
        
        cell.poiBtn.imageEdgeInsets = UIEdgeInsetsMake(15,15,15,15)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3-9, height: collectionView.frame.size.width/3-9)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        PoiTypeFetcher.fetchAll { (poiTypes) in
            self.types = poiTypes
            self.collectionView.reloadData()
        }
        
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
