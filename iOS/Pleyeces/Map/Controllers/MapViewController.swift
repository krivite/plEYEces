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

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, POIDisplayView {
    
    var displayPois: Array<PointOfInterest> = []

    @IBOutlet weak var Map: MKMapView!
    
    var bottomView: BottomMapViewController?
    
    let manager = CLLocationManager()
    var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    
    var isZoomed = false
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if(!isZoomed) {
            let location = locations[0]

            let span:MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
            let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
            Map.setRegion(region, animated: true)

            self.Map.showsUserLocation = true
                
            isZoomed = true
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func loadNearbyPOIs() {
        POIFetcher.fetchByGeolocation(
            lat: (manager.location?.coordinate.latitude)!,
            lng: (manager.location?.coordinate.longitude)!,
            radius: Float(Defaults[DefaultsKeys.radius])
        ) { (nearbyPois) in
            self.displayPois = nearbyPois
            self.displayPOIs()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadNearbyPOIs()
    }
    
    func displayPOIs() {
        for poi in self.displayPois {
            let annotation = POIMapAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: poi.lat, longitude: poi.lng)
            annotation.title = poi.name
            annotation.poi = poi
            
            self.Map.addAnnotation(annotation)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        guard let annotation = view.annotation as? POIMapAnnotation else {
            return
        }
        
        addBottomSheetView(poi: annotation.poi!)
    }
    
    func addBottomSheetView(poi: PointOfInterest) {
        
        if((bottomView) != nil) {
            bottomView?.willMove(toParentViewController: nil)
            bottomView?.view.removeFromSuperview()
            bottomView?.removeFromParentViewController()
        }
        
        bottomView = BottomMapViewController()
        
        self.addChildViewController(bottomView!)
        self.view.addSubview(bottomView!.view)
        bottomView!.didMove(toParentViewController: self)
        
        
        let height = view.frame.height
        let width  = view.frame.width
        bottomView!.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
        
        bottomView!.setPOI(poi: poi)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
