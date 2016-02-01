//
//  ViewController.swift
//  Kikan
//
//  Created by Qiushi Li on 1/24/16.
//  Copyright © 2016 gs. All rights reserved.
//

import UIKit
import AVFoundation

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SettingsViewControllerDelegate, YALContextMenuTableViewDelegate {
    var dataModel: DataModel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startButton: UIButton!

    var minuteSlider: EFCircularSlider!
    var secondSlider: EFCircularSlider!

    var minute = 0, second = 0
    var timer = NSTimer()
    
    var menuTitles = [String]()
    var menuIcons = [UIImage]()
    var contextMenuTableView: YALContextMenuTableView!
    let menuCellIdentifier = "rotationCell"
    
    var audioPlayer: AVAudioPlayer?
    
    required init?(coder aDecoder: NSCoder) {
        let minuteSliderFrame = CGRectMake(5, 170, 310, 310)
        minuteSlider = EFCircularSlider(frame: minuteSliderFrame)
        let hourSliderFrame = CGRectMake(55, 220, 210, 210)
        secondSlider = EFCircularSlider(frame: hourSliderFrame)

        super.init(coder: aDecoder)
        
        initiateMenuOptions()
        navigationController?.setValue(YALNavigationBar(), forKeyPath: "navigationBar")
        
        minuteSlider.unfilledColor = UIColor(red: 23/255.0, green: 47/255, blue: 70/255, alpha: 1.0)
        minuteSlider.filledColor = UIColor(red: 155/255.0, green: 211/255.0, blue: 156/255.0, alpha: 1.0)
        let minuteMarkingLabels = ["5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55", "60"]
        minuteSlider.innerMarkingLabels = minuteMarkingLabels
        minuteSlider.labelFont = UIFont.systemFontOfSize(14)
        minuteSlider.lineWidth = 8
        minuteSlider.minimumValue = 0
        minuteSlider.maximumValue = 60
        minuteSlider.labelColor = UIColor(red: 76/255.0, green: 111/255.0, blue: 137/255.0, alpha: 1.0)
        minuteSlider.handleType = CircularSliderHandleTypeDoubleCircleWithOpenCenter
        minuteSlider.handleColor = minuteSlider.filledColor
        minuteSlider.addTarget(self, action: "minuteDidChange:", forControlEvents: .ValueChanged)
        
        secondSlider.unfilledColor = UIColor(red: 23/255.0, green: 47/255, blue: 70/255, alpha: 1.0)
        secondSlider.filledColor = UIColor(red: 98/255.0, green: 243/255.0, blue: 252/255.0, alpha: 1.0)
        let hourMarkingLabels = ["5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55", "60"]
        secondSlider.innerMarkingLabels = hourMarkingLabels
        secondSlider.labelFont = UIFont.systemFontOfSize(14)
        secondSlider.lineWidth = 12
        secondSlider.minimumValue = 0
        secondSlider.maximumValue = 60
        secondSlider.labelColor = UIColor(red: 127/255.0, green: 229/255.0, blue: 255/255.0, alpha: 1.0)
        secondSlider.handleType = CircularSliderHandleTypeBigCircle
        secondSlider.handleColor = secondSlider.filledColor
        secondSlider.addTarget(self, action: "secondDidChange:", forControlEvents: .ValueChanged)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stopButton.userInteractionEnabled = false
        view.backgroundColor = UIColor(red: 31/255.0, green: 61/255.0, blue: 91/255.0, alpha: 1.0)
        minuteSlider.center = view.center
        secondSlider.center = view.center
        view.addSubview(minuteSlider)
        view.addSubview(secondSlider)
    }
    
    @IBAction func start(sender: UIButton) {
        if timeLabel.text != "00:00" {
            let audioPlayer = configureAudioPlayerWithName(dataModel.userSelections.tickSound, andType: "wav")
            audioPlayer.play()
            
            stopButton.userInteractionEnabled = true
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "subtractTime:", userInfo: audioPlayer, repeats: true)
        }
    }
    
    @IBAction func stop(sender: UIButton) {
        timer.invalidate()
        audioPlayer?.stop()
        timeLabel.text = "00:00"
        dataModel.addImcompleteUseDates(NSDate())
    }
    
    func subtractTime(timer: NSTimer) {
        second--
        
        let minuteString = minute < 10 ? "0" + String(minute) : String(minute)
        let secondString = second < 10 ? "0" + String(second) : String(second)
        timeLabel.text = "\(minuteString):\(secondString)"
        
        if minute <= 0 && second <= 0 {
            let tickAudioPlayer = timer.userInfo as! AVAudioPlayer
            timer.invalidate()
            tickAudioPlayer.stop()
            stopButton.userInteractionEnabled = false
            // only naturally completed task can be considered as 'finished'
            dataModel.addUseDates(NSDate())
            
            configureAudioPlayerWithName(dataModel.userSelections.alarmSound, andType: "wav")
            let alert = UIAlertController(title: "Time is up!", message: "Enjoy your break!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
                _ in
                self.audioPlayer!.stop()
            }))
            presentViewController(alert, animated: true, completion:nil)
            audioPlayer!.play()
        }
        
        if second == 0 {
            second = 59
            if minute > 0 {
                minute--
            }
        }
    }
    
    func configureAudioPlayerWithName(name: String, andType type: String) -> AVAudioPlayer {
        let soundURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(name, ofType: type)!)
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: soundURL)
            audioPlayer!.numberOfLoops = -1
            return audioPlayer!
        } catch {
            fatalError("\(error)")
        }
    }
    
    func minuteDidChange(slider: EFCircularSlider) {
        let newVal = Int(slider.currentValue) < 60 ? Int(slider.currentValue) : 0
        minute = newVal
        let newValString = newVal < 10 ? "0" + String(newVal) : String(newVal)
        let oldTime: NSString = timeLabel.text!
        let colonRange: NSRange = oldTime.rangeOfString(":")
        timeLabel!.text = "\(newValString):\(oldTime.substringFromIndex(colonRange.location + 1))"
    }
    
    func secondDidChange(slider: EFCircularSlider) {
        let newVal = Int(slider.currentValue) < 60 ? Int(slider.currentValue) : 0
        second = newVal
        let newValString = newVal < 10 ? "0" + String(newVal) : String(newVal)
        let oldTime: NSString = timeLabel.text!
        let colonRange: NSRange = oldTime.rangeOfString(":")
        timeLabel!.text = "\(oldTime.substringToIndex(colonRange.location)):\(newValString)"
    }
    
    func initiateMenuOptions() {
        menuTitles = ["Settings", "Charts", "Like profile"]
        menuIcons = [UIImage(named: "icn_4")!, UIImage(named: "icn_4")!, UIImage(named: "icn_4")!]
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        contextMenuTableView.reloadData()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        coordinator.animateAlongsideTransition(nil, completion: {
            _ in
            self.contextMenuTableView.reloadData()
        })
        contextMenuTableView.updateAlongsideRotation()
    }
    
    @IBAction func presentMenuButtonTapped(sender: UIBarButtonItem) {
        if contextMenuTableView == nil  {
            contextMenuTableView = YALContextMenuTableView.init(tableViewDelegateDataSource: self)
            contextMenuTableView.animationDuration = 0.15
            contextMenuTableView.yalDelegate = self
            contextMenuTableView.menuItemsSide = .Right
            contextMenuTableView.menuItemsAppearanceDirection = .FromTopToBottom
            
            let cellNib = UINib(nibName: "ContextMenuCell", bundle: nil)
            contextMenuTableView.registerNib(cellNib, forCellReuseIdentifier: menuCellIdentifier)
        }
        contextMenuTableView.showInView(self.navigationController!.view, withEdgeInsets: UIEdgeInsetsZero, animated: true)
    }
    
    func contextMenuTableView(contextMenuTableView: YALContextMenuTableView!, didDismissWithIndexPath indexPath: NSIndexPath!) {
        if indexPath.row == 0 {
            let settingsViewController = storyboard?.instantiateViewControllerWithIdentifier("settingsViewController") as! SettingsViewController
            settingsViewController.delegate = self
            settingsViewController.tickSoundPicked = dataModel.userSelections.tickSound
            settingsViewController.alarmSoundPicked = dataModel.userSelections.alarmSound
            let navigationController = UINavigationController(rootViewController: settingsViewController)
            presentViewController(navigationController, animated: true, completion: nil)
        } else if indexPath.row == 1 {
            let chartsViewController = storyboard?.instantiateViewControllerWithIdentifier("chartsViewController") as! ChartsViewController
            chartsViewController.dataModel = dataModel
            let navigationController = UINavigationController(rootViewController: chartsViewController)
            presentViewController(navigationController, animated: true, completion: nil)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let yalTableView = tableView as! YALContextMenuTableView
        yalTableView.dismisWithIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(menuCellIdentifier, forIndexPath: indexPath) as? ContextMenuCell
        if let cell = cell {
            cell.backgroundColor = UIColor.clearColor()
            cell.menuTitleLabel.text = menuTitles[indexPath.row]
            cell.menuImageView.image = menuIcons[indexPath.row]
        }
        return cell!
    }
    
    func settingsViewController(controller: SettingsViewController, didFinishPickingTickSound tickSound: String, andAlarmSound alarmSound: String) {
        dataModel.userSelections.tickSound = tickSound
        dataModel.userSelections.alarmSound = alarmSound
        dismissViewControllerAnimated(true, completion: nil)
    }
}
