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
    var groupType: Int
    var groupTag: String
    var title: String?
    
    
    init(coordinate: CLLocationCoordinate2D, groupType: Int) {
        self.coordinate = coordinate
        self.groupType = groupType
        self.groupTag = group[groupType - 1].capitalized
        self.title = self.groupTag
    }
}
