//
//  DailyWeightTVCell.swift
//  Charts
//
//  Created by Алексей Ведушев on 16.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit

protocol DailyWeightDataSource: class {
    func dailyWeightChartUnit() -> String
    func dailyWeightChartPlotData() -> PlotData
}

class DailyWeightTVCell: UITableViewCell {
    static let cellHeight: CGFloat = 500
    
    @IBOutlet weak var currentDayValueLabel: UILabel!
    @IBOutlet weak var lastManyDaysValueLabel: UILabel!
    @IBOutlet weak var annualAverageValueLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    
    @IBOutlet weak var lineCahrtView: LineChartContainerView!
    
    weak var dataSource: DailyWeightDataSource?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Public
    
    func reloadData() {
        guard let dataSource = dataSource else { return }
        
        lineCahrtView.setupData(plotData: dataSource.dailyWeightChartPlotData())
        unitLabel.text = dataSource.dailyWeightChartUnit()
    }
}
