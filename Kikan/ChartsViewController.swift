//
//  CharViewController.swift
//  Kikan
//
//  Created by Qiushi Li on 1/28/16.
//  Copyright © 2016 gs. All rights reserved.
//

import UIKit
//import PNChart
import PNChartSwift
import Foundation

public let PNGreenColor = UIColor(red: 77.0 / 255.0 , green: 196.0 / 255.0, blue: 122.0 / 255.0, alpha: 1.0)
public let PNGreyColor = UIColor(red: 186.0 / 255.0 , green: 186.0 / 255.0, blue: 186.0 / 255.0, alpha: 1.0)
public let PNLightGreyColor = UIColor(red: 246.0 / 255.0 , green: 246.0 / 255.0, blue: 246.0 / 255.0, alpha: 1.0)

class ChartsViewController: UITableViewController, PNChartDelegate {
    var dataModel: DataModel?
    var monthStrRep = ["Jan.", "Feb.", "Mar.", "Apr.", "May.", "June.", "July.", "Aug.", "Sept.", "Oct.", "Nov.", "Dec."]
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("chartsCell", forIndexPath: indexPath)
        if indexPath.row == 1 {
//            cell.contentView.addSubview(configureCircleChart())
        } else if indexPath.row == 2 {
            cell.contentView.addSubview(configureBarChart())
        } else {
            cell.contentView.addSubview(configureLineChart().0)
            cell.contentView.addSubview(configureLineChart().1)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 250
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func configureLineChart() -> (PNLineChart , UILabel) {
        let ChartLabel:UILabel = UILabel(frame: CGRectMake(0, 90, 320.0, 30))
        ChartLabel.textColor = PNGreenColor
        ChartLabel.font = UIFont(name: "Avenir-Medium", size:23.0)
        ChartLabel.textAlignment = NSTextAlignment.Center
        
        //Add LineChart
        ChartLabel.text = "Line Chart"
            
        let lineChart:PNLineChart = PNLineChart(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 200))
        lineChart.yLabelFormat = "%1.1f"
        lineChart.showLabel = true
        lineChart.backgroundColor = UIColor.clearColor()
        let info = configureDataAndLabel()
        lineChart.xLabels = info.dateLabels
        lineChart.showCoordinateAxis = true
        
        // for complete tasks
        let data01:PNLineChartData = PNLineChartData()
        data01.color = PNGreenColor
        data01.itemCount = lineChart.xLabels.count
        data01.inflexionPointStyle = PNLineChartData.PNLineChartPointStyle.PNLineChartPointStyleCycle
        data01.getData = ({(index: Int) -> PNLineChartDataItem in
            let yValue:CGFloat = CGFloat(info.dataArray[index])
            let item = PNLineChartDataItem(y: yValue)
            return item
        })
        
        // for imcomplete tasks
        let data02:PNLineChartData = PNLineChartData()
        data02.color = PNGreyColor
        data02.itemCount = lineChart.xLabels.count
        data02.inflexionPointStyle = PNLineChartData.PNLineChartPointStyle.PNLineChartPointStyleCycle
        data02.getData = ({(index: Int) -> PNLineChartDataItem in
            let yValue:CGFloat = CGFloat(info.incompleteDataArray[index])
            let item = PNLineChartDataItem(y: yValue)
            return item
        })
        
        lineChart.chartData = [data01, data02]
        lineChart.strokeChart()
        
        return (lineChart, ChartLabel)
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
    
//    func configureCircleChart() -> PNCircleChart {
//        let info = configureDataAndLabel()
//        var totalSucceed = 0, totalFailed = 0
//        for (succeed, failed) in zip(info.dataArray, info.incompleteDataArray) {
//            totalSucceed += succeed
//            totalFailed += failed
//        }
//        
//        let circleChart = PNCircleChart(frame: CGRectMake(0, 80, UIScreen.mainScreen().bounds.size.width, 100), total: totalSucceed + totalFailed, current: totalSucceed, clockwise: false, shadow: true, shadowColor: UIColor.greenColor())
//        circleChart.strokeChart()
//        return circleChart
//    }
    
    func configureDataAndLabel() -> (dateLabels: [String], dataArray: [Int], incompleteDataArray: [Int]) {
        var dateLabels = [String]()
        var dataArray = [Int](), incompleteDataArray = [Int]()
        let date_times = dataModel!.date_times, incomplete_date_times = dataModel!.incomplete_date_times
        for (date, times) in date_times {
            let dayStr = date[date.endIndex.advancedBy(-2)..<date.endIndex]
            let dayInt = Int(dayStr)
            
            let monthStr = date[date.startIndex.advancedBy(4)..<date.startIndex.advancedBy(6)]
            let monthInt = Int(monthStr)
            let m = monthStrRep[monthInt! - 1]
            
            let label = "\(m)\(dayInt!)"
            dateLabels.append(label)
            dataArray.append(times)
            
            if incomplete_date_times[date] != nil {
                incompleteDataArray.append(incomplete_date_times[date]!)
            } else {
                incompleteDataArray.append(0)
            }
        }

        return (dateLabels, dataArray, incompleteDataArray)
    }
    
    @IBAction func done() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func userClickedOnLineKeyPoint(point: CGPoint, lineIndex: Int, keyPointIndex: Int)
    {
        print("Click Key on line \(point.x), \(point.y) line index is \(lineIndex) and point index is \(keyPointIndex)")
    }
    
    func userClickedOnLinePoint(point: CGPoint, lineIndex: Int)
    {
        print("Click Key on line \(point.x), \(point.y) line index is \(lineIndex)")
    }
    
    func userClickedOnBarChartIndex(barIndex: Int)
    {
        print("Click  on bar \(barIndex)")
    }
}
