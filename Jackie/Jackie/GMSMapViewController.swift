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
    let baseURLGeocode = "https://maps.googleapis.com/maps/api/geocode/json?"
    let baseURLDirections = "https://maps.googleapis.com/maps/api/directions/json?"
    var selectedRoute: Dictionary<String, String>!
    var overviewPolyline: Dictionary<String, AnyObject>!
    var originCoordinate: CLLocationCoordinate2D!
    var destinationCoordinate: CLLocationCoordinate2D!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set current location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        let origin = GoogleMapsDirections.Place.stringDescription(address: "Davis Center, Waterloo, Canada")
        let destination = GoogleMapsDirections.Place.stringDescription(address: "Conestoga Mall, Waterloo, Canada")
        GoogleMapsDirections.direction(fromOrigin: origin, toDestination: destination) { (response, error) -> Void in
            // Check Status Code
            guard response?.status == GoogleMapsDirections.StatusCode.ok else {
                // Status Code is Not OK
                debugPrint(response?.errorMessage)
                return
            }
            
            // Use .result or .geocodedWaypoints to access response details
            // response will have same structure as what Google Maps Directions API returns
            print(response?.toJSON())
            
            debugPrint("it has \(response?.routes.count ?? 0) routes")
        }
        
    }
    
//    func getDirections(origin: String!, destination: String!, waypoints: Array<String>!, travelMode: AnyObject!, completionHandler: ((_ status: String, _ success: Bool) -> Void)?) {
//        if let originLocation = origin {
//            if let destinationLocation = destination {
//                var directionsURLString = baseURLDirections + "origin=" + originLocation + "&destination=" + destinationLocation
//                if let routeWaypoints = waypoints {
//                    directionsURLString += "&waypoints=optimize:true"
//                    
//                    for waypoint in routeWaypoints {
//                        directionsURLString += "|" + waypoint
//                    }
//                }
//                print(directionsURLString)
//                directionsURLString = directionsURLString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
//                let directionsURL = NSURL(string: directionsURLString)
//                
//                DispatchQueue.main.async(execute: { () -> Void in
//                    let directionsData = NSData(contentsOf: directionsURL! as URL)
//                    do{
//                        let dictionary: Dictionary<String, String> = try JSONSerialization.jsonObject(with: directionsData as! Data, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, String>
//                        
//                        
//                        let status:String = dictionary["status"]!
//                        
//                        if status == "OK" {
//                            self.selectedRoute = (dictionary["routes"])![0]
//                            self.overviewPolyline = self.selectedRoute["overview_polyline"]
//                            
//                            let legs = self.selectedRoute["legs"] as! Array<Dictionary<NSObject, AnyObject>>
//                            
//                            let startLocationDictionary = legs[0]["start_location"] as! Dictionary<NSObject, AnyObject>
//                            self.originCoordinate = CLLocationCoordinate2DMake(startLocationDictionary["lat"] as! Double, startLocationDictionary["lng"] as! Double)
//                            
//                            let endLocationDictionary = legs[legs.count - 1]["end_location"] as! Dictionary<NSObject, AnyObject>
//                            self.destinationCoordinate = CLLocationCoordinate2DMake(endLocationDictionary["lat"] as! Double, endLocationDictionary["lng"] as! Double)
//                            
//                            let originAddress = legs[0]["start_address"] as! String
//                            let destinationAddress = legs[legs.count - 1]["end_address"] as! String
//                            
//                            let originMarker = GMSMarker(position: self.originCoordinate)
//                            originMarker.map = self.googleMapsView
//                            originMarker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
//                            originMarker.title = originAddress
//                            
//                            let destinationMarker = GMSMarker(position: self.destinationCoordinate)
//                            destinationMarker.map = self.googleMapsView
//                            destinationMarker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
//                            destinationMarker.title = destinationAddress
//                            
//                            if waypoints != nil && waypoints.count > 0 {
//                                for waypoint in waypoints {
//                                    let lat: Double = (waypoint.componentsSeparatedByString(",")[0] as NSString).doubleValue
//                                    let lng: Double = (waypoint.componentsSeparatedByString(",")[1] as NSString).doubleValue
//                                    
//                                    let marker = GMSMarker(position: CLLocationCoordinate2DMake(lat, lng))
//                                    marker.map = self.googleMapsView
//                                    marker.icon = GMSMarker.markerImageWithColor(UIColor.purpleColor())
//                                    
//                                }
//                            }
//                            
//                            let route = self.overviewPolyline["points"] as! String
//                            
//                            let path: GMSPath = GMSPath(fromEncodedPath: route)!
//                            let routePolyline = GMSPolyline(path: path)
//                            routePolyline.map = self.googleMapsView
//                        }
//                        else {
//                            print("status")
//                            //completionHandler(status: status, success: false)
//                        }
//                    }
//                    catch {
//                        print("catch")
//                        
//                        // completionHandler(status: "", success: false)
//                    }
//                })
//            }
//            else {
//                print("Destination is nil.")
//                //completionHandler(status: "Destination is nil.", success: false)
//            }
//        }
//        else {
//            print("Origin is nil")
//            //completionHandler(status: "Origin is nil", success: false)
//        }
//    }
    
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
