//
//  SettingsViewController.swift
//  Kikan
//
//  Created by Qiushi Li on 1/25/16.
//  Copyright © 2016 gs. All rights reserved.
//

import UIKit
import AVFoundation

class SettingsViewController: UITableViewController, KkListActionSheetDelegate {
    var kkListActionSheet: KkListActionSheet?
    var tickSounds: [String]!
    var audioPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        kkListActionSheet = KkListActionSheet.createInit(self)
        kkListActionSheet?.delegate = self
        tickSounds = ["grandfather", "rollo", "mantel", "mechanical", "mono"]
    }
    
    @IBAction func done() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        kkListActionSheet?.showHide()
    }
    
    // MARK: KkListActionSheet Delegate Method
    func kkTableView(tableView: UITableView, rowsInSection section: NSInteger) -> NSInteger {
        return tickSounds!.count
    }
    
    func kkTableView(tableView: UITableView, currentIndx indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdenfier = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdenfier)
        
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdenfier)
        }
        
        cell?.textLabel?.text = tickSounds![indexPath.row]
        
        return cell!
    }
    
    func kkTableView(tableView: UITableView, selectIndex indexPath: NSIndexPath) {
        audioPlayer = generateAudioPlayerWithName(tickSounds![indexPath.row])
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
