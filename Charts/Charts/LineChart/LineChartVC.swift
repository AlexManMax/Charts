//
//  LineChartVC.swift
//  Charts
//
//  Created by Алексей Ведушев on 08.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit

class LineChartVC: UIViewController {

    @IBOutlet weak var chartContainer: LineChartContainerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let points = Array<Int>(0...40).compactMap { (index) -> PlotPointData? in
            guard let date = Calendar.current.date(byAdding: .day, value: index, to: Date()) else {
                return nil
            }
            let value = CGFloat.random(in: 0...20)
            return PlotPointData(value: value, date: date)
//            return PlotPointData(value: 0, date: date)
        }
        let plotData = PlotData(enterPoints: points, defaultYAxisMax: 10)
        chartContainer.setupData(plotData)
    }
    

}
