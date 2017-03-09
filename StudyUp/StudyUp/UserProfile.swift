//
//  UserProfile.swift
//  StudyUp
//
//  Created by Mitchel Eppich on 2017-03-08.
//  Copyright © 2017 SFU Health++. All rights reserved.
//

import Foundation
import Firebase

class UserProfile : NSObject {
    
    var username : String!
    var email : String!
    var bio : String?
    var major : String?
    var courses : NSMutableArray?
    
    var deviceID : String! = UIDevice.current.identifierForVendor!.uuidString
    
    var PATH : String!
    
    override init() {
        PATH = "profile/\(deviceID!)"
    }
    
    func retreiveProfile () {
        
        let firebase = Firebase()
        
        _ = firebase.geoFireRef.child(PATH).observe(FIRDataEventType.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.username = dictionary["username"] as! String!
                self.email = dictionary["email"] as! String!
                self.bio = dictionary["bio"] as! String?
                self.major = dictionary["major"] as! String?
                self.courses = dictionary["courses"] as! NSMutableArray?
            }
            
        })
    
    }
    
    func archiveProfile () {
        
        let firebase = Firebase()
        
        let path = firebase.geoFireRef.child(PATH)
        
        path.child("username").setValue(self.username)
        path.child("email").setValue(self.email)
        path.child("bio").setValue(self.bio)
        path.child("major").setValue(self.major)
        path.child("courses").setValue(self.courses)
    }
    
    func storeProfile () {
        
    }
    
    func loadProfile () {
        
    }
}
