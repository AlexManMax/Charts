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
    
    var сhartPoints: [ChartPoint] {
        guard let maxValue = enterPoints.map({ $0.value }).max() else {
            return []
        }
        return enterPoints.map {
            ChartPoint(
                date: $0.date,
                yValue: $0.value / maxValue
            )}
    }
    
    var yAxisLineValues: [String] {
        var result = ["0"]
        
        guard let maxValue = enterPoints.map({ $0.value }).max() else {
            return []
        }
        let step = maxValue / 5
        var value: CGFloat = 0
        
        while value < maxValue {
            value += step
            result.append("\(Int(value))")
        }
        return result
    }
}
