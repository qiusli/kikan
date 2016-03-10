//
//  CircleChart.swift
//  Kikan
//
//  Created by Qiushi Li on 3/9/16.
//  Copyright © 2016 gs. All rights reserved.
//

import UIKit
import PNChart

class CircleChart: NSObject, PNChartDelegate {
    var dataModel: DataModel?
    var monthStrRep = ["Jan.", "Feb.", "Mar.", "Apr.", "May.", "June.", "July.", "Aug.", "Sept.", "Oct.", "Nov.", "Dec."]
    
    func configureCircleChart() -> PNCircleChart {
        let info = configureDataAndLabel()
        var totalSucceed = 0, totalFailed = 0
        for (succeed, failed) in zip(info.dataArray, info.incompleteDataArray) {
            totalSucceed += succeed
            totalFailed += failed
        }
        
        let circleChart = PNCircleChart(frame: CGRectMake(0, 80, UIScreen.mainScreen().bounds.size.width, 100), total: totalSucceed + totalFailed, current: totalSucceed, clockwise: false, shadow: true, shadowColor: UIColor.greenColor())
        circleChart.strokeChart()
        return circleChart
    }
    
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
}
