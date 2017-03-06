//
//  MapViewController.swift
//  StudyUp
//
//  Created by Mitchel Eppich on 2017-03-04.
//  Copyright © 2017 SFU Health++. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var mapHasCenteredOnce = false
    
    var locationSelectionPortal = false
    
    var firebase = Firebase()
    
    //var geoFire : GeoFire!
    //var geoFireRef : FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView?.delegate = self
        mapView?.userTrackingMode = MKUserTrackingMode.follow
        
        //geoFireRef = FIRDatabase.database().reference()
        //geoFire = GeoFire(firebaseRef: geoFireRef)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView?.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView?.showsUserLocation = true
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        
        mapView?.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let loc = userLocation.location {
            if !mapHasCenteredOnce {
                centerMapOnLocation(location: loc)
                mapHasCenteredOnce = true
            }
        }
    }
    
    func createStudyGroupLocation(group: StudyGroup) {
        
        let path = firebase.geoFireRef.child("group").child("\(group.privacy)").child(group.id!)
        
        path.child("Name").setValue(group.name)
        path.child("Type").setValue("\(group.type)")
        firebase.geoFire.setLocation(group.location, forKey: group.id)
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
            annotationView.image = UIImage(named: anno.groupTag)
            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn.setImage(UIImage(named: "map"), for: .normal)
            annotationView.rightCalloutAccessoryView = btn
        }
        
        return annotationView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showGroupOnMap(location : CLLocation) {
        if locationSelectionPortal { return }
        
        var group : StudyGroup
        
        _ = firebase.geoFireRef.child("group").child("open").observe(FIRDataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            
            print(postDict)
            
            
        })
        
        /*
        let circleQuery = firebase.geoFire.query(at: location, withRadius: 100)
        
        _ = circleQuery?.observe(GFEventType.keyEntered, with: {
            (key, location) in
            
            if let location = location {
                let anno = GroupAnnotation(coordinate: location.coordinate, groupType: 2)
                self.mapView.addAnnotation(anno)
            }
        })*/
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

    @IBAction func setGroupStudyLocation(_ sender: UILongPressGestureRecognizer) {
        //print("tapped")
        if sender.state != UIGestureRecognizerState.began { return }
        let touchLocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        let loc = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        
        if locationSelectionPortal {
            
            
            //self.show(destination, sender: self)
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "GroupViewController") as! GroupViewController
            
            vc.groupLocation = loc
            
            self.present(vc, animated: true, completion: nil)

        } else {
            
        }
        
        //print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
        
        
        //let group = StudyGroup()
        //group.location = loc
        
        //let rand = 0//arc4random_uniform(0) + 1
        //createStudyGroupLocation(group: group)//Int(rand))
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
