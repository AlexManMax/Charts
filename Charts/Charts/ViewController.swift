//
//  ViewController.swift
//  Charts
//
//  Created by Алексей Ведушев on 02.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collumnChartView: ColumnChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let points = Array<Int>(0...40).compactMap { (index) -> PlotPointData? in
            guard let date = Calendar.current.date(byAdding: .day, value: index, to: Date()) else {
                return nil
            }
            return PlotPointData(value: CGFloat.random(in: 0...20), date: date)
        }
        let plotData = PlotData(enterPoints: points)
        collumnChartView.setupData(plotData)
    }
}

