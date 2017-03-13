//
//  GroupSearchViewController.swift
//  StudyUp
//
//  Created by Mitchel Eppich on 2017-03-13.
//  Copyright © 2017 SFU Health++. All rights reserved.
//

import UIKit
import Firebase

class GroupSearchViewController: UITableViewController {

    let cellId = "cellId"
    
    var groups = [StudyGroup]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(GroupCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    }

    func fetchUser() {
        FIRDatabase.database().reference().child("groups/open/general").observe(.childAdded, with: { (snapshot) in
        
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let group = StudyGroup()
                group.setValuesForKeys(dictionary)
                
                var location = dictionary["location"] as? [String: AnyObject]
                //print(location ?? "Not asfsdfd")
                //if location == nil { continue } // Stop in cause there is an error and location is nil
                let arr : NSMutableArray = location?["l"] as! NSMutableArray
                
                let lat = arr[0]
                let lon = arr[1]
                
                group.location = CLLocation(latitude: lat as! CLLocationDegrees, longitude: lon as! CLLocationDegrees)
                
                self.groups.append(group)
                
                // this will crash due to background thread so use dispatch to fix
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            //print("Group Found")
            
            //print(snapshot)
        })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = groups[indexPath.row].location
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController

        self.show(vc, sender: self)
        vc.mapHasCenteredOnce = true
        vc.centerMapOnLocation(location: location)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        
        let group = groups[indexPath.row]
        
        cell?.textLabel?.text = group.name
        cell?.detailTextLabel?.text = group.type
        
        return cell!
        
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

class GroupCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
