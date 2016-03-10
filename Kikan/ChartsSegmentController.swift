//
//  ChartsSegmentController.swift
//  Kikan
//
//  Created by Qiushi Li on 3/3/16.
//  Copyright © 2016 gs. All rights reserved.
//

import UIKit
import SMSegmentView
import PNChart

class ChartsSegmentController: UIViewController, SMSegmentViewDelegate {
    var segmentView: SMSegmentView!
    var alphaSegmentView: SMBasicSegmentView!
    var margin: CGFloat = 10.0
    var dataModel: DataModel?
    var charts: Charts = Charts(), circleChartObj = CircleChart()

    var barChart: UIView!, lineChart: UIView!, circleChart: UIView!
    var lineChartLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        charts.dataModel = dataModel
        circleChartObj.dataModel = dataModel
        self.view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)

        let alphaSegmentFrame = CGRect(x: self.margin, y: 600.0, width: self.view.frame.size.width - self.margin*2, height: 40.0)
        self.alphaSegmentView = SMBasicSegmentView(frame: alphaSegmentFrame)
        self.alphaSegmentView.delegate = self
        self.alphaSegmentView.segments = [
            SMAlphaImageSegment(margin: 10.0, selectedAlpha: 1.0, unselectedAlpha: 0.3, pressedAlpha: 0.65, image: UIImage(named: "clip")),
            SMAlphaImageSegment(margin: 10.0, selectedAlpha: 1.0, unselectedAlpha: 0.3, pressedAlpha: 0.65, image: UIImage(named: "bulb")),
            SMAlphaImageSegment(margin: 10.0, selectedAlpha: 1.0, unselectedAlpha: 0.3, pressedAlpha: 0.65, image: UIImage(named: "cloud"))
        ]
        self.alphaSegmentView.selectSegmentAtIndex(1)
        self.alphaSegmentView.layer.cornerRadius = 5.0
        self.alphaSegmentView.layer.borderColor = UIColor(white: 0.85, alpha: 1.0).CGColor
        self.alphaSegmentView.layer.borderWidth = 1.0
        self.alphaSegmentView.backgroundColor = UIColor.clearColor()
        
        self.view.addSubview(self.alphaSegmentView)
    }
    
    // SMSegment Delegate
    func segmentView(segmentView: SMBasicSegmentView, didSelectSegmentAtIndex index: Int) {
        switch index {
        case 0:
            if let circleChart = circleChart {
                circleChart.removeFromSuperview()
            }
            if let lineChart = lineChart {
                lineChart.removeFromSuperview()
            }
            if let lineChartLabel = lineChartLabel {
                lineChartLabel.removeFromSuperview()
            }
            
            barChart = charts.configureBarChart()
            self.view.addSubview(barChart)
            
            barChart.center = self.view.center
        case 1:
            if let barChart = barChart {
                barChart.removeFromSuperview()
            }
            
            if let circleChart = circleChart {
                circleChart.removeFromSuperview()
            }
            
            let tmp = charts.configureLineChart()
            lineChart = tmp.0
            lineChartLabel = tmp.1

            self.view.addSubview(lineChart)
            self.view.addSubview(lineChartLabel)
            
            lineChart.center = self.view.center
        default:
            if let barChart = barChart {
                barChart.removeFromSuperview()
            }
            if let lineChart = lineChart {
                lineChart.removeFromSuperview()
            }
            if let lineChartLabel = lineChartLabel {
                lineChartLabel.removeFromSuperview()
            }
            
            circleChart = circleChartObj.configureCircleChart()
            self.view.addSubview(circleChart)
            circleChart.center = self.view.center
        }
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        /*
        MARK: Replace the following line to your own frame setting for segmentView.
        */
        if toInterfaceOrientation == UIInterfaceOrientation.LandscapeLeft || toInterfaceOrientation == UIInterfaceOrientation.LandscapeRight {
            self.segmentView.vertical = true
            self.segmentView.segmentVerticalMargin = 25.0
            self.segmentView.frame = CGRect(x: self.view.frame.size.width/2 - 40.0, y: 100.0, width: 80.0, height: 220.0)
            
            self.alphaSegmentView.vertical = true
            self.alphaSegmentView.frame = CGRect(x:  self.view.frame.size.width/2 + 60.0, y: 100.0, width: 80 , height: 220.0)
            
        }
        else {
            self.segmentView.vertical = false
            self.segmentView.segmentVerticalMargin = 10.0
            self.segmentView.frame = CGRect(x: self.margin, y: 120.0, width: self.view.frame.size.width - self.margin*2, height: 40.0)
            
            self.alphaSegmentView.vertical = false
            self.alphaSegmentView.frame = CGRect(x: self.margin, y: 200.0, width: self.view.frame.size.width - self.margin*2, height: 40.0)
            
        }
    }
}
