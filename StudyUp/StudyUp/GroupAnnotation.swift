//
//  GroupAnnotation.swift
//  StudyUp
//
//  Created by Mitchel Eppich on 2017-03-04.
//  Copyright © 2017 SFU Health++. All rights reserved.
//

import Foundation
import MapKit

class GroupAnnotation: NSObject, MKAnnotation {
    var coordinate = CLLocationCoordinate2D()
    var groupType: String
    var groupTag: String
    var title: String?
    
    
    init(group : StudyGroup) {
        self.coordinate = group.location.coordinate
        self.groupType = (group.type?.rawValue)!
        self.groupTag = group.name!
        self.title = self.groupTag
    }
}
