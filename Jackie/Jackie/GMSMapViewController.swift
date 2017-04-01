//
//  GMSMapViewController.swift
//  Jackie
//
//  Created by Yuna Lee on 4/1/17.
//  Copyright © 2017 Jackie. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GoogleMapsDirections

class GMSMapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapContainerView: GMSMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set current location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                                          longitude: userLocation!.coordinate.longitude, zoom: 16)
        self.mapContainerView.camera = camera
        self.mapContainerView.isMyLocationEnabled = true
        
        // Creates a marker at current location on map.
        let marker = GMSMarker()
        marker.position = center
        marker.title = "Current Location"
        marker.snippet = "XXX"
        marker.map = self.mapContainerView
        
        locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
