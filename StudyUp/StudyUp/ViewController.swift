//
//  ViewController.swift
//  StudyUp
//
//  Created by Mitchel Eppich on 2017-03-02.
//  Copyright © 2017 SFU Health++. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!

    //let locationManager = CLLocationManager()
    //var mapHasCenteredOnce = false
    
    var geoFire : GeoFire!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        //mapView.userTrackingMode = MKUserTrackingMode.follow
        
        // Do any additional setup after loading the view, typically from a nib.
    }

//    override func viewDidAppear(_ animated: Bool) {
//        locationAuthStatus()
//    }
    
//    func locationAuthStatus() {
//        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
//            mapView.showsUserLocation = true
//        } else {
//            locationManager.requestWhenInUseAuthorization()
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == CLAuthorizationStatus.authorizedWhenInUse {
//            mapView.showsUserLocation = true
//        }
//    }
//    
//    func centerMapOnLocation(location: CLLocation) {
//        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
//        
//        mapView.setRegion(coordinateRegion, animated: true)
//    }
//    
//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        if let loc = userLocation.location {
//            if !mapHasCenteredOnce {
//                centerMapOnLocation(location: loc)
//                mapHasCenteredOnce = true
//            }
//        }
//    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        
//        var annotationView : MKAnnotationView?
//        
//        if annotation.isKind(of: MKUserLocation.self) {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
//            annotationView?.image = UIImage(named: "User_Icon")
//        }
//        
//        return annotationView
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

