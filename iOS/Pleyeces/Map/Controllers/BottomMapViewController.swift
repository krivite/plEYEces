//
//  BottomMapViewController.swift
//  Pleyeces
//
//  Created by Kristiana on 21/01/2018.
//  Copyright © 2018 Kristiana. All rights reserved.
//

import UIKit

class BottomMapViewController: UIViewController {

    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    var poi: PointOfInterest?
    
    func setPOI(poi: PointOfInterest) {
        self.poi = poi
        nameLbl.text = poi.name
        detailsLbl.text = (poi.type?.name)! + " - " + poi.address
    }
    
    let fullView: CGFloat = 100
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - (mapBtn.frame.maxY + UIApplication.shared.statusBarFrame.height + 40)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomMapViewController.panGesture))
//        view.addGestureRecognizer(gesture)
        
        roundViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareBackgroundView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height)
        }) 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
//        
//        let translation = recognizer.translation(in: self.view)
//        let velocity = recognizer.velocity(in: self.view)
//        let y = self.view.frame.minY
//        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
//            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
//            recognizer.setTranslation(CGPoint.zero, in: self.view)
//        }
//        
//        if recognizer.state == .ended {
//            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
//            
//            duration = duration > 1.3 ? 1 : duration
//            
//            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
//                if  velocity.y >= 0 {
//                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
//                } else {
//                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
//                }
//                
//            }, completion: nil)
//        }
//    }
    
    @IBAction func mapBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewScreen") as! POIDetailViewController
        vc.setPoi(poi: poi!)
        self.present(vc, animated: true, completion: nil)
    }
    
    func roundViews() {
        view.layer.cornerRadius = 15
        mapBtn.layer.cornerRadius = 10
        view.clipsToBounds = true
    }
    
    func prepareBackgroundView(){
        let blurEffect = UIBlurEffect.init(style: .prominent)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        
        view.insertSubview(bluredView, at: 0)
    }
}
