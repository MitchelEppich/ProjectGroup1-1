//
//  SignupViewController.swift
//  StudyUp
//
//  Created by Mitchel Eppich on 2017-03-10.
//  Copyright © 2017 SFU Health++. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UserProfileDelegate {

    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var nameField: UITextField!
    
    @IBAction func checkInput(_ sender: Any) {
        let text = emailField.text
        if !(text?.contains("@sfu.ca"))! {
            emailField.backgroundColor = UIColor.red
        } else {
            emailField.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        let profile = UserProfile()
        
        profile.delegate = self
        
        profile.email = emailField.text
        profile.username = nameField.text
    
        profile.archiveProfile()
        
        // Request verification
        
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GroupViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
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
