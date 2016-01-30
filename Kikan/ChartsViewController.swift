//
//  CharViewController.swift
//  Kikan
//
//  Created by Qiushi Li on 1/28/16.
//  Copyright © 2016 gs. All rights reserved.
//

import UIKit
import PNChart

class ChartsViewController: UIViewController {
    override func viewDidLoad() {
        configureLineChart()
    }
    
    func configureLineChart() {
        let lineChart = PNLineChart.init(frame: CGRectMake(0, 135, UIScreen.mainScreen().bounds.size.width, 200))
        lineChart.yLabelFormat = "%1.1f"
        lineChart.showLabel = true
        lineChart.backgroundColor = UIColor.grayColor()
        lineChart.xLabels = ["SEP 1","SEP 2","SEP 3","SEP 4","SEP 5","SEP 6","SEP 7"]
        lineChart.showCoordinateAxis = true
        
        let data01Array: [CGFloat] = [60.1, 160.1, 126.4, 262.2, 186.2, 127.2, 176.2]
        let data01:PNLineChartData = PNLineChartData()
        data01.color = UIColor.greenColor()
        data01.itemCount = UInt(lineChart.xLabels.count)
        data01.inflexionPointStyle = PNLineChartPointStyle.Circle
        data01.getData = ({(index: UInt) -> PNLineChartDataItem in
            let yValue: CGFloat = CGFloat(data01Array[Int(index)])
            let item = PNLineChartDataItem(y: yValue)
            return item
        })
        lineChart.chartData = [data01]
        lineChart.strokeChart()
        
        view.addSubview(lineChart)
    }
    
    @IBAction func done() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
