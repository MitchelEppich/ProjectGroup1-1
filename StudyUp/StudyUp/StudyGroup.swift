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

class StudyGroup: NSObject {
    
    enum group_type : String {
        case silent
        case social
        case hangout
        case cramming
    }
    
    let pickerDataArray = [
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
    
    override init() {
        PATH = "groups"
    }
    
    func retrieveAllStudyGroups() -> NSMutableArray {
        
        let firebase = Firebase()
        
        let groups : NSMutableArray = []
        
        _ = firebase.geoFireRef.child("\(PATH!)/open/general").observe(FIRDataEventType.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let group = StudyGroup()
                
                for (key, element) in dictionary {
                    group.id = key as String
                    
                    group.name = element["name"] as! String
                    group.type = element["type"] as! String
                    
                    var location = element["location"] as? [String: AnyObject]
                    if location == nil { continue } // Stop in cause there is an error and location is nil
                    let arr : NSMutableArray = location?["l"] as! NSMutableArray
                    
                    let lat = arr[0]
                    let lon = arr[1]
                    
                    group.location = CLLocation(latitude: lat as! CLLocationDegrees, longitude: lon as! CLLocationDegrees)
                    
                    groups.add(group)
                    
                }
                
            }
        })
        
        return groups
    }
    
    func retreiveStudyGroup() -> StudyGroup {
        return StudyGroup()
    }
    
    func archiveStudyGroup() {
        
        let firebase = Firebase()
        
        if self.course == nil { self.course = "general" }
        
        let path = firebase.geoFireRef.child("\(PATH!)/\(self.privacy)/\(self.course!)/\(self.id)")
        
        path.child("name").setValue(self.name)
        path.child("type").setValue(self.type)
        
        let gf : GeoFire = GeoFire(firebaseRef: path)
        
        gf.setLocation(self.location, forKey: "location")    }
    
    func createAnnotation() -> MKAnnotation {
        coordinate = self.location.coordinate
        title = self.name
        return self as! MKAnnotation
    }
}
