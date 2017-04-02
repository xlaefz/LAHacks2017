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

class GMSMapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {

    @IBOutlet weak var mapContainerView: GMSMapView!
  
    var locationManager = CLLocationManager()
    var currLocation: CLLocationCoordinate2D? = nil
    var markers = [ GMSMarker ]()
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set current location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        // Set map view delegate
        self.mapContainerView.delegate = self
    }
    
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        // Create confirmation alert
        let alert = UIAlertController(title: "UIAlertController", message: "Would you like to provide her assistance?", preferredStyle: UIAlertControllerStyle.alert)
        
        // Add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: { action in self.showDirectionsView() }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        // Show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func showDirectionsView() {
        // Show the directions view with proper destination address
        locationManager.stopUpdatingLocation()
        var directionsViewController = DirectionsViewController.instantiate()
        self.present(directionsViewController, animated: true, completion: nil)
        directionsViewController.destinationCoordinate = nil
        // Set destination coordinate of direction view controller
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let userLocation = locations.last
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        currLocation = userLocation!.coordinate
        
        // Shift camera to current location
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude, zoom: 16)
        self.mapContainerView.camera = camera
        self.mapContainerView.isMyLocationEnabled = true
        
        // Clear and add markers
        addRequestingAidMarkers()
        
        locationManager.stopUpdatingLocation()
    }
    
    func addRequestingAidMarkers() {
        // Clear existing markers
        self.mapContainerView.clear()
        
        // Add a marker on the map for each user requesting aid nearby.
        var userCoordinates = [ CLLocationCoordinate2D ]()
        userCoordinates.append(currLocation!)   // GET RID OF THIS LATER :O
        
        for coordinate in userCoordinates {
            // Draw marker
            let marker = GMSMarker()
            marker.position = coordinate
            
            //turn donor into type of product
            marker.title = "Donor"
            
            marker.icon = UIImage(named: "girl")
            marker.map = self.mapContainerView
            
            // Draw circle
            let circle = GMSCircle(position: coordinate, radius: 100)
            circle.fillColor = UIColor(red: 0.7, green: 0, blue: 0, alpha: 0.1)
            circle.strokeColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.3)
            circle.strokeWidth = 2
            circle.map = self.mapContainerView
        }
    }
    
    func focusMapToShowAllMarkers() {
        var bounds: GMSCoordinateBounds = GMSCoordinateBounds(coordinate: currLocation!, coordinate: currLocation!)
        
        for marker in self.markers {
            bounds = bounds.includingCoordinate(marker.position)
            self.mapContainerView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 15.0))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
