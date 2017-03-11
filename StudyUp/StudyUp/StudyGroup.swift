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
    var members : [Int]?
    
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
                    print(element)
                    group.id = key as String
                    print(group.id)
                    group.name = (element["name"] as? String)!
                    group.type = (element["type"] as? String)!
                    print(group.name)
                    print(group.type)
                    var location = element["location"] as? [String: AnyObject]
                    print(location ?? "Not asfsdfd")
                    //if location == nil { continue } // Stop in cause there is an error and location is nil
                    let arr : NSMutableArray = location?["l"] as! NSMutableArray
                    
                    let lat = arr[0]
                    let lon = arr[1]
                    print(lat)
                    print(lon)
                    group.location = CLLocation(latitude: lat as! CLLocationDegrees, longitude: lon as! CLLocationDegrees)
                    print(group.location)
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
}

class MapAnnotation : NSObject, MKAnnotation {
    var coordinate = CLLocationCoordinate2D()
    var groupType: String = "Default"
    var groupTag: String = "Default"
    var title: String?
    
    
    init(group : StudyGroup) {
        self.coordinate = group.location.coordinate
        self.groupType = group.type
        self.groupTag = group.name
        self.title = self.groupTag
    }
}
