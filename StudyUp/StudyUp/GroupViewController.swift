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

class GroupViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    

    @IBOutlet var mapView: MKMapView!
    
    
    var map : InteractiveMap!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map = InteractiveMap(mapView: mapView)
        
        map.locationAuthStatus()
        //map.centerMapOnLocation(location: mapView.userLocation.location!)
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GroupViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    /*var firebase = Firebase()
    var refHandle : UInt!
    var groupList = [StudyGroup]()
    
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //fetchGroups()
    }
  
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupList.count
    }
    
    func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        
        // Set cell contents
        cell.textLabel?.text = groupList[indexPath.row].name
        
        return cell
    }
    
    func fetchGroups() {
        
        refHandle = firebase.geoFireRef.child("group").child("open").observe(FIRDataEventType.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String : AnyObject] {
            
                print(dictionary)
                
                
                
            }
            
//            if let dictionary = snapshot.value as? [String : AnyObject] {
//
//                print(dictionary)
//                
//                let group = StudyGroup()
//                
//                group.setValuesForKeys(dictionary)
//                self.groupList.append(group)
//                
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//                
//            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
