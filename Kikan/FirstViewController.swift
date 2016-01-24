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

    var minuteSlider: EFCircularSlider!
    var secondSlider: EFCircularSlider!

    required init?(coder aDecoder: NSCoder) {
        let minuteSliderFrame = CGRectMake(5, 170, 310, 310)
        minuteSlider = EFCircularSlider(frame: minuteSliderFrame)
        let hourSliderFrame = CGRectMake(55, 220, 210, 210)
        secondSlider = EFCircularSlider(frame: hourSliderFrame)

        super.init(coder: aDecoder)
        
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
//        secondSlider.snapToLabels = true
        secondSlider.minimumValue = 0
        secondSlider.maximumValue = 60
        secondSlider.labelColor = UIColor(red: 127/255.0, green: 229/255.0, blue: 255/255.0, alpha: 1.0)
        secondSlider.handleType = CircularSliderHandleTypeBigCircle
        secondSlider.handleColor = secondSlider.filledColor
        secondSlider.addTarget(self, action: "secondDidChange:", forControlEvents: .ValueChanged)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 31/255.0, green: 61/255.0, blue: 91/255.0, alpha: 1.0)
        minuteSlider.center = view.center
        secondSlider.center = view.center
        view.addSubview(minuteSlider)
        view.addSubview(secondSlider)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func minuteDidChange(slider: EFCircularSlider) {
        let newVal = Int(slider.currentValue) < 60 ? Int(slider.currentValue) : 0
        let newValString = newVal < 10 ? "0" + String(newVal) : String(newVal)
        let oldTime: NSString = timeLabel.text!
        let colonRange: NSRange = oldTime.rangeOfString(":")
        timeLabel!.text = "\(newValString):\(oldTime.substringFromIndex(colonRange.location + 1))"
    }
    
    func secondDidChange(slider: EFCircularSlider) {
        let newVal = Int(slider.currentValue) < 60 ? Int(slider.currentValue) : 0
        let newValString = newVal < 10 ? "0" + String(newVal) : String(newVal)
        let oldTime: NSString = timeLabel.text!
        let colonRange: NSRange = oldTime.rangeOfString(":")
        timeLabel!.text = "\(oldTime.substringToIndex(colonRange.location)):\(newValString)"
    }
}
