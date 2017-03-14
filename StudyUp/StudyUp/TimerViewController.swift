//
//  TimerViewController.swift
//  StudyUp
//
//  Created by Mitchel Eppich on 2017-03-04.
//  Copyright © 2017 SFU Health++. All rights reserved.
//
//  Contributions from: Owen Kwok, Leone Tory
//

import UIKit

class TimerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let courses = SFU_Course_db().course
    
    var timerCount = 60
    var timerRunning = false
    var timer = Timer()
    var timerEnabled = false
    var sessionTime = 3000 // 3000 seconds = 50 min sessions
    var breakTime = 600 // = 10 min break

    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var totalTextLabel: UILabel!
    
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
    
    // Sends value from UIDatePicker
    @IBAction func timePickerAction(_ sender: UIDatePicker) {
        timerCount = Int(timePicker.countDownDuration)
    }
    @IBAction func courseButtonPressed(_ sender: AnyObject) {
        coursePicker.isHidden = false
        smartStudyToggleView.isHidden = true
        smartStudyView.isHidden = true
    }
    
    // Toggles smartStudy
    @IBAction func smartStudyToggled(_ sender: AnyObject) {
        if smartStudyToggle.isOn{
            smartStudyView.isHidden = false
        }
        else {
            smartStudyView.isHidden = true
            totalTimeLabel.isHidden = true
            totalTextLabel.isHidden = true
        }
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
    
    // Displays courses to select
    // Currently hard coded course selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        coursePickerButton.setTitle(courses[row], for: UIControlState.normal)
        coursePicker.isHidden = true
        smartStudyView.isHidden = false
        smartStudyToggleView.isHidden = false
    }
    
    // Main functionality of timer
    // Uses timerCount to display the timer value and initializes timer
    @IBAction func startButtonPressed(_ sender: UIButton) {
        smartStudyToggleView.isHidden = false
        smartStudyToggle.isHidden = false
        coursePickerButton.isHidden = true
        
        // Prevents multiple timers running
        if timerRunning == false {
            timerCount = Int(timePicker.countDownDuration)
            timerRunning = true
            
            // Timer function buttons
            startButton.isHidden = true
            endButton.isHidden = false
            breakButton.isHidden = false
            
            // Hide/show UI elements
            timePicker.isHidden = true
            countDownLabel.isHidden = false
            coursePickerButton.isHidden = true
            smartStudyToggle.isUserInteractionEnabled = false

            if smartStudyToggle.isOn{
                totalTimeLabel.isHidden = false
                totalTextLabel.isHidden = false
            }
            runTimer()
        }
    }
    
    func runTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(TimerViewController.updateCounter)), userInfo: nil, repeats: true)
        coursePicker.isHidden = true
        coursePickerButton.isHidden = true
    }
    
    func updateCounter() {
        timerCount -= 1
        sessionTime -= 1
        
        // Smart Study ON counter with small total timer
        if smartStudyToggle.isOn{
            if (timerCount > sessionTime){
                countDownLabel.text = timeString(time: TimeInterval(sessionTime))
                totalTimeLabel.text = timeString(time: TimeInterval(timerCount))
            }
            else {
                countDownLabel.text = timeString(time: TimeInterval(timerCount))
                totalTimeLabel.text = timeString(time: TimeInterval(timerCount))
            }
        }
            
        // Smart Study OFF
        else{
            countDownLabel.text = timeString(time: TimeInterval(timerCount))
        }
        
        if timerCount == 0 {
            timer.invalidate()
            timerRunning = false
        }
    }
    
    @IBAction func breakBtnPressed(_ sender: UIButton) {
        resumeButton.isHidden = false
        coursePickerButton.isHidden = true
        smartStudyToggle.isHidden = false
        breakButton.isHidden = true
        timer.invalidate()
    }
    
    @IBAction func resumeBtnPressed(_ sender: UIButton) {
        breakButton.isHidden = false
        coursePickerButton.isHidden = true
        resumeButton.isHidden = true

        runTimer()
    }
    
    // Ends timer and displays the standard timer UI
    @IBAction func endButtonPressed(_ sender: UIButton) {
        timer.invalidate()
        timerRunning = false
        
        // Timer buttons
        startButton.isHidden = false
        endButton.isHidden = true
        breakButton.isHidden = true
        resumeButton.isHidden = true
        
        // Timer UI labels
        timePicker.isHidden = false
        countDownLabel.isHidden = true
        totalTimeLabel.isHidden = true
        totalTextLabel.isHidden = true
        
        // Button UI
        smartStudyToggleView.isHidden = false
        smartStudyToggle.isHidden = false
        coursePickerButton.isHidden = false
        smartStudyToggle.isUserInteractionEnabled = true
    }
    
    // Method to format time into HH:MM:SS
    func timeString(time:TimeInterval) -> String {
        coursePickerButton.isHidden = true
        
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
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
