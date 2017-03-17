//
//  ProfileViewController.swift
//  StudyUp
//
//  Created by Mitchel Eppich on 2017-03-04.
//  Copyright © 2017 SFU Health++. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UserProfileDelegate {
    
    var user : UserProfile = UserProfile()
    
    var editEnable = false
    
    // cannot be edited
    @IBOutlet weak var profileName: UILabel!
    
    // can be edited
    @IBOutlet weak var profileBio: UITextView!
    @IBOutlet weak var profileFaculty: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    // used for connections with the timer
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet var courseProgress: UIProgressView!
    
    
    // click for edit
    @IBOutlet weak var profileEdit: UIButton!
    
    @IBOutlet weak var add: UIButton!
    
    // hidden
    @IBOutlet weak var profileImageEdit: UIButton!

    
    
    
    // ------------UI items listed---------------
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //later:  take user data from server/local
        
        // set initial status to not editable
        
        profileBio.isEditable = false
        profileFaculty.isEditable = false
        profileImageEdit.isHidden = true
        add.isHidden = true
        
        loadUserInformation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Firebase interation ------------------------------------------------------------------------
    
    func loadUserInformation() {
        
        FIRDatabase.database().reference().child("users/\((FIRAuth.auth()?.currentUser?.uid)!)").observeSingleEvent(of: .value, with: { (snapshot) in
            if let user = snapshot.value as? [String: AnyObject] {
                self.user.name = user["name"] as? String
                self.user.bio = (user["bio"] as? String)
                self.user.email = user["email"] as? String
            }
            self.setUserInformation()
        })
        
    }
    
    func setUserInformation () {
        self.profileBio.text = self.user.bio
        self.profileName.text = self.user.name
        self.profileFaculty.text = self.user.email
    }
    
    
    // Edit profile ------------------------------------------------------------------------
    
    
    
    // click on edit to enable editing on image, bio, and faculty
    @IBAction func editProfile(_ sender: AnyObject) {
        
        // if already one edit mode, do not enable again
        if editEnable {
            profileBio.isEditable = false
            profileFaculty.isEditable = false
            profileImageEdit.isHidden = true
            editEnable = false
            profileEdit.setTitle("Edit", for: UIControlState.normal)
            
            self.user.bio = self.profileBio.text
            
            user.update()
            
        } else {
            // allows user to:
            
            // code for when profile is in edit mode :
            
            
            // edit bio
            profileBio.isEditable = true
            // edit faculty name
            profileFaculty.isEditable = true
            // edit profile picture
            profileImageEdit.isHidden = false
            editEnable = true
            profileEdit.setTitle("Done", for: UIControlState.normal)
            
            
            // add course
            add.isHidden = false
            
        }
        
    }
    
    
    // add course
    

    @IBAction func addCourse(_ sender: AnyObject) {
        // allow user to add course
        
        
    }
    
    
    
    
    
    
    // Display ---------------------------------------------------------------------------
    
    
    // displaying prograss of a single course
    func displayPrograss(courseDisplayed : Course? ){
        
        courseName.text = courseDisplayed!.courseID
        
        let prograssRatio = Double(courseDisplayed!.courseTime) / Double(courseDisplayed!.maxTime)
        courseProgress.progress = Float(prograssRatio)
        
        
    }
    
    
    // Allow user to pick custom image ----------------------------------------------------------
    
    
    // call image picker to edit profile picture
    @IBAction func editImage(_ sender: AnyObject) {
        
        // call out image picker to allow user to select a piture from photolibrary to use for profile picture
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker,animated:true,completion: nil)
        
    }
    // set selected image as profile picture
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        profileImage.image = selectedImage
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    // finished with editing profile picture
    
    
}







