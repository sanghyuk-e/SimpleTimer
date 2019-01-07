//
//  TimerViewController.swift
//  SimpleTimer
//
//  Created by sanghyuk on 04/01/2019.
//  Copyright © 2019 sanghyuk. All rights reserved.
//

import UIKit
import MBCircularProgressBar
import AudioToolbox
import UserNotifications

class TimerViewController: UIViewController {
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var button1: UIButton!
    @IBAction func onBack(_ sender: Any) {
        timerIsOn = false
        isOnBreak = false
        timer.invalidate()
        self.presentingViewController?.dismiss(animated: true)
        
    }
    @IBOutlet private weak var progresssView: MBCircularProgressBarView!
    
    var setTime: String = ""
    var timer = Timer()
    var timerIsOn = false
    var timeRemaining = 0
    var isOnBreak = false
    var onlyTime: String = ""
    
    var countH: Int = 0
    var countM: Int = 0
    var countS: Int = 0
    var h:Int = 0
    var m:Int = 0
    var s:Int = 0
    
    var ampm: String = ""
    var calTime = 0
    
    override func viewDidLoad() {
//        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in })
        
        self.progresssView.value = 0
        button1.layer.cornerRadius = 25
        button1.layer.borderWidth = 1
        button1.layer.borderColor = UIColor.clear.cgColor
        
        print("\n---------- [ view 2 ] ----------\n")
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        print("AMPM : " + ampm)
        
        let cTime = (hour * 3600) + (minutes * 60) + second
        var setCount = 0
        
        if ampm == "AM" {
            let ah = h * 3600
            let am = m * 60
            // 설정시간
            setCount = ah + am
            print("\n---------- [ ---- ] ----------\n")
        } else {
            let ph = (h + 12) * 3600
            let pm = m * 60
            // 설정시간
            setCount = ph + pm
            print("\n---------- [ ---- ] ----------\n")
        }
        
        calTime = setCount - cTime
        timeRemaining = calTime
        self.progresssView.value = CGFloat(timeRemaining)
        self.progresssView.maxValue = CGFloat(timeRemaining)
        
        //------------------------------------------------------
        let content = UNMutableNotificationContent() // 노티피케이션 메세지 객체
        content.title = NSString.localizedUserNotificationString(forKey: "알림!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "\(h):\(m) 입니다!", arguments: nil)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(timeRemaining), repeats: false) // 얼마 후 실행?
        
        let request = UNNotificationRequest(
            identifier: "LocalNotification",
            content: content,
            trigger: trigger
        ) // 노티피케이션 전송 객체
        
        let center = UNUserNotificationCenter.current() // 노티피케이션 센터
        center.add(request) { (error : Error?) in // 노티피케이션 객체 추가 -> 전송
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
        //----------------------------------------------------
        
        if calTime >= 3600 {
            countH = calTime / 3600
            calTime = calTime - (countH * 3600)
        }
        if calTime >= 60 {
            countM = calTime / 60
            calTime = calTime - (countM * 60)
        }
        countS = calTime
        print("설정시간(초) : " , setCount)
        print("현재시간(초) : " , cTime)
        print("남은시간(초) : " , timeRemaining)
        print("남은시간 : ", countH, countM, countS)
        
        if !timerIsOn {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerRunning), userInfo: nil, repeats: true)
            timerIsOn = true
        }
    }
    
    // 타이머
    @objc func timerRunning() {
        if timeRemaining == 0 {
            timerIsOn = false
            print("vibrate")
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            
        } else {
            timeRemaining -= 1
            self.progresssView.value -= 1
            let hourLeft = Int(timeRemaining) / 3600
            let minutesLeft = Int(timeRemaining) / 60 % 60
            let secondsLeft = Int(timeRemaining) % 60
            timeLabel.text = "\(hourLeft):\(minutesLeft):\(secondsLeft)"
            isOnBreak = true
        }
    }
}
