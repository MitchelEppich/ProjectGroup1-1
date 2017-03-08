//
//  ProfileViewController.swift
//  StudyUp
//
//  Created by Mitchel Eppich on 2017-03-04.
//  Copyright © 2017 SFU Health++. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    var editEnable = false
    
    // cannot be edited
    @IBOutlet weak var profileName: UILabel!
    
    // can be edited
    @IBOutlet weak var profileBio: UITextView!
    @IBOutlet weak var profileFaculty: UITextView!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    // used for connections with the timer
    @IBOutlet weak var courseName: UILabel!
    @IBOutlet var courseProgress: UIView!
    
    
    // click for edit
    @IBOutlet weak var profileEdit: UIButton!
    @IBOutlet weak var profileDone: UIButton!
    
    
    // hidden
    @IBOutlet weak var profileImageEdit: UIButton!
    
    
    
    // ------------UI items listed---------------
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //later:  take user data from server/local
        
        // set initial status to not editable
        profileDone.isHidden = true
        profileBio.isEditable = false
        profileFaculty.isEditable = false
        profileImageEdit.isHidden = true
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // click on edit to enable editing on image, bio, and faculty
    @IBAction func editProfile(_ sender: AnyObject) {
        
        // if already one edit mode, do not enable again
        if editEnable {
            profileBio.isEditable = false
            profileFaculty.isEditable = false
            profileImageEdit.isHidden = true
            editEnable = false
            profileEdit.setTitle("Edit", for: UIControlState.normal)
            
        } else {
            // allows user to:
            // edit bio
            profileBio.isEditable = true
            // edit faculty name
            profileFaculty.isEditable = true
            // edit profile picture
            profileImageEdit.isHidden = false
            editEnable = true
            profileEdit.setTitle("Done", for: UIControlState.normal)
        }
        
    }
    
    // when user clicked on done after editing
    @IBAction func editDone(_ sender: AnyObject) {
        
        // disables editing
        profileDone.isHidden = true
        profileBio.isEditable = false
        profileFaculty.isEditable = false
        profileImageEdit.isHidden = true
        
        profileEdit.isHidden = false
    }
    
    
    
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
    func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [String : Any]){
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        profileImage.image = selectedImage
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    // finished with editing profile picture
    
    
}







