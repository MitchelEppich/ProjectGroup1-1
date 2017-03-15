//
//  UserProfile.swift
//  StudyUp
//
//  Created by Mitchel Eppich on 2017-03-08.
//  Copyright © 2017 SFU Health++. All rights reserved.
//

import Foundation
import Firebase

protocol UserProfileDelegate {}

class UserProfile : NSObject {
    
    let ref = FIRDatabase.database().reference()
    
    var delegate : UserProfileDelegate?
    
    var name : String!
    var email : String!
    var bio : String?
    var major : String?
    var courses : NSMutableArray?
    
    //var deviceID : String! = UIDevice.current.identifierForVendor!.uuidString
    
    var PATH : String!
    
    override init() {
        PATH = "users/\((FIRAuth.auth()?.currentUser?.uid))"
    }
    
    func logout () {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
    }
    
    func retreiveProfile () {
        
        let firebase = Firebase()
        
        _ = firebase.geoFireRef.child(PATH).observe(FIRDataEventType.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.name = dictionary["name"] as! String!
                self.email = dictionary["email"] as! String!
                //self.bio = dictionary["bio"] as! String?
                //self.major = dictionary["major"] as! String?
                //self.courses = dictionary["courses"] as! NSMutableArray?
            }
            
        })
    
    }
    
    func update() {
        let user = ["name" : self.name,
                    "bio" : self.bio,
                    "email" : self.email,
                    ]
        let userUpdates = ["users/\((FIRAuth.auth()?.currentUser?.uid)!)" : user]
        ref.updateChildValues(userUpdates)
    }
    
    func archiveProfile () {
        
        let firebase = Firebase()
        
        let path = firebase.geoFireRef.child(PATH)
        
        path.child("name").setValue(self.name)
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
