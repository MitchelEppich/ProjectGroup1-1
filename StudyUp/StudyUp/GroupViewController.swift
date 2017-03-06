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

class GroupViewController: UITableViewController {
    
    var firebase = Firebase()
    var refHandle : UInt!
    var groupList = [StudyGroup]()
    
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        fetchGroups()
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
            let postDict = snapshot.value as? [String : AnyObject] ?? [:] {
            
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
