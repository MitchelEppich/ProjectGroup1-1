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
    
    var timerCount = 60
    var timerRunning = false
    var timer = Timer()

    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var countDownLabel: UILabel!
     
    @IBOutlet weak var coursePickerButton: UIButton!
    @IBOutlet weak var coursePicker: UIPickerView!
    
    @IBOutlet weak var smartStudyToggle: UISwitch!
    @IBOutlet weak var smartStudyToggleView: UIView!
    
    @IBOutlet weak var smartStudyView: UIView!
    
    @IBOutlet weak var breakButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coursePicker.dataSource = self
        coursePicker.delegate = self
        timePicker.countDownDuration = 60.0
        if timerCount == 0 {
            timerRunning = false
        }
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
    
    @IBAction func startButtonPressed(_ sender: AnyObject) {
        if timerRunning == false {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
            timerRunning = true
            startButton.isHidden = true
            endButton.isHidden = false
            breakButton.isHidden = false;
            
            
        }
    }
    
    @IBAction func breakBtnPressed(_ sender: AnyObject) {
        resumeButton.isHidden = false
        breakButton.isHidden = true
    }
    
    @IBAction func resumeBtnPressed(_ sender: AnyObject) {
        breakButton.isHidden = false
        resumeButton.isHidden = true
    }
    
    
    func updateCounter() {
        timerCount -= 1
        countDownLabel.text = "\(timerCount)"
        
        if timerCount == 0 {
            timer.invalidate()
            timerRunning = false
        }
    }
    
    @IBAction func endButtonPressed(_ sender: AnyObject) {
        timer.invalidate()
        timerRunning = false
        startButton.isHidden = false
        endButton.isHidden = true
        breakButton.isHidden = true
        resumeButton.isHidden = true
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
