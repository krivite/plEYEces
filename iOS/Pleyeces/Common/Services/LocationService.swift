//
//  LocationService.swift
//  Pleyeces
//
//  Created by Filip Aleksić on 19/01/2018.
//  Copyright © 2018 Kristiana. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    
    public static var sharedInstance = LocationService()
    let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
         locationManager.distanceFilter = 5
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
        super.init()
        locationManager.delegate = self
    }
    
    func startUpdatingLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else {
            //tell view controllers to show an alert
            showTurnOnLocationServiceAlert()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let newLocation = locations.last {
            print("(\(newLocation.coordinate.latitude), \(newLocation.coordinate.latitude))")
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if (error as NSError).domain == kCLErrorDomain && (error as NSError).code == CLError.Code.denied.rawValue {
            //User denied your app access to location information.
            showTurnOnLocationServiceAlert()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            startUpdatingLocation()
        }
    }
    
    func showTurnOnLocationServiceAlert() {
        NotificationCenter.default.post(name: Notification.Name(rawValue:"showTurnOnLocationServiceAlert"), object: nil)
    }
}
