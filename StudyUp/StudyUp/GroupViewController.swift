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

class GroupViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, GetLocation {
    
    var groupLocation : CLLocation?
    var groupName : String?
    var groupType = StudyGroup.group_type.social.rawValue
    var groupPrivacy : StudyGroup.group_privacy?
    var groupId = Firebase().geoFireRef.childByAutoId().key
    
    var firebase = Firebase()
    
    
    @IBOutlet var groupNameTF: UITextField!
    @IBOutlet var groupTypePicker: UIPickerView!
    @IBOutlet var hiddenToggle: UISwitch!
    @IBOutlet var adminProtToggle: UISwitch!
    
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
        groupLocation = location as! CLLocation?
    }
    
    // Sets up the view as well as allows users to tap screen to dismiss the keyboard
    override func viewDidLoad() {
        super.viewDidLoad()

        groupTypePicker.delegate = self
        
        print(groupLocation ?? "NO LOCATION")
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GroupViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    // Retrieves all information from the input feilds in the view and passes them into FIREBASE
    // The selected database which stores them as json's online for further retrieval and manipulation
    @IBAction func createGroup(_ sender: Any) {
        
        groupName = groupNameTF.text
        groupPrivacy = hiddenToggle.isOn && adminProtToggle.isOn ? StudyGroup.group_privacy.closed : adminProtToggle.isOn ? StudyGroup.group_privacy.locked : StudyGroup.group_privacy.open
        
        let path = firebase.geoFireRef.child("group").child("\(groupPrivacy!)").child(groupId)
        
        path.child("Name").setValue(groupName!)
        path.child("Type").setValue("\(groupType)")
        
        let gf : GeoFire = GeoFire(firebaseRef: path)
        
        gf.setLocation(groupLocation!, forKey: "Location")
    }
    
    // Populates the picker view with the data in our StudyGroup model Object
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        groupType = StudyGroup().pickerDataArray[row]
        return groupType
    }
    
    // Returns the number of picker components
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Returns the number of cells in the picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return StudyGroup().pickerDataArray.count
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
