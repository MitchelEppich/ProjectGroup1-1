//
//  Course.swift
//  StudyUp
//
//  Created by Mitchel Eppich on 2017-03-08.
//  Copyright © 2017 SFU Health++. All rights reserved.
//

import Foundation

class Course : NSObject {
    
    var courseID :String?
    var courseCode : Int?
    
    var courseTime : TimeInterval! // timeString from TimerViewController
    var suggestedTime : TimeInterval! // allows a ratio to be created
    
    
    func updateProfile(){
        
        // send over this specific course information to course
        // profile should do a for loop to get all courses?
        
        // prehaps include in ProfileVIewController
        
        
    }
    
    func getTime( time: TimeInterval){
        
        // get the time from timer
        
    }
    
    
}
