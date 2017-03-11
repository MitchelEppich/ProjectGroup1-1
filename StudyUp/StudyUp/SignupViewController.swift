//
//  SignupViewController.swift
//  StudyUp
//
//  Created by Mitchel Eppich on 2017-03-10.
//  Copyright © 2017 SFU Health++. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignupViewController: UIViewController, UserProfileDelegate {
    
    
    @IBOutlet var signName: UITextField!
    @IBOutlet var signEmail: UITextField!
    @IBOutlet var signPassword: UITextField!
    @IBOutlet var signPasswordValid: UITextField!
    
    @IBOutlet var loginEmail: UITextField!
    @IBOutlet var loginPassword: UITextField!
    
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var signBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GroupViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }

    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func loginSwitcher(_ sender: Any) {
        signName.isHidden = !signName.isHidden
        signEmail.isHidden = !signEmail.isHidden
        signPassword.isHidden = !signPassword.isHidden
        signPasswordValid.isHidden = !signPasswordValid.isHidden
        signBtn.isHidden = !signBtn.isHidden
        
        loginEmail.isHidden = !loginEmail.isHidden
        loginPassword.isHidden = !loginPassword.isHidden
        loginBtn.isHidden = !loginBtn.isHidden
    }
    

    @IBAction func login(_ sender: Any) {
    }

    @IBAction func signup(_ sender: Any) {
        guard let email = signEmail.text, let password = signPassword.text, let passwordVerify = signPasswordValid.text, let name = signName.text else {
            print("Form is not valid")
            return
        }
        
        if password != passwordVerify {
            print("Passwords do not match")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error != nil {
                print(error ?? "Error")
                return
            }
            
            guard let uid = user?.uid else {return}
            
            // user made
            let firebase = Firebase()
            let usersRef = firebase.geoFireRef.child("users/\(uid)")
            let values = ["name": name, "email": email]
            usersRef.updateChildValues(values, withCompletionBlock : { (err, ref) in
                if err != nil {
                    print(err ?? "Error")
                    return
                }
                
                print("Saved user into Firebase DB")
            })
        })
    }
}
