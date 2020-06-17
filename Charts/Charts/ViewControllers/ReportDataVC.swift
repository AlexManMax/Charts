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
    
    var weightPlotData: PlotData = PlotData.makeTestData()
    
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
            cell.delegate = self
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

// MARK: - DailyWeightDataSource

extension ReportDataVC: DailyWeightDataSource {
    func dailyWeightChartUnit() -> String {
        "(kg)"
    }
    
    func dailyWeightChartPlotData() -> PlotData {
        weightPlotData
    }
    
    func currentValue() -> String {
        guard let value = weightPlotData.enterPoints.last?.value else {
            return "-"
        }
        return String(format: "%.1f", value)
    }
    
    func lastMonthValue() -> String {
        let count = weightPlotData.enterPoints.count
        
        let value: CGFloat = {
            if count > 30 {
                let firstIndex = count - 30 - 1
                return weightPlotData.enterPoints[firstIndex...(count - 1)].map{ $0.value }.reduce(CGFloat(0), { $0 + $1})
            } else {
                return weightPlotData.enterPoints.map{ $0.value }.reduce(CGFloat(0), { $0 + $1})
            }
        }()
        var result = value >= 0 ? "+" : "-"
        result = result + " " + String(format: "%.1f", value)
        return result
    }
    
    func averageYearValue() -> String {
        guard let last = weightPlotData.enterPoints.last else {
            return "-"
        }
        let lastYear = last.date.year
        let points = weightPlotData.enterPoints.filter{ $0.date.year == lastYear }
        let summ = points.reduce(CGFloat(0), {$0 + $1.value})
        let averageValue = summ / CGFloat(points.count)
        return String(format: "%.1f", averageValue)
    }
}

// MARK: - DailyWeighDelegate

extension ReportDataVC: DailyWeighDelegate {
    func enterWeightTouched() {
        let vc = EnterWeightVC.build()
        present(vc, animated: false, completion: nil)
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
