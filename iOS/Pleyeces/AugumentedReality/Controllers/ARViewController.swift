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

extension UIImage {
    class func imageWithView(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}

class ARViewController: UIViewController {
    var sceneLocationView = SceneLocationView()
    
    var nearbyPois: Array<PointOfInterest> = []
    var shownLocationNodes: Array<LocationNode> = []
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { (Timer) in
            self.drawPOIs(pois: self.nearbyPois)
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneLocationView.run()
        self.view.addSubview(sceneLocationView)
        
        loadNearbyPOIs()
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
            radius: 1000000
        ) { (nearbyPois) in
            self.nearbyPois = nearbyPois
            self.drawPOIs(pois: self.nearbyPois)
        }
    }
    
    func clearAllDrawnNodes() {
        self.shownLocationNodes.forEach { (node) in
            self.sceneLocationView.removeLocationNode(locationNode: node)
        }
        self.shownLocationNodes.removeAll()
    }
    
    func drawPOIs(pois: Array<PointOfInterest>) {
        self.clearAllDrawnNodes()
        pois.forEach({ (poi) in
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
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
        
    }

}

