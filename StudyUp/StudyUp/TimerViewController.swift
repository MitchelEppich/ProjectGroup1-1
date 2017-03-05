//
//  TimerViewController.swift
//  StudyUp
//
//  Created by Mitchel Eppich on 2017-03-04.
//  Copyright © 2017 SFU Health++. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let courses = ["MSE 483", "CMPT 276", "CMPT 361", "CMPT 363"]
    
    var seconds = 1
    var timer = Timer()

    @IBOutlet weak var timePicker: UIDatePicker!
     
    @IBOutlet weak var coursePickerButton: UIButton!
    
    @IBOutlet weak var coursePicker: UIPickerView!
    
    @IBOutlet weak var smartStudyToggle: UISwitch!
    
    @IBOutlet weak var smartStudyView: UIView!
    
    @IBOutlet weak var smartStudyToggleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coursePicker.dataSource = self
        coursePicker.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func courseButtonPressed(_ sender: AnyObject) {
        coursePicker.isHidden = false
        smartStudyToggleView.isHidden = true
        smartStudyView.isHidden = true
    }
    
    
    @IBAction func smartStudyToggled(_ sender: AnyObject) {
    }
    
    func numberOfComponents(in pickerView: UIPickerView)-> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return courses.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent: Int) -> String? {
        return courses[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        coursePickerButton.setTitle(courses[row], for: UIControlState.normal)
        coursePicker.isHidden = true
        smartStudyView.isHidden = false
        smartStudyToggleView.isHidden = false
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
