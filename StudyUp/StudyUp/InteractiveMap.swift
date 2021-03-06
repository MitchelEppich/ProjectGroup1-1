//
//  InteractiveMap.swift
//  StudyUp
//
//  Created by Mitchel Eppich on 2017-03-06.
//  Copyright © 2017 SFU Health++. All rights reserved.
//

import Foundation
import MapKit

class InteractiveMap: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var mapView: MKMapView
    
    var mapHasCenteredOnce = false
    
    init(mapView : MKMapView) {
        self.mapView = mapView
    }
    
    var firebase = Firebase()
    
    //var geoFire : GeoFire!
    //var geoFireRef : FIRDatabaseReference!
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView.showsUserLocation = true
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        
        mapView.setRegion(coordinateRegion, animated: true)
        
        //mapView.delegate = self
        //mapView.userTrackingMode = MKUserTrackingMode.follow
    }
    
    func createStudyGroupLocation(group: StudyGroup) {
        
        let path = firebase.geoFireRef.child("group").child("\(group.privacy)").child(group.id!)
        
        path.child("Name").setValue(group.name)
        path.child("Type").setValue("\(group.type)")
        firebase.geoFire.setLocation(group.location, forKey: group.id)
    }
    
    func showGroupOnMap(location : CLLocation) {
        let circleQuery = firebase.geoFire.query(at: location, withRadius: 100)
        
        _ = circleQuery?.observe(GFEventType.keyEntered, with: {
            (key, location) in
            
            if let location = location {
                let anno = GroupAnnotation(coordinate: location.coordinate, groupType: 1)
                self.mapView.addAnnotation(anno)
            }
        })
    }
    
    
    
    
// Kit functions
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let loc = userLocation.location {
            if !mapHasCenteredOnce {
                centerMapOnLocation(location: loc)
                mapHasCenteredOnce = true
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annoIdentifier = "Group"
        var annotationView : MKAnnotationView?
        
        if annotation.isKind(of: MKUserLocation.self) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
            annotationView?.image = UIImage(named: "location_icon")
        } else if let deqAnno = mapView.dequeueReusableAnnotationView(withIdentifier: annoIdentifier) {
            annotationView = deqAnno
            annotationView?.annotation = annotation
        } else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annoIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av
        }
        
        if let annotationView = annotationView, let anno = annotation as? GroupAnnotation {
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "\(anno.groupType)")
            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn.setImage(UIImage(named: "map"), for: .normal)
            annotationView.rightCalloutAccessoryView = btn
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let loc = CLLocation (latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        showGroupOnMap(location: loc)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let anno = view.annotation as? GroupAnnotation {
            
            var place: MKPlacemark!
            if #available(iOS 10.0, *) {
                place = MKPlacemark(coordinate: anno.coordinate)
            } else {
                place = MKPlacemark(coordinate: anno.coordinate, addressDictionary: nil)
            }
            
            let destination = MKMapItem(placemark: place)
            destination.name = "Study Group"
            let regionDistance: CLLocationDistance = 1000
            let regionSpan = MKCoordinateRegionMakeWithDistance(anno.coordinate, regionDistance, regionDistance)
            
            let options = [MKLaunchOptionsMapCenterKey : NSValue (mkCoordinate : regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span), MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking] as [String : Any]
            
            MKMapItem.openMaps(with: [destination], launchOptions: options)
        }
    }
}
