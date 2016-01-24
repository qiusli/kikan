//
//  ViewController.swift
//  Kikan
//
//  Created by Qiushi Li on 1/24/16.
//  Copyright © 2016 gs. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    @IBOutlet weak var timeLabel: UILabel!
    
    var hourSlider: EFCircularSlider!
//    var minuteSlider: EFCircularSlider

    required init?(coder aDecoder: NSCoder) {
        let hourSliderFrame = CGRectMake(55, 220, 210, 210)
        hourSlider = EFCircularSlider(frame: hourSliderFrame)
        
        super.init(coder: aDecoder)
        hourSlider.unfilledColor = UIColor(red: 23/255.0, green: 47/255, blue: 70/255, alpha: 1.0)
        let markingLabels = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
        hourSlider.innerMarkingLabels = markingLabels
        hourSlider.labelFont = UIFont.systemFontOfSize(20)
        hourSlider.lineWidth = 12
        hourSlider.snapToLabels = false
        hourSlider.minimumValue = 0
        hourSlider.maximumValue = 12
        hourSlider.labelColor = UIColor(red: 127/255.0, green: 229/255.0, blue: 255/255.0, alpha: 1.0)
        hourSlider.handleType = CircularSliderHandleTypeBigCircle
        hourSlider.handleColor = hourSlider.filledColor
        hourSlider.addTarget(self, action: "hourDidChange:", forControlEvents: .ValueChanged)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(hourSlider)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hourDidChange(slider: EFCircularSlider) {
        let newVal = Int(slider.currentValue) != 0 ? Int(slider.currentValue) : 12
        let oldTime: NSString = timeLabel.text!
        let colonRange: NSRange = oldTime.rangeOfString(":")
        timeLabel!.text = "\(newVal):\(oldTime.substringFromIndex(colonRange.location+1))"
    }
}
