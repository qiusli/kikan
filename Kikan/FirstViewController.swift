//
//  ViewController.swift
//  Kikan
//
//  Created by Qiushi Li on 1/24/16.
//  Copyright © 2016 gs. All rights reserved.
//

import UIKit
import AVFoundation
import AHKActionSheet
import STZPopupView
import AKPickerView_Swift

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,
        SettingsViewControllerDelegate, YALContextMenuTableViewDelegate, AKPickerViewDataSource, AKPickerViewDelegate {
    var dataModel: DataModel!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var tagButton: UIButton!
    

    @IBOutlet weak var pickerView: AKPickerView!

    var minute = 0, second = 0
    var timer = NSTimer()
    
    var menuTitles = [String]()
    var menuIcons = [UIImage]()
    var contextMenuTableView: YALContextMenuTableView!
    let menuCellIdentifier = "rotationCell"
    
    var audioPlayer: AVAudioPlayer?
    var text: String?
    
    let timeOptions = ["1", "5", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55", "60"]
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initiateMenuOptions()
        navigationController?.setValue(YALNavigationBar(), forKeyPath: "navigationBar")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stopButton.userInteractionEnabled = false
        view.backgroundColor = UIColor(red: 31/255.0, green: 61/255.0, blue: 91/255.0, alpha: 1.0)
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        self.pickerView.font = UIFont(name: "HelveticaNeue-Light", size: 20)!
        self.pickerView.highlightedFont = UIFont(name: "HelveticaNeue", size: 20)!
        self.pickerView.pickerViewStyle = .Wheel
        self.pickerView.maskDisabled = false
        self.pickerView.reloadData()
    }
    
    @IBAction func start(sender: UIButton) {
        if timeLabel.text != "00:00" {
            let audioPlayer = configureAudioPlayerWithName(dataModel.userSelections.tickSound, andType: "wav")
            audioPlayer.play()
            
            stopButton.userInteractionEnabled = true
            
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "subtractTime:", userInfo: audioPlayer, repeats: true)
        }
    }
    
    @IBAction func showActionSheet(sender: UIButton) {
        configureActionSheetCells()
    }
    
    @IBAction func stop(sender: UIButton) {
        timer.invalidate()
        audioPlayer?.stop()
        timeLabel.text = "00:00"
        dataModel.addImcompleteUseDates(NSDate())
    }
    
    // TODO: delete tag
    func configureActionSheetCells() {
        let actionSheet = AHKActionSheet(title: "Category")
        let tags = dataModel.userSelections.tags
        for tg in tags {
            actionSheet!.addButtonWithTitle(tg, type: .Default, handler: {
                _ in
                self.tagButton.setTitle(tg, forState: .Normal)
            })
        }
        actionSheet!.addButtonWithTitle("Add More Tags", type: .Destructive, handler: {
            _ in
            self.createPopupview()
        })
        actionSheet!.show()
    }
    
    func createPopupview() {
        let popupView = UIView(frame: CGRectMake(0, 0, 200, 160))
        popupView.backgroundColor = UIColor.whiteColor()
        
        let textField = UITextField(frame: CGRect(x: 50, y: 50, width: 100, height: 50))
        textField.borderStyle = .RoundedRect
        textField.backgroundColor = UIColor.grayColor()
        textField.delegate = self
        popupView.addSubview(textField)
        
        // Close button
        let button = UIButton(type: .System)
        button.frame = CGRectMake(100, 100, 80, 40)
        button.setTitle("Save", forState: UIControlState.Normal)
        button.addTarget(self, action: "touchAdd", forControlEvents: UIControlEvents.TouchUpInside)
        popupView.addSubview(button)
        
        presentPopupView(popupView)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = textField.text!
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        text = newText as String
        return true
    }
    
    func touchAdd() {
        if let text = text {
            dataModel.userSelections.tags.append(text)
        }
        dismissPopupView()
        configureActionSheetCells()
    }
    
    func subtractTime(timer: NSTimer) {
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
            if minute > 0 {
                minute--
                second = 59
            }
        } else {
            second--
        }
        
        let minuteString = minute < 10 ? "0" + String(minute) : String(minute)
        let secondString = second < 10 ? "0" + String(second) : String(second)
        timeLabel.text = "\(minuteString):\(secondString)"
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
    
    func initiateMenuOptions() {
        menuTitles = ["Settings", "Charts", "Like profile"]
        menuIcons = [UIImage(named: "Appointments")!, UIImage(named: "Appointments")!, UIImage(named: "Appointments")!]
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
    
    func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
        return self.timeOptions.count
    }
    
    func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String {
        return self.timeOptions[item]
    }
    
    func pickerView(pickerView: AKPickerView, configureLabel label: UILabel, forItem item: Int) {
        label.textColor = UIColor.lightGrayColor()
        label.highlightedTextColor = UIColor.whiteColor()
        label.backgroundColor = UIColor(
            hue: CGFloat(item) / CGFloat(self.timeOptions.count),
            saturation: 1.0,
            brightness: 0.5,
            alpha: 1.0)
    }
    
    func pickerView(pickerView: AKPickerView, marginForItem item: Int) -> CGSize {
        return CGSizeMake(40, 20)
    }
    
    func pickerView(pickerView: AKPickerView, didSelectItem item: Int) {
        minute = Int(self.timeOptions[item])!
        second = 0
        let minuteString = minute < 10 ? "0" + String(minute) : String(minute)
        let secondString = second < 10 ? "0" + String(second) : String(second)
        timeLabel.text = "\(minuteString):\(secondString)"
    }
}
