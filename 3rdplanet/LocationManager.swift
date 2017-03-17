//
//  LocationManager.swift
//  3rdplanet
//
//  Created by zeus on 3/13/17.
//  Copyright © 2017 justzeus. All rights reserved.
//

import Foundation
import CoreLocation
import CloudKit

class LocationManager: NSObject {
    
    static let sharedInstance = LocationManager()
    
    var post: Post?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    func requestCurrentLocation() {
        locationManager.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        if let currentLocation = currentLocation {
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(currentLocation, completionHandler: { (placemarks, error) in
                if error != nil {
                    print("Reverse geocoder failed with error: \(error?.localizedDescription)")
                }
                guard let placemarks = placemarks else { return }
                if placemarks.count > 0 {
                    self.locationManager.stopUpdatingLocation()
                    let pm = placemarks[0] as CLPlacemark
                    if let currentLocation = pm.locality {
                        print(currentLocation)
                    }
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
}
