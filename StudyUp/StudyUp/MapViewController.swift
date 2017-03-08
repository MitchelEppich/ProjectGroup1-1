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


// Protocol to allow for data transfer to a parent view
protocol GetLocation {
    func sendLocationToPrevVC(location:AnyObject!)
}

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // Delegate for the protocol
    var delegate:GetLocation?
    
    @IBOutlet weak var mapView: MKMapView!
    
    var selectedLocation: CLLocation?
    
    let locationManager = CLLocationManager()
    var mapHasCenteredOnce = false
    
    var locationSelectionPortal = false
    
    var firebase = Firebase()
    
    // Prepares the map view for tracking the users location dynamically
    // as well as setting the map delegate to self to retreive data
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView?.delegate = self
        mapView?.userTrackingMode = MKUserTrackingMode.follow
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // Check if the app is allowed to use the users location
    override func viewDidAppear(_ animated: Bool) {
        locationAuthStatus()
    }
    
    // If the user has allowed location services to our app then we will focus on
    // the user location else request authorization
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView?.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // Requests authorization for location services from the user.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView?.showsUserLocation = true
        }
    }
    // Center map location at a inputed location
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 2000, 2000)
        
        mapView?.setRegion(coordinateRegion, animated: true)
    }
    
    // Update the map, in this case update the focus on the user if the app has not already
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if let loc = userLocation.location {
            if !mapHasCenteredOnce {
                centerMapOnLocation(location: loc)
                mapHasCenteredOnce = true
            }
        }
    }
    
    // Simply creates independent annotations on the map unless there is a reuasable annotation of the
    // Same style in that case this function will reuse that instead of creating a new one, as well this 
    // creates the annotations for the user and every other element on our map, ie. groups
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
    
        if let annotationView = annotationView, let _ = annotation as? GroupAnnotation {
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "1")
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
    
    
    // Access's the groups database sub section in our Firebase Database and retrieves(observes) all values in that location
    // inputing them into a single dictionary which is then parsed through and broken down into StudyGroups using all the data
    // Saved on the Database and then finally creating and adding a group annotation to the map
    func showGroupOnMap(location : CLLocation) {
        if locationSelectionPortal { return }
        
        _ = firebase.geoFireRef.child("group").child("open").observe(FIRDataEventType.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let group = StudyGroup()
                
                
                for (key, element) in dictionary {
                    group.id = key as String
                    
                    group.name = element["Name"] as! String
                    group.type = "silent"//element["Type"] as! String
                    
                    var location = element["Location"] as? [String: AnyObject]
                    if location == nil { continue } // Stop in cause there is an error and location is nil
                    let arr : NSMutableArray = location?["l"] as! NSMutableArray
                    
                    let lat = arr[0]
                    let lon = arr[1]
                    
                    group.location = CLLocation(latitude: lat as! CLLocationDegrees, longitude: lon as! CLLocationDegrees)
                    
                    let anno = GroupAnnotation(group: group)
                    self.mapView.addAnnotation(anno)

                }

            }
        })
    }
    
    // Shows the groups with in the view of the map at the users specific location on the entire map
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let loc = CLLocation (latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        
        showGroupOnMap(location: loc)
    }
    
    // Displays and allows for the annotations to have placemarkers once pressed, this allows for simple information to be displayed overhead the 
    // requested group
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

    // When the user holds on a specific locations on the map that location will be saved and 
    // Used in other areas of the app after dismissing this modal presented view.
    @IBAction func setGroupStudyLocation(_ sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizerState.began { return }
        let touchLocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        selectedLocation = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        
        if locationSelectionPortal {
            
            self.dismiss(animated: false, completion: nil)

        }
    }
    
    // If the view is being used for collecting a specific location it will be dismissed once
    // a location is selected and this function will send data to the parent view.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isBeingDismissed {
            self.delegate?.sendLocationToPrevVC(location: selectedLocation)
        }
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
