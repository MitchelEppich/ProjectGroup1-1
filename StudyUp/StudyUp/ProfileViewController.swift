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

        
        // be in a class?
        @IBOutlet weak var courseName: UILabel!
        @IBOutlet var courseProgress: UIView!
        
        
        // click to edit
        @IBOutlet weak var profileEdit: UIButton!
        @IBOutlet weak var profileDone: UIButton!
        
        
        // hidden
        @IBOutlet weak var profileImageEdit: UIButton!
        
        
        
        // ------------UI items listed----------
        
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            
            // take user data from server/local
            
            profileDone.isHidden = true
            profileBio.isEditable = false
            profileFaculty.isEditable = false
            profileImageEdit.isHidden = true
            
            
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        
        
        // click edit to enable editing on image, bio, faculty and color
        @IBAction func editProfile(_ sender: AnyObject) {
            
            if editEnable {
                //profileDone.isHidden = true
                profileBio.isEditable = false
                profileFaculty.isEditable = false
                profileImageEdit.isHidden = true
                editEnable = false
                
                //profileEdit.isHidden = false
            } else {
                //profileEdit.isHidden = true
                //profileDone.isHidden = false
                
                // edit bio
                profileBio.isEditable = true
                
                // edit faculty name
                profileFaculty.isEditable = true
                
                
                // edit profile picture
                profileImageEdit.isHidden = false
                editEnable = true
            }
            
            
        }
        
        @IBAction func editDone(_ sender: AnyObject) {
            profileDone.isHidden = true
            profileBio.isEditable = false
            profileFaculty.isEditable = false
            profileImageEdit.isHidden = true
            
            profileEdit.isHidden = false
        }
        
        
        
        // edit profile picture
        @IBAction func editImage(_ sender: AnyObject) {
        
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(picker,animated:true,completion: nil)
            
        }
        
        func imagePickerController(_ picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [String : Any]){
            let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            profileImage.image = selectedImage
            // Dismiss the picker.
            dismiss(animated: true, completion: nil)
        }
        // finished with the code portion of edit profile picture

        
}







