//
//  GroupViewController.swift
//  StudyUp
//
//  Created by Mitchel Eppich on 2017-03-04.
//  Copyright © 2017 SFU Health++. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MapKit

class GroupViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, MapViewDelegate {
    
    var group : StudyGroup = StudyGroup()
    
    var firebase = Firebase()
    
    let courses = SFU_Course_db().course
    
    @IBOutlet var groupNameTF: UITextField!
    @IBOutlet var groupCoursePicker: UIPickerView!
    @IBOutlet var groupTypePicker: UIPickerView!
    @IBOutlet var hiddenToggle: UISwitch!
    @IBOutlet var adminProtToggle: UISwitch!
    @IBOutlet var createGroupBtn: UIButton!
    
    /*
     This action when clicked will redirect the user to a presented
     map view of the MapViewController allowing user to select a location
     on it and setting itself as a delegate to the MapViewController
     protocol delegate
     */
    @IBAction func selectLocation(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        
        vc.locationSelectionPortal = true
        
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    /*
     Conforms with the MapViewController protocol which allows this view and 
     the MapViewController to pass data when this view presents the map
    */
    func sendLocationToPrevVC(location:AnyObject!) {
        self.group.location = (location as! CLLocation?)!
    }
    
    // Sets up the view as well as allows users to tap screen to dismiss the keyboard
    override func viewDidLoad() {
        super.viewDidLoad()

        groupTypePicker.delegate = self
        groupCoursePicker.delegate = self
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GroupViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    // Retrieves all information from the input feilds in the view and passes them into FIREBASE
    // The selected database which stores them as json's online for further retrieval and manipulation
    @IBAction func createGroup(_ sender: Any) {
        
        self.group.name = groupNameTF.text!
        let privacy = hiddenToggle.isOn && adminProtToggle.isOn ? StudyGroup.group_privacy.closed : adminProtToggle.isOn ? StudyGroup.group_privacy.locked : StudyGroup.group_privacy.open
        self.group.privacy = privacy.rawValue
        
        
        
        self.group.save()
        //self.group.load(id: group.id)
    }
    
    // Populates the picker view with the data in our StudyGroup model Object
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == groupTypePicker {
            group.type = StudyGroup().pickerDataArray[row]
            if group.type == StudyGroup.group_type.none.rawValue {
                createGroupBtn.isEnabled = false
                createGroupBtn.alpha = 0.5
            } else {
                createGroupBtn.isEnabled = true
                createGroupBtn.alpha = 1
            }
            return group.type
        }
        else {
            return courses[row]
        }
        
    }
    
    // Returns the number of picker components
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Returns the number of cells in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == groupTypePicker{
            return StudyGroup().pickerDataArray.count
        }
        else{
            return courses.count
        }
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
