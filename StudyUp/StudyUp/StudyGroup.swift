//
//  StudyGroup.swift
//  StudyUp
//
//  Created by Mitchel Eppich on 2017-03-05.
//  Copyright © 2017 SFU Health++. All rights reserved.
//

import Foundation
import UIKit

class StudyGroup: NSObject {
    enum group_type: String {
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
    
    enum group_privacy {
        case closed
        case open
        case locked
    }
    
    var location = CLLocation()
    var name: String = "Default"
    var id : String = "Default"
    var type : String = "Default"
    var privacy : String = "Default"
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
