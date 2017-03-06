//
//  StudyGroup.swift
//  StudyUp
//
//  Created by Mitchel Eppich on 2017-03-05.
//  Copyright © 2017 SFU Health++. All rights reserved.
//

import Foundation

class StudyGroup: NSObject {
    enum group_type {
        case silent
        case social
        case hangout
        case cramming
    }
    
    enum group_privacy {
        case closed
        case open
        case locked
    }
    
    var location = CLLocation()
    var name: String?
    var id : String?
    var type : group_type?
    var privacy : group_privacy?
    var members : [Int]?
    
    /*
    init(id: String, type: group_type, privacy: group_privacy,  name: String, location: CLLocation) {
        self.location = location
        self.id = id
        self.name = name
        self.type = type
        self.privacy = privacy
    }
 */
}
