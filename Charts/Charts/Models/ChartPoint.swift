//
//  File.swift
//  Charts
//
//  Created by Алексей Ведушев on 05.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit

struct ChartPoint {
    let date: Date
    let yValue: CGFloat // [0, 1]
}

struct PlotPointData {
    let value: CGFloat
    let date: Date
}

struct PlotData {
    var enterPoints: [PlotPointData]
    var defaultYAxisMax: CGFloat
    
    var topValue: CGFloat {
        guard let maxValue = enterPoints.map({ $0.value }).max() else {
            return defaultYAxisMax
        }
        return max(maxValue, defaultYAxisMax)
    }
    
    var сhartPoints: [ChartPoint] {
        return enterPoints.map {
            ChartPoint(
                date: $0.date,
                yValue: ($0.value / topValue).isNaN ? 0 : $0.value / topValue
            )}
    }
    
    var yAxisLineValues: [String] {
        var result = ["0"]
        let step = topValue / 5
        var value: CGFloat = 0
        
        while value < topValue {
            value += step
            result.append(String(format: "%0.1f", arguments: [value]))
        }
        return result
    }
    
    static func makeTestData() -> PlotData {
        let points = Array<Int>(0...40).compactMap { (index) -> PlotPointData? in
            guard let date = Calendar.current.date(byAdding: .day, value: index, to: Date()) else {
                return nil
            }
            let value = CGFloat.random(in: 0...20)
            return PlotPointData(value: value, date: date)
            //            return PlotPointData(value: 0, date: date)
        }
        return PlotData(enterPoints: points, defaultYAxisMax: 10)
    }
}
