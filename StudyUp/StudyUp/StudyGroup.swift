//
//  StudyGroup.swift
//  StudyUp
//
//  Created by Mitchel Eppich on 2017-03-05.
//  Copyright © 2017 SFU Health++. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MapKit

protocol StudyGroupDelegate {}

class StudyGroup: NSObject {
    
    var delegate : StudyGroupDelegate?
    
    enum group_type : String {
        case none
        case silent
        case social
        case hangout
        case cramming
    }
    
    let pickerDataArray = [
        group_type.none.rawValue,
        group_type.silent.rawValue,
        group_type.cramming.rawValue,
        group_type.hangout.rawValue,
        group_type.social.rawValue
    ]
    
    enum group_privacy : String {
        case closed
        case open
        case locked
    }
    
    var location = CLLocation()
    var name: String = "default"
    var id : String = Firebase().geoFireRef.childByAutoId().key
    var course : String?
    var type : String = group_type.social.rawValue
    var privacy : String = group_privacy.open.rawValue
    var desc : String? = "This group does not have a description."
    var members : [Int]?
    var loc : AnyObject?
    
    var coordinate : CLLocationCoordinate2D?
    var title : String?
    
    var PATH : String!

    init(group : StudyGroup? = nil) {
        PATH = "groups"
        
        if group != nil {
            self.location = (group?.location)!
            self.name = (group?.name)!
            self.id = (group?.id)!
            self.course = group?.course
            self.type = (group?.type)!
            self.privacy = (group?.privacy)!
        }
    }
    
    func retrieveAllStudyGroups(mapView : MKMapView) {
        
        let firebase = Firebase()
        
        //let groups : NSMutableArray = []
        
        _ = firebase.geoFireRef.child("groups/open/general").observe(FIRDataEventType.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let group = StudyGroup()
                
                for (key, element) in dictionary {
                    //print(element)
                    group.id = key as String
                    //print(group.id)
                    group.name = (element["name"] as? String)!
                    group.type = (element["type"] as? String)!
                    //print(group.name)
                    //print(group.type)
                    var location = element["location"] as? [String: AnyObject]
                    //print(location ?? "Not asfsdfd")
                    //if location == nil { continue } // Stop in cause there is an error and location is nil
                    let arr : NSMutableArray = location?["l"] as! NSMutableArray
                    
                    let lat = arr[0]
                    let lon = arr[1]
                    //print(lat)
                    //print(lon)
                    group.location = CLLocation(latitude: lat as! CLLocationDegrees, longitude: lon as! CLLocationDegrees)
                    //print(group.location)
                    //groups.add(group)
                    
                    let anno = MapAnnotation(group: group)
                    mapView.addAnnotation(anno)
                }
                
            }
        })
        //print(groups.count)
        //self.delegate?.retreiveStudyGroups(group_list: groups)
    }
    
    func retreiveStudyGroup() -> StudyGroup {
        return StudyGroup()
    }
    
    func archiveStudyGroup() {
        
        let firebase = Firebase()
        self.course = "general"
        //if self.course == nil { self.course = "general" }
        
        let path = firebase.geoFireRef.child("\(PATH!)/\(self.privacy)/\(self.course!)/\(self.id)")
        
        path.child("name").setValue(self.name)
        path.child("type").setValue(self.type)
        
        let gf : GeoFire = GeoFire(firebaseRef: path)
        
        gf.setLocation(self.location, forKey: "location")    }
    
//    func createAnnotation(group : StudyGroup) -> MKAnnotation {
//        coordinate = self.location.coordinate
//        title = self.name
//        return self as! MKAnnotation
//    }
    
    func save() {
        let ref = FIRDatabase.database().reference()
        let dictionary = [
            "id" : id,
            "name" : name,
            "desc" : desc ?? "No description for this group.",
            "course" : course ?? "No Course",
            "type" : type,
            "privacy" : privacy,
            "loc" : [
                "coord" : [
                    "lon" : location.coordinate.longitude,
                    "lat" : location.coordinate.latitude
                ]
            ]
        ] as [String : Any]

        let path = "groups/\(privacy)/\(course ?? "No Course")/\(type)/\(name)"
        let en_ref = ref.child("groups/\(privacy)/\(course ?? "No Course")/\(type)/\(name)")
        en_ref.setValue(dictionary)
        ref.child("group_ref").updateChildValues([
            id : path
            ])
    }
    
    func load(info : [String : Any]) {
        self.setValuesForKeys(info)
        loc = loc?["coord"] as AnyObject?
        self.location = CLLocation(latitude: (loc?["lat"] as? CLLocationDegrees)!, longitude: (loc?["lon"] as? CLLocationDegrees)!)
    }
    
    func retreive(id : String) {
        let ref = FIRDatabase.database().reference()
        // Acquire path to the group
        _ = ref.child("group_ref").observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : Any] {
                self.PATH = dictionary["\(id)"] as! String!
                // Acquire group information
                ref.child("\(self.PATH)").observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String : Any] {
                        self.load(info : dictionary)
                    }
                })
            }
        })
    }
    
    func retreiveAll(mapView : MKMapView) {
        let ref = FIRDatabase.database().reference()
        _ = ref.child("groups").observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : [String : [String : [String : Any]]]] {
                for (privacy, courses) in dictionary { // Loop through privacy : courses
                    if privacy == "closed" { continue }
                    for (_, types) in courses {// Loop through course : types
                        for (_, groups) in types {// Loop through type : groups
                            for (_, info) in groups { // Loop through group : info
                                let group = StudyGroup()
                                group.load(info: info as! [String : Any])
                                
                                let anno = MapAnnotation(group: group)
                                mapView.addAnnotation(anno)
                            }
                        }
                    }
                }
            }
        })
    }
}

class MapAnnotation : NSObject, MKAnnotation {
    var coordinate = CLLocationCoordinate2D()
    var groupType: String = "Default"
    var groupTag: String = "Default"
    var title: String?
    var subtitle: String?
    var id: String?
    
    
    init(group : StudyGroup) {
        self.coordinate = group.location.coordinate
        self.groupType = group.type
        self.groupTag = group.name
        self.id = group.id
        self.title = self.groupTag
        self.subtitle = self.id
        
    }
}
