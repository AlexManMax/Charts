//
//  ViewController.swift
//  Charts
//
//  Created by Алексей Ведушев on 02.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit

class ColumnChartVC: UIViewController {

    @IBOutlet weak var collumnChartView: CollumnChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var points = [PlotPointData(value: 3, date: Date()),
                      PlotPointData(value: 0, date: Calendar.current.date(byAdding: .day, value: 1, to: Date())!)]
        
        Array<Int>(0...40).compactMap { (index) -> PlotPointData? in
            guard let date = Calendar.current.date(byAdding: .day, value: index + 2, to: Date()) else {
                return nil
            }
            return PlotPointData(value: CGFloat.random(in: 0...20), date: date)
        }.forEach { (point) in
            points.append(point)
        }
        let plotData = PlotData(enterPoints: points, defaultYAxisMax: 10)
//        let plotData = PlotData(enterPoints: [PlotPointData(value: 4, date: Date())], defaultYAxisMax: 10)
        collumnChartView.setupData(plotData: plotData)
    }
}

