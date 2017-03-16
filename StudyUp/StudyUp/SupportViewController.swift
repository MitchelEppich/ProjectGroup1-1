//
//  SupportViewController.swift
//  StudyUp
//
//  Created by Leone Tory on 3/16/17.
//  Copyright © 2017 SFU Health++. All rights reserved.
//

import UIKit

class SupportViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func HealthCounsellingPressed(_ sender: AnyObject) {
        let url = URL(string :"http://www.sfu.ca/students/health/")
        UIApplication.shared.open(url!)
    }

    @IBAction func learningCommonsPressed(_ sender: AnyObject) {
        let url = URL(string :"http://www.lib.sfu.ca/about/branches-depts/slc")
        UIApplication.shared.open(url!)
    }
    
    @IBAction func academicAdvisingPressed(_ sender: AnyObject) {
        let url = URL(string :"https://www.sfu.ca/students/academicadvising.html")
        UIApplication.shared.open(url!)
    }
    
    @IBAction func sfssPressed(_ sender: AnyObject) {
        let url = URL(string :"http://www.sfss.ca/")
        UIApplication.shared.open(url!)
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
