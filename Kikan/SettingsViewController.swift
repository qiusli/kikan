//
//  SettingsViewController.swift
//  Kikan
//
//  Created by Qiushi Li on 1/25/16.
//  Copyright © 2016 gs. All rights reserved.
//

import UIKit
import AVFoundation
import AHKActionSheet

protocol SettingsViewControllerDelegate: class {
    func settingsViewController(controller: SettingsViewController, didFinishPickingTickSound tickSound: String, andAlarmSound alarmSound: String)
}

class SettingsViewController: UITableViewController {
    var tickSounds: [String]!
    var alarmSounds: [String]!
    var audioPlayer: AVAudioPlayer!
    var tickSoundPicked: String!
    var alarmSoundPicked: String!
    
    weak var delegate: FirstViewController?
    
    var selectedSection: Int = 0
    
    override func viewDidLoad() {
        tickSounds = ["grandfather", "rollo", "mantel", "mechanical", "mono"]
        alarmSounds = ["120bpm", "rsilveira", "alwegs", "sangtao", "fredemo", "rewind"]
        super.viewDidLoad()
    }
    
    @IBAction func done() {
        delegate?.settingsViewController(self, didFinishPickingTickSound: tickSoundPicked, andAlarmSound: alarmSoundPicked)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedSection = indexPath.section
        
        let actionSheet = AHKActionSheet(title: "Category")
        if indexPath.section == 0 {
            for tick in tickSounds {
                actionSheet!.addButtonWithTitle(tick, type: .Default, handler: {
                    _ in
                    self.tickSoundPicked = tick
                    self.audioPlayer = self.generateAudioPlayerWithName(tick)
                    self.audioPlayer.play()
                })
            }
        } else {
            for alarm in alarmSounds {
                actionSheet!.addButtonWithTitle(alarm, type: .Default, handler: {
                    _ in
                    self.alarmSoundPicked = alarm
                    self.audioPlayer = self.generateAudioPlayerWithName(alarm)
                    self.audioPlayer.play()
                })
            }
        }
        actionSheet!.show()
    }
    
    func generateAudioPlayerWithName(name: String) -> AVAudioPlayer {
        let soundURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(name, ofType: "wav")!)
        var audioPlayer: AVAudioPlayer
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: soundURL)
            audioPlayer.numberOfLoops = -1
            return audioPlayer
        } catch {
            fatalError("\(error)")
        }
    }
}
