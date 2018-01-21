//
//  ViewController.swift
//  Pleyeces
//
//  Created by Kristiana on 19/10/2017.
//  Copyright © 2017 Kristiana. All rights reserved.
//

import UIKit
import ARCL
import CoreLocation
import SwiftyUserDefaults


extension UIImage {
    class func imageWithView(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}

class ARViewController: UIViewController, POIDisplayView {
    var displayPois: Array<PointOfInterest> = []
    
    var sceneLocationView = SceneLocationView()
    var shownLocationNodes: Array<LocationNode> = []
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneLocationView.run()
        self.view.insertSubview(sceneLocationView, at: 0)
    }
    
    func loadNearbyPOIs() {
        guard sceneLocationView.currentLocation() != nil else {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { (Timer) in
                self.loadNearbyPOIs()
            })
            return
        }
        POIFetcher.fetchByGeolocation(
            lat: sceneLocationView.currentLocation()!.coordinate.latitude,
            lng: sceneLocationView.currentLocation()!.coordinate.longitude,
            radius: Float(Defaults[DefaultsKeys.radius])
        ) { (nearbyPois) in
            self.displayPois = nearbyPois
            self.displayPOIs()
        }
    }
    
    func clearAllDrawnNodes() {
        self.shownLocationNodes.forEach { (node) in
            self.sceneLocationView.removeLocationNode(locationNode: node)
        }
        self.shownLocationNodes.removeAll()
    }
    
    func displayPOIs() {
        self.clearAllDrawnNodes()
        self.displayPois.forEach({ (poi) in
            if sceneLocationView.currentLocation() == nil {
                loadSmallPOIBubble(poi: poi)
                return
            }
            let distanceInMeters = sceneLocationView.currentLocation()!.distance(from: CLLocation(latitude: poi.lat, longitude: poi.lng))
            if distanceInMeters.isLess(than: 100.0) {
                loadDetailedPOIBubble(poi: poi)
                return
            }
            loadSmallPOIBubble(poi: poi)
        })
    }
    
    func loadDetailedPOIBubble(poi: PointOfInterest) {
        let coordinate = CLLocationCoordinate2D(latitude: poi.lat, longitude: poi.lng)
        let location = CLLocation(coordinate: coordinate, altitude: 177)
        let view = POIBubbleView.instanceFromNib()
        view.setPOI(poi: poi)
        let image = UIImage.imageWithView(view: view)!
        let annotationNode = LocationAnnotationNode(location: location, image: image)
        
        self.shownLocationNodes.append(annotationNode)
        poi.arNode = annotationNode
        
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode);
    }
    
    func loadSmallPOIBubble(poi: PointOfInterest) {
        let coordinate = CLLocationCoordinate2D(latitude: poi.lat, longitude: poi.lng)
        let location = CLLocation(coordinate: coordinate, altitude: 177)
        let view = DistantPOIBubbleView.instanceFromNib()
        view.setPOI(poi: poi)
        let image = UIImage.imageWithView(view: view)!
        let annotationNode = LocationAnnotationNode(location: location, image: image)
        
        self.shownLocationNodes.append(annotationNode)
        poi.arNode = annotationNode
        
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadNearbyPOIs()
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touch = touches.first
            else { return }
        
        guard let result = self.sceneLocationView.hitTest(touch.location(in: sceneLocationView), options: nil).first
            else {return}
        
        for poi in self.displayPois
        {
            if (poi.arNode?.annotationNode.contains(result.node))!
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewScreen") as! POIDetailViewController
                vc.setPoi(poi: poi)
                self.present(vc, animated: true, completion: nil)
            }
        }
    }    
}

