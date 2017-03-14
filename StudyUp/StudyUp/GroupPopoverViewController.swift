//
//  GroupPopoverViewController.swift
//  StudyUp
//
//  Created by Mitchel Eppich on 2017-03-13.
//  Copyright © 2017 SFU Health++. All rights reserved.
//

import UIKit

class GroupPopoverViewController: UIViewController {

    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var typeLbl: UILabel!
    @IBOutlet var idLbl: UILabel!
    @IBOutlet var privacyLbl: UILabel!
    @IBOutlet var courseLbl: UILabel!

    func populateFields(group_id: String) {
        idLbl.text = group_id
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
