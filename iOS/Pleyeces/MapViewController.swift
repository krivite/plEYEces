//
//  MapViewController.swift
//  Pleyeces
//
//  Created by Kristiana on 18/01/2018.
//  Copyright © 2018 Kristiana. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SwiftyUserDefaults

class MapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var Map: MKMapView!
    
    let manager = CLLocationManager()
    var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    var nearbyPois: Array<PointOfInterest> = []
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations[0]

        let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        Map.setRegion(region, animated: true)

        self.Map.showsUserLocation = true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        addBottomSheetView()
                
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        POIFetcher.fetchByGeolocation(
            lat: (manager.location?.coordinate.latitude)!,
            lng: (manager.location?.coordinate.longitude)!,
            radius: Float(Defaults[DefaultsKeys.radius])
        ) { (nearbyPois) in
            self.nearbyPois = nearbyPois
            for poi in nearbyPois {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: poi.lat, longitude: poi.lng)
                annotation.title = poi.name
                self.Map.addAnnotation(annotation)
            }
        }

    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView)
    {
        
            print("User tapped on annotation with title:")
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        addBottomSheetView()
//    }
    
    func addBottomSheetView() {
        let bottomSheetVC = BottomMapViewController()
        
        self.addChildViewController(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParentViewController: self)
        
        let height = view.frame.height
        let width  = view.frame.width
        bottomSheetVC.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
