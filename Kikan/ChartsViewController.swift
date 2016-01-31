//
//  CharViewController.swift
//  Kikan
//
//  Created by Qiushi Li on 1/28/16.
//  Copyright © 2016 gs. All rights reserved.
//

import UIKit
import PNChart
import Foundation

class ChartsViewController: UITableViewController {
    var dataModel: DataModel?
    var monthStrRep = ["Jan.", "Feb.", "Mar.", "Apr.", "May.", "June.", "July.", "Aug.", "Sept.", "Oct.", "Nov.", "Dec."]
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("chartsCell", forIndexPath: indexPath)
        if indexPath.row == 2 {
            cell.contentView.addSubview(configureBarChart())
        } else {
            cell.contentView.addSubview(configureLineChart())
            cell.backgroundColor = UIColor.redColor()
        }
        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 210
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    // from 7 days before to now currently
    func configureLineChart() -> PNLineChart {
        let lineChart = PNLineChart.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 200))
        lineChart.yLabelFormat = "%1.1f"
        lineChart.showLabel = true
        lineChart.backgroundColor = UIColor.grayColor()

        let info = configureDataAndLabel()
        lineChart.xLabels = info.dateLabels
        lineChart.showCoordinateAxis = true
        
        let data:PNLineChartData = PNLineChartData()
        data.color = UIColor.greenColor()
        data.itemCount = UInt(lineChart.xLabels.count)
        data.inflexionPointStyle = PNLineChartPointStyle.Circle
        data.getData = ({(index: UInt) -> PNLineChartDataItem in
            let yValue: CGFloat = CGFloat(info.dataArray[Int(index)])
            let item = PNLineChartDataItem(y: yValue)
            return item
        })
        lineChart.chartData = [data]
        lineChart.strokeChart()
        
        return lineChart
    }
    
    func configureBarChart() -> PNBarChart {
        
        let barChart = PNBarChart(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 200))
        barChart.barBackgroundColor = UIColor.clearColor()
        
        let info = configureDataAndLabel()
        barChart.xLabels = info.dateLabels
        barChart.yValues = info.dataArray
        barChart.strokeChart()
        return barChart
    }
    
    func configureDataAndLabel() -> (dateLabels: [String], dataArray: [Int]) {
        var dateLabels = [String]()
        var dataArray = [Int]()
        let date_times = dataModel!.date_times
        for (date, times) in date_times {
            let dayStr = date[date.endIndex.advancedBy(-2)..<date.endIndex]
            let dayInt = Int(dayStr)
            
            let monthStr = date[date.startIndex.advancedBy(4)..<date.startIndex.advancedBy(6)]
            let monthInt = Int(monthStr)
            let m = monthStrRep[monthInt! - 1]
            
            let label = "\(m)\(dayInt!)"
            dateLabels.append(label)
            dataArray.append(times)
        }
        return (dateLabels, dataArray)
    }
    
    @IBAction func done() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
