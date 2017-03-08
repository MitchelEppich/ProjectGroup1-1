//
//  Firebase.swift
//  StudyUp
//
//  Created by Mitchel Eppich on 2017-03-05.
//  Copyright © 2017 SFU Health++. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Firebase {
    var geoFire : GeoFire!
    var geoFireRef : FIRDatabaseReference!

    
    init() {
        geoFireRef = FIRDatabase.database().reference()
        geoFire = GeoFire(firebaseRef: geoFireRef)
    }
}
