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

class ViewController: UIViewController {
    var sceneLocationView = SceneLocationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneLocationView.run()
        self.view.addSubview(sceneLocationView)
        
        let coordinate = CLLocationCoordinate2D(latitude: 46.308476, longitude: 16.337963)
        let location = CLLocation(coordinate: coordinate, altitude: 177)
        let view = POIBubbleView.instanceFromNib()
     
        let image = UIImage.imageWithView(view: view)!
        
        let annotationNode = LocationAnnotationNode(location: location, image: image)
        annotationNode.scaleRelativeToDistance = true
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode);
        var ll=[PointOfInterest]()
        ll=AccessingPOIsService.fetchAllPOIs()
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneLocationView.frame = view.bounds
    }


}

