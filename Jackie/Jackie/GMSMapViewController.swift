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
import PXGoogleDirections

class GMSMapViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapContainerView: GMSMapView!
    
    var locationManager = CLLocationManager()
    var startArriveDate: Date?
    
    
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    fileprivate var directionsAPI: PXGoogleDirections {
        return (UIApplication.shared.delegate as! AppDelegate).directionsAPI
    }
    
    fileprivate func modeFromField() -> PXGoogleDirectionsMode {
        return PXGoogleDirectionsMode(rawValue: 1)!
    }
    
    fileprivate func unitFromField() -> PXGoogleDirectionsUnit {
        return PXGoogleDirectionsUnit(rawValue: 0)!
    }
    
    fileprivate func transitRoutingPreferenceFromField() -> PXGoogleDirectionsTransitRoutingPreference? {
        return PXGoogleDirectionsTransitRoutingPreference(rawValue: 0)
    }
    
    fileprivate func trafficModelFromField() -> PXGoogleDirectionsTrafficModel? {
        return PXGoogleDirectionsTrafficModel(rawValue: 0)
    }
    
    fileprivate func languageFromField() -> String {
        return "English"
    }
    
    fileprivate func updateStartArriveDateField(_ newDate: Date?) {
        startArriveDate = newDate
        if let saDate = startArriveDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
//            startArriveDateField.text = dateFormatter.string(from: saDate)
        } else {
//            startArriveDateField.text = ""
        }
    }
    
//    fileprivate func updateWaypointsField() {
//        switch (waypoints).count {
//        case 0:
//            waypointsLabel.text = "No waypoints"
//        case 1:
//            waypointsLabel.text = "1 waypoint"
//        default:
//            waypointsLabel.text = "\((waypoints).count) waypoints"
//        }
//    }
//    
    
}

extension GMSMapViewController: PXGoogleDirectionsDelegate {
    func googleDirectionsWillSendRequestToAPI(_ googleDirections: PXGoogleDirections, withURL requestURL: URL) -> Bool {
        NSLog("googleDirectionsWillSendRequestToAPI:withURL:")
        return true
    }
    
    func googleDirectionsDidSendRequestToAPI(_ googleDirections: PXGoogleDirections, withURL requestURL: URL) {
        NSLog("googleDirectionsDidSendRequestToAPI:withURL:")
        NSLog("\(requestURL.absoluteString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)")
    }
    
    func googleDirections(_ googleDirections: PXGoogleDirections, didReceiveRawDataFromAPI data: Data) {
        NSLog("googleDirections:didReceiveRawDataFromAPI:")
        NSLog(NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String)
    }
    
    func googleDirectionsRequestDidFail(_ googleDirections: PXGoogleDirections, withError error: NSError) {
        NSLog("googleDirectionsRequestDidFail:withError:")
        NSLog("\(error)")
    }
    
    func googleDirections(_ googleDirections: PXGoogleDirections, didReceiveResponseFromAPI apiResponse: [PXGoogleDirectionsRoute]) {
        NSLog("googleDirections:didReceiveResponseFromAPI:")
        NSLog("Got \(apiResponse.count) routes")
        for i in 0 ..< apiResponse.count {
            NSLog("Route \(i) has \(apiResponse[i].legs.count) legs")
        }
    }
}
