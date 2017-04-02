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
        
        // Show directions
        showDirectionsToDestination();
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
    
    func showDirectionsToDestination() {
        
        let origin = GoogleMapsDirections.Place.stringDescription(address: "333 Post St, San Francisco, United States")
        let destination = GoogleMapsDirections.Place.stringDescription(address: "1455 Market St #400, San Francisco, United States")
        GoogleMapsDirections.direction(fromOrigin: origin, toDestination: destination) { (response, error) -> Void in
            
            // Check Status Code
            guard response?.status == GoogleMapsDirections.StatusCode.ok else {
                // Status Code is Not OK
                debugPrint(response?.errorMessage)
                return
            }
            
            // Draw path on map view
            let path = GMSMutablePath(fromEncodedPath: (response?.routes[0].overviewPolylinePoints)!)
            let polyLine = GMSPolyline(path: path)
            polyLine.strokeWidth = 5
            polyLine.strokeColor = UIColor.yellow
            polyLine.map = self.mapContainerView
            debugPrint("it has \(response?.routes.count ?? 0) routes")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
