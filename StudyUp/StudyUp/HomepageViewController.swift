//
//  HomepageViewController.swift
//  StudyUp
//
//  Created by Mitchel Eppich on 2017-03-04.
//  Copyright © 2017 SFU Health++. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomepageViewController: UIViewController, UserProfileDelegate {

    @IBOutlet var profileBtn: UIButton!
    @IBOutlet var timerBtn: UIButton!
    @IBOutlet var mapBtn: UIButton!
    @IBOutlet var groupBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
            if (FIRAuth.auth()?.currentUser?.isEmailVerified)! {
                self.mapBtn.isEnabled = true
                self.groupBtn.isEnabled = true
                timer.invalidate()
            }
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        //print(FIRAuth.auth()?.currentUser?.uid ?? "No User")
        if FIRAuth.auth()?.currentUser?.uid == nil {
            UserProfile().logout()
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = mainStoryboard.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
            
            self.show(vc, sender: self)
            //let user = UserProfile()
            //user.delegate = self
            //user.logout()
        }
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
