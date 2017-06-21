//
//  ViewController.swift
//  SecondClock
//
//  Created by CJ on 2017/6/21.
//  Copyright 2017 CJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    static let timeInterval:Float = 0.035
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var leftBackView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightBackView: UIView!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var isLaunch:Bool = false
    fileprivate var times:[String] = []
    fileprivate var timeIntervals:[String] = []
    fileprivate var timer:Timer = Timer()
    fileprivate var counter:Float = 0.0
    fileprivate var lastCounter:Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        setupUI()
    }
    
    //点击左边按钮（计次或复位）
    @IBAction func clickLeftButton(_ sender: UIButton) {
        if !isLaunch {//复位
            
            resetTimer()
        } else {//计次
            if let timeLabelText = timeLabel.text {
                times.append(timeLabelText)
                timeIntervals.append("\(formattingTime(time: counter - lastCounter))")
                lastCounter = counter
            }
            
            tableView.reloadData()
            tableView.scrollToRow(at: IndexPath.init(row: times.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
        }
    }
    
    //点击右边按钮（启动或暂停）
    @IBAction func clickRightButton(_ sender: UIButton) {
        
        leftButton.isEnabled = true
        
        if !isLaunch {//启动
            
            timer = Timer.scheduledTimer(timeInterval: Double(ViewController.timeInterval), target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            RunLoop.current.add(timer, forMode: RunLoopMode.commonModes)
            
            isLaunch = true
            modifyButtonStatus(leftButton, title: "计次", titleColor: UIColor.white)
            modifyButtonStatus(rightButton, title: "暂停", titleColor: UIColor.red)
            rightBackView.backgroundColor = UIColor.red.withAlphaComponent(0.15)
        } else {//暂停
            
            timer.invalidate()
            
            isLaunch = false
            modifyButtonStatus(leftButton, title: "复位", titleColor: UIColor.white)
            modifyButtonStatus(rightButton, title: "启动", titleColor: UIColor.green)
            self.rightBackView.backgroundColor = UIColor.green.withAlphaComponent(0.15)
        }
    }
}

extension ViewController {
    // 刷新时间
    func updateTimer() {
        counter += ViewController.timeInterval
        
        //解决时间间隔不准确的问题
        counter = Float(String.init(format: "%.2f", counter))!
        
        timeLabel.text = formattingTime(time: counter)
    }
    
    // 格式化时间
    fileprivate func formattingTime(time:Float) -> String {
        
        var minutes: String = "\((Int)(time / 60))"
        if (Int)(time / 60) < 10 {
            minutes = "0\((Int)(time / 60))"
        }
        
        var seconds: String = String(format: "%.2f", (time.truncatingRemainder(dividingBy: 60)))
        if time.truncatingRemainder(dividingBy: 60) < 10 {
            seconds = "0" + seconds
        }
        
        return minutes + ":" + seconds
    }
    
    //复位
    fileprivate func resetTimer() {
        
        timer.invalidate()
        counter = 0.0
        lastCounter = 0.0
        leftButton.isEnabled = false
        modifyButtonStatus(leftButton, title: "计次", titleColor: UIColor.white)
        timeLabel.text = "00:00.00"
        times.removeAll()
        timeIntervals.removeAll()
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return times.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:TimeCell = TimeCell.timeCellWithTableView(tableView: tableView)
        
        cell.setData(num: "计次\(indexPath.row + 1)", time: times[indexPath.row], timeInterval: timeIntervals[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}

extension ViewController {
    fileprivate func setNavigationBar() {
        //修改状态栏颜色
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent;
        //修改导航栏背景色
        self.navigationController?.navigationBar.barTintColor =
            UIColor.black
        //修改导航栏文字颜色
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white]
    }
    // 初始化UI
    fileprivate func setupUI() {
        
        leftButton.isEnabled = false
        
        leftBackView.layer.cornerRadius = 40
        leftBackView.clipsToBounds = true
        leftBackView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        rightBackView.layer.cornerRadius = 40
        rightBackView.clipsToBounds = true
        rightBackView.backgroundColor = UIColor.green.withAlphaComponent(0.15)
        
        leftButton.setTitleColor(UIColor.white.withAlphaComponent(0.2), for: UIControlState.disabled)
    }
    
    // 修改 button 状态
    fileprivate func modifyButtonStatus(_ button: UIButton, title: String, titleColor: UIColor) {
        button.setTitle(title, for: UIControlState.normal)
        button.setTitleColor(titleColor, for: UIControlState.normal)
    }
}









