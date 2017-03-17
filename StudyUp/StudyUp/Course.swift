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
    var maxTime : TimeInterval! // allows a ratio to be created
    
    
    func updateProfile(){
        
        // send over this specific course information to course
        // profile should do a for loop to get all courses?
        
        // prehaps include in ProfileVIewController
        
        
    }
    
    
    func createProfile(ID: String?, number:Int?){
        
        self.courseID = ID
        self.courseCode = number
        
        self.courseTime = 0
        // Mitchel commented this out as it was throwing and error
        //self.maxTime = 12*60*60 // 12 hours
    
        
    
    }
    
    func addTime( time: TimeInterval){
        
        // get the time from timer = self.courseTime
        self.courseTime = self.courseTime + time
        
    }
    
    // func clear time?
    
    
}
