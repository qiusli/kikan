//
//  SettingsViewController.swift
//  Kikan
//
//  Created by Qiushi Li on 1/25/16.
//  Copyright © 2016 gs. All rights reserved.
//

import UIKit
import AVFoundation

protocol SettingsViewControllerDelegate: class {
    func settingsViewController(controller: SettingsViewController, didFinishPickingTickSound sound: String)
}

class SettingsViewController: UITableViewController, KkListActionSheetDelegate {
    var kkListActionSheet: KkListActionSheet?
    var tickSounds: [String]!
    var alarmSounds: [String]!
    var audioPlayer: AVAudioPlayer!
    var tickSoundPicked: String!
    var alarmSoundPicked: String!
    
    weak var delegate: FirstViewController?
    
    var selectedSection: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        kkListActionSheet = KkListActionSheet.createInit(self)
        kkListActionSheet?.delegate = self
        tickSounds = ["grandfather", "rollo", "mantel", "mechanical", "mono"]
        alarmSounds = ["120bpm", "rsilveira", "alwegs", "sangtao", "fredemo", "rewind"]
    }
    
    @IBAction func done() {
        delegate?.settingsViewController(self, didFinishPickingTickSound: tickSoundPicked)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedSection = indexPath.section
        kkListActionSheet?.kkTableView.reloadData()
        kkListActionSheet?.showHide()
    }
    
    // MARK: KkListActionSheet Delegate Method
    func kkTableView(tableView: UITableView, rowsInSection section: NSInteger) -> NSInteger {
        var row: Int!
        switch selectedSection {
        case 0:
            row = tickSounds!.count
        default:
            row = alarmSounds!.count
        }
        return row
    }
    
    func kkTableView(tableView: UITableView, currentIndx indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdenfier = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdenfier)
        
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdenfier)
        }
        
        switch selectedSection {
        case 0:
            cell?.textLabel?.text = tickSounds![indexPath.row]
        default:
            cell?.textLabel?.text = alarmSounds![indexPath.row]
        }
        
        return cell!
    }
    
    func kkTableView(tableView: UITableView, selectIndex indexPath: NSIndexPath) {
        if selectedSection == 0 {
            tickSoundPicked = tickSounds[indexPath.row]
            audioPlayer = generateAudioPlayerWithName(tickSoundPicked)
        } else if selectedSection == 1 {
            alarmSoundPicked = alarmSounds[indexPath.row]
            audioPlayer = generateAudioPlayerWithName(alarmSoundPicked)
        }
        
        audioPlayer.play()
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
