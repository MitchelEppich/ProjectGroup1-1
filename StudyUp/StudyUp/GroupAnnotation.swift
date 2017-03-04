//
//  GroupAnnotation.swift
//  StudyUp
//
//  Created by Mitchel Eppich on 2017-03-04.
//  Copyright © 2017 SFU Health++. All rights reserved.
//

import Foundation
import MapKit

let group = [
    "social"//,
    //"silent",
    //"hangout",
    //"cramming"
]

class GroupAnnotation: NSObject, MKAnnotation {
    var coordinate = CLLocationCoordinate2D()
    var groupId: Int
    var groupTag: String
    var title: String?
    
    
    init(coordinate: CLLocationCoordinate2D, groupId: Int) {
        self.coordinate = coordinate
        self.groupId = groupId
        self.groupTag = group[groupId - 1].capitalized
        self.title = self.groupTag
    }
}
