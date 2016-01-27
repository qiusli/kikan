//
//  SettingsViewController.swift
//  Kikan
//
//  Created by Qiushi Li on 1/25/16.
//  Copyright © 2016 gs. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController, KkListActionSheetDelegate {
    var kkListActionSheet: KkListActionSheet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        kkListActionSheet = KkListActionSheet.createInit(self)
        kkListActionSheet?.delegate = self
    }
    
    @IBAction func done() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        kkListActionSheet?.showHide()
    }
    
    // MARK: KkListActionSheet Delegate Method
    func kkTableView(tableView: UITableView, rowsInSection section: NSInteger) -> NSInteger {
        return 20
    }
    
    func kkTableView(tableView: UITableView, currentIndx indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdenfier = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdenfier)
        
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdenfier)
        }
        
        cell?.textLabel?.text = String(format: "%ld", indexPath.row)
        
        return cell!
    }
}
