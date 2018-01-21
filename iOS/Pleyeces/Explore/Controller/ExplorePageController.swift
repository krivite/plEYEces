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
        cell.poiAmountlbl.text = String(describing: types[indexPath.item].poiCount!)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = types[indexPath.item]
        let destinationViewController = storyboard?.instantiateViewController(withIdentifier: "PoiTableViewController")  as! PoiTableViewController
        destinationViewController.type = type
        navigationController?.pushViewController(destinationViewController, animated: true)
    }
}
