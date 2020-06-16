//
//  ReportDataVC.swift
//  Charts
//
//  Created by Алексей Ведушев on 14.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit

class ReportDataVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellNib(cellType: SimpleChartTVCell.self)
        tableView.registerCellNib(cellType: DailyWeightTVCell.self)
    }
    
    // MARK: - Helpers
    
    fileprivate func makePlotData() -> PlotData {
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

// MARK: - SimpleChartDataSource

extension ReportDataVC: SimpleChartDataSource {
    func simpleChartTitle(_ index: Int) -> String {
        let celltype = ReportDataCellType(rawValue: index)!
        return celltype.title
    }
    
    func simpleChartUnit(_ index: Int) -> String {
        let celltype = ReportDataCellType(rawValue: index)!
        return celltype.unit
    }
    
    func simpleChartPlotData(_ index: Int) -> PlotData {
        return makePlotData()
    }
    
    func simpleChartType(_ index: Int) -> ChartType {
        let celltype = ReportDataCellType(rawValue: index)!
        return celltype.chartType
    }
}

// MARK: - UITableViewDataSource

extension ReportDataVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = ReportDataCellType(rawValue: indexPath.row)!
        
        switch cellType {
        case .callories:
            let cell = tableView.dequeReusable(cellType: SimpleChartTVCell.self, indexPath: indexPath)
            cell.dataSource = self
            cell.tag = indexPath.row
            cell.reloadData()
            return cell
        case .weight:
            let cell = tableView.dequeReusable(cellType: DailyWeightTVCell.self, indexPath: indexPath)
            cell.tag = indexPath.row
            cell.dataSource = self
            cell.reloadData()
            return cell
        }
        
    }
}

// MARK: - UITableViewDelegate

extension ReportDataVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = ReportDataCellType(rawValue: indexPath.row)!
        return cellType.cellHeight
    }
}

extension ReportDataVC: DailyWeightDataSource {
    func dailyWeightChartUnit() -> String {
        "(kg)"
    }
    
    func dailyWeightChartPlotData() -> PlotData {
        makePlotData()
    }
    
}

enum ReportDataCellType: Int {
    case callories
    case weight
    
    var title: String {
        switch self {
        case .callories:
            return "Сожжено калорий (примерно)"
        case .weight:
            return "Вес"
        }
    }
    
    var unit: String {
        switch self {
        case .callories:
            return "Ккал"
        case .weight:
            return "Kg"
        }
    }
    
    var chartType: ChartType {
        switch self {
        case .callories:
            return .line
        case.weight:
            return .line
        }
    }
    
    var cellHeight: CGFloat {
        switch self {
        case .callories:
            return SimpleChartTVCell.cellHeight
        case .weight:
            return DailyWeightTVCell.cellHeight
        }
    }
}
