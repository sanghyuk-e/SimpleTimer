//
//  ViewController.swift
//  SimpleTimer
//
//  Created by sanghyuk on 03/01/2019.
//  Copyright © 2019 sanghyuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var timer = Timer()
    var timerIsOn = false
    var timeRemaining = 0
    var isOnBreak = false
    
    var timeToken = false
    var calTime = 0
    
    // 설정시간
    var setTime: String = ""
    var h:Int = 0
    var m:Int = 0
    var s:Int = 0
    
    var countH: Int = 0
    var countM: Int = 0
    var countS: Int = 0
    var onlyTime: String = ""
    
    var ampm:String = ""
    
    let date = Date()
    let calendar = Calendar.current
    var hour: Int = 0
    var minutes: Int = 0
    var second: Int = 0
    
    
    var currentTime: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        print("\n---------- [ view 1 start ] ----------\n")
        button1.layer.cornerRadius = 25
        button1.layer.borderWidth = 1
        button1.layer.borderColor = UIColor.clear.cgColor
    }
    override func viewWillAppear(_ animated: Bool) {
        print("\n---------- [ will appear ] ----------\n")
        refreshTime()
        timerIsOn = false
        
    }
    
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var button1: UIButton!
    @IBOutlet private weak var remainTimeLabel: UILabel!
    
    @IBAction private func datePickerChanged(_ sender: Any) {
        timeToken = true
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.none
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        let strDate = dateFormatter.string(from: datePicker.date)
        timeLabel.text = strDate + " 에 알람"
        setTime = dateFormatter.string(from: datePicker.date)

        
        // 미래시간 - 현재시간 = 카운트
        // AM/PM 구분
        let index = setTime.components(separatedBy: " ")
        onlyTime = index[0]
        ampm = index[1]
        print(onlyTime)
        print(ampm)

        // 시 분 초 구분
        var times = onlyTime.components(separatedBy: ":")
        h = Int(times[0])!
        m = Int(times[1])!
        //        s = Int(times[2])!
        
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
        if calTime >= 3600 {
            countH = calTime / 3600
            calTime = calTime - (countH * 3600)
        }
        if calTime >= 60 {
            countM = calTime / 60
            calTime = calTime - (countM * 60)
        }
        countS = calTime
    
        print("h" , countH)
        print("m" , countM)
        print("s" , countS)
        remainTimeLabel.text = String(countH) + ":" +  String(countM) + ":" + String(countS) + " 남았습니다."

        print("ampm : " + ampm)
        print("설정시간 : " + onlyTime)
        print("현재시간 : " + currentTime)
        print("\n---------- [ view 1 end ] ----------\n")
    }
    
    @IBOutlet private weak var timeLabel: UILabel!
    
    @IBAction private func startButton(_ sender: Any) {
        print(timeToken)
        let alert = UIAlertController(title: "시간을 지정", message: "현재시간 이후의 시간으로 지정해야합니다.", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler : nil)
        alert.addAction(okAction)
        
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
        
        if timeToken == false {
            present(alert, animated: true, completion: nil)
            refreshTime()
        } else if setCount < cTime {
            present(alert, animated: true, completion: nil)
            refreshTime()
        } else {
            guard let tvc = self.storyboard?.instantiateViewController(withIdentifier: "TVC") as? TimerViewController else {
                return
            }

            tvc.setTime = self.setTime
            tvc.onlyTime = self.onlyTime
            tvc.ampm = self.ampm
            tvc.h = self.h
            tvc.m = self.m
            
            self.present(tvc, animated: true)
        }

    }
    
    @IBAction private func resetButton(_ sender: Any) {
        refreshTime()
    }
    
    @objc func refreshTime() {
        print("call refresh Func")
        datePicker.reloadInputViews()
        timeToken = false
        timeLabel.text = "00:00"
        remainTimeLabel.text = "00:00:00 남았습니다."
        let currentDate = Date()
        hour = self.calendar.component(.hour, from: date)
        minutes = self.calendar.component(.minute, from: date)
        second = self.calendar.component(.second, from: date)
        currentTime = String(hour) + ":" + String(minutes) + ":" + String(second)
        datePicker.setDate(currentDate, animated: true)
    }
}

