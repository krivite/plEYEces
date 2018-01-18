//
//  ExplorePageController.swift
//  Pleyeces
//
//  Created by FOI on 18/01/2018.
//  Copyright © 2018 Kristiana. All rights reserved.
//

import Foundation
import UIKit

class ExplorePageController: UIViewController, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var types: Array<PoiType> = []
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "typeCell", for: indexPath) as! CategoryCell
        cell.poiAmountlbl.text = "0"
        cell.poiNamelbl.text = types[indexPath.item].name
        cell.poiAmountlbl.textColor = types[indexPath.item].color
        cell.contentView.backgroundColor = types[indexPath.item].color
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2-10, height: collectionView.frame.size.width/2-10)
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        PoiTypeFetcher.fetchAll { (poiTypes) in
            self.types = poiTypes
            self.collectionView.reloadData()
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
