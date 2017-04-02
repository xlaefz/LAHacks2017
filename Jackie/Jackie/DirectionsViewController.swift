//
//  DirectionsViewController.swift
//  Jackie
//
//  Created by Yuna Lee on 4/1/17.
//  Copyright © 2017 Jackie. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GoogleMapsDirections

class DirectionsViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapContainerView: GMSMapView!
    
    var locationManager = CLLocationManager()
    var destinationCoordinate: CLLocationCoordinate2D?
    
    static func instantiate()->DirectionsViewController
    {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DirectionsViewController") as! DirectionsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set current location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        // Show directions
        //showDirectionsToDestination(); TO-DO
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude, zoom: 16)
        
        if(mapContainerView == nil) {
            print("mapcontainerview is nil")
        }
        else {
            print("mapcontainerview is not nil")
            self.mapContainerView.camera = camera
            self.mapContainerView.isMyLocationEnabled = true
            
            // Creates a marker at current location on map.
            let marker = GMSMarker()
            marker.position = center
            marker.title = "Current Location"
            marker.snippet = "XXX"
            marker.map = self.mapContainerView
            
            // Update directions to destination
            let originCoordinate = GoogleMapsService.LocationCoordinate2D.init(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
            let origin = GoogleMapsDirections.Place.coordinate(coordinate: originCoordinate)
            
            // GET THIS LATER FROM FIREBASE
            //        let destinationCoordinate =
            let destination = GoogleMapsDirections.Place.stringDescription(address: "1455 Market St #400, San Francisco, United States")
            
            showDirectionsToDestination(origin: origin, destination: destination)
        }
        
    }
    
    func showDirectionsToDestination(origin: GoogleMapsDirections.Place, destination: GoogleMapsDirections.Place) {
        
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
            polyLine.strokeColor = self.hexStringToUIColor(hex: "F05D5E")
            polyLine.map = self.mapContainerView
            debugPrint("it has \(response?.routes.count ?? 0) routes")
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
