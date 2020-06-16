//
//  CaloriesTVCell.swift
//  Charts
//
//  Created by Алексей Ведушев on 14.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit

protocol SimpleChartDataSource: class {
    func simpleChartTitle(_ index: Int) -> String
    func simpleChartUnit(_ index: Int) -> String
    func simpleChartPlotData(_ index: Int) -> PlotData
    func simpleChartType(_ index: Int) -> ChartType
}

class SimpleChartTVCell: UITableViewCell {
    static let cellHeight: CGFloat = 350
    
    @IBOutlet weak var lineChartView: LineChartContainerView!
    @IBOutlet weak var collumnChartView: CollumnChartView!
    
    @IBOutlet weak var plotTittleLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    
    weak var dataSource: SimpleChartDataSource?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Public
    
    func reloadData() {
        guard let dataSource = dataSource else { return }
        lineChartView.isHidden = dataSource.simpleChartType(tag) == .collumn
        collumnChartView.isHidden = dataSource.simpleChartType(tag) == .line
        let chart: IChart = dataSource.simpleChartType(tag) == .collumn ? collumnChartView : lineChartView
        chart.setupData(plotData: dataSource.simpleChartPlotData(tag))
        plotTittleLabel.text = dataSource.simpleChartTitle(tag)
        unitLabel.text = dataSource.simpleChartUnit(tag)
    }
}
