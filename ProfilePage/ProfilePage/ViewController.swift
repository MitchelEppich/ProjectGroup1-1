//
//  ViewController.swift
//  ProfilePage
//
//  Created by Kitty Luo on 3/5/17.
//  Copyright © 2017 Kitty Luo. All rights reserved.
//

import UIKit



class ViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    var editEnable = false
    
    // cannot be edited
    @IBOutlet weak var profileName: UILabel!

    
    
    // can be edited
    @IBOutlet weak var profileBio: UITextView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileColor: UIImageView!
    
    @IBOutlet weak var profileFaculty: UITextView!
    
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
        
        profilePicture.image = selectedImage
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    // finished with the code portion of edit profile picture
    
    
    
 //   func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
//        self.dismiss(animated: true, completion: { () -> Void in
            
 //       })
        
 //       profilePicture.image = image
        
//    }
    
    
    
//    if picker != nil{
    
//    didFinishPickingMediaWithInfo info: [String : AnyObject])
    
//    let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
//    profilePicture.contentMode = .scaleAspectFit //3
//    profilePicture.image = chosenImage //4
//    }
//    else{

    
//    dismiss(animated:true, completion: nil) //5
//    }
    
    
    
}







