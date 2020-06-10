//
//  LineChartContainerView.swift
//  Charts
//
//  Created by Алексей Ведушев on 09.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit

class LineChartContainerView: UIView {
    private let plotInsets = UIEdgeInsets(top: 20, left: 30, bottom: 0, right: 0)
    private let xValuesHeight: CGFloat = 20
    private let labelLeftOffset: CGFloat = 10
    
    private let horizontalLineColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
    private let labelColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    private var yAxisLineValues: [String] = []
    private var plotData = PlotData(enterPoints: [])
    
    private weak var lcChartViewWidth: NSLayoutConstraint?
//    private weak var lcChartViewHeight: NSLayoutConstraint?
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy var lineChartView: GradientLineChartView = {
        let chartView = GradientLineChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        return chartView
    }()
    
    lazy var monthContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard superview != nil else { return }
        updateUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateYValuesLabels()
        updateHorizontalLinesLayer()
    }
    
    func setupData(_ plotData: PlotData) {
        self.plotData = plotData
        self.yAxisLineValues = plotData.yAxisLineValues
        updateYValuesLabels()
        updateHorizontalLinesLayer()
        let chartWidth = GradientLineChartView.calculateWidth(pointsCount: plotData.сhartPoints.count)
        
        lcChartViewWidth?.constant = chartWidth
        lineChartView.setupData(plotData: plotData)
    }
    
    // MARK: - Private
    
    fileprivate func updateUI() {
        updateYValuesLabels()
        setupMonthContainerView()
        setupScrollView()
        updateHorizontalLinesLayer()
    }
    
    fileprivate func updateYValuesLabels() {
        subviews.compactMap{ $0 as? UILabel }
            .filter{ $0.tag == 100 }
            .forEach { (label) in
                label.removeFromSuperview()
        }
        guard yAxisLineValues.count > 0 else {
            return
        }
        yAxisLineValues.enumerated().forEach { (index, text) in
            let stepSize = (bounds.height - xValuesHeight - plotInsets.top) /  CGFloat(yAxisLineValues.count - 1)
            let label = makeLabel(text)
            let y = bounds.height - xValuesHeight - label.bounds.height / 2 - stepSize * CGFloat(index)
            let x = plotInsets.left - label.bounds.width - labelLeftOffset
            label.frame.origin = CGPoint(x: x, y: y)
            label.tag = 100
            addSubview(label)
        }
    }
    
    fileprivate func setupScrollView() {
        guard scrollView.superview == nil else {
            return
        }
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: leftAnchor, constant: plotInsets.left),
            scrollView.topAnchor.constraint(equalTo: monthContainerView.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: plotInsets.bottom),
            scrollView.rightAnchor.constraint(equalTo: rightAnchor, constant: plotInsets.right)
        ])
        scrollView.addSubview(lineChartView)
        let heightConstraint = lineChartView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        let widthConstraint = lineChartView.widthAnchor.constraint(equalToConstant: 200)
        
        NSLayoutConstraint.activate([
            heightConstraint,
            widthConstraint,
            lineChartView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            lineChartView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            lineChartView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            lineChartView.rightAnchor.constraint(equalTo: scrollView.rightAnchor)
        ])
        self.lcChartViewWidth = widthConstraint
    }
    
    fileprivate func makeLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.text = text
        label.textColor = labelColor
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = true
        return label
    }
    
    fileprivate func updateHorizontalLinesLayer() {
        if let sublayers = layer.sublayers {
            sublayers
                .compactMap{ $0 as? CAShapeLayer}
                .filter({ $0.name == "lineLayer"})
                .forEach { (layer) in
                    layer.removeFromSuperlayer()
            }
        }
        
        subviews.compactMap{ $0 as? UILabel }
            .forEach { (label) in
                let layer = CAShapeLayer()
                layer.backgroundColor = horizontalLineColor.cgColor
                let x = label.frame.origin.x + label.frame.width + labelLeftOffset
                let y = label.center.y
                let width = bounds.width - x
                let height = CGFloat(1)
                layer.frame = CGRect(x: x, y: y, width: width, height: height)
                layer.name = "lineLayer"
                self.layer.addSublayer(layer)
        }
    }
    
    fileprivate func updateMonthLabels() {
        var label: UILabel!
        
        if let firstDayCellData = getVisibleMonthFirstDayData(scrollView.contentOffset) {
            let pointX = firstDayCellData.centerX
            let monthName = firstDayCellData.date.monthName
            let month = firstDayCellData.date.month
            
            if monthContainerView.subviews.compactMap({$0 as? UILabel}).first(where: { $0.text == monthName}) == nil {
                label = UILabel()
                label.textColor = .white
                label.text = monthName
                monthContainerView.addSubview(label)
            }
            label = monthContainerView.subviews.compactMap({$0 as? UILabel}).first(where: { $0.text == monthName})!
            label.text = monthName
            let x = pointX
            label.frame.origin = CGPoint(x: x, y: 0)
            label.tag = month
            label.sizeToFit()
            let prevMonthLabel = monthContainerView.subviews
                            .compactMap({ $0 as? UILabel})
                            .first(where: { $0.text == firstDayCellData.date.prevMonthName}) ?? UILabel()
            
            if prevMonthLabel.superview == nil {
                monthContainerView.addSubview(prevMonthLabel)
            }
            prevMonthLabel.text = firstDayCellData.date.prevMonthName
            prevMonthLabel.textColor = .white
            prevMonthLabel.sizeToFit()
            prevMonthLabel.frame.origin.x = min(label.frame.origin.x - prevMonthLabel.bounds.width, 0)
        } else {
            guard let leftCellData = getLeftBorderCellDayData(scrollView.contentOffset) else {
                return
            }
            let monthName = leftCellData.date.monthName
            let month = leftCellData.date.month
            
            if monthContainerView.subviews.compactMap({$0 as? UILabel}).first(where: { $0.text == monthName}) == nil {
                let label = UILabel()
                label.textColor = .white
                label.text = monthName
                label.textColor = .white
                monthContainerView.addSubview(label)
            }
            let label = monthContainerView.subviews.compactMap({$0 as? UILabel}).first(where: { $0.text == monthName})!
            label.text = monthName
            label.sizeToFit()
            label.textColor = .white
            label.frame.origin = CGPoint(x: 0,
                                         y: 0)
            label.tag = month
            
            monthContainerView.subviews
                .compactMap({$0 as? UILabel})
                .filter({$0 !== label})
                .forEach { (label) in
                    label.removeFromSuperview()
            }
        }
    }
    
    fileprivate func getVisibleMonthFirstDayData(_ contentOffset: CGPoint) -> (centerX: CGFloat, date: Date)? {
        let contentSize = scrollView.contentSize
        
        guard contentSize.width > 0 else { return nil }
        let leftBorder = contentOffset.x
        let rightBorder = leftBorder + scrollView.bounds.width
        let leftCellIndex = max(Int(leftBorder / CollumnDayCVCell.cellWidth), 0)
        let rightCellIndex = min(Int(rightBorder / CollumnDayCVCell.cellWidth), plotData.enterPoints.count - 1)
        
        var firstDayIndex: Int?
        
        Array<Int>(leftCellIndex...rightCellIndex).forEach { (index) in
            if plotData.enterPoints[index].date.day == 1 {
                firstDayIndex = index
            }
        }
        guard let index = firstDayIndex else {
            return nil
        }
        var centerX = CGFloat(index) * CollumnDayCVCell.cellWidth + CollumnDayCVCell.cellWidth / 2 - contentOffset.x
        centerX = max(centerX, 0)
        return (centerX: centerX, date: plotData.enterPoints[index].date)
    }

    fileprivate func getLeftBorderCellDayData(_ contentOffset: CGPoint) -> (centerX: CGFloat, date: Date)? {
        let contentSize = scrollView.contentSize
        
        guard contentSize.width > 0 else { return nil }
        let leftBorder = contentOffset.x
        let leftCellIndex = max(Int(leftBorder / CollumnDayCVCell.cellWidth), 0)
        return (centerX: leftBorder + CollumnDayCVCell.cellWidth / 2,
                date: plotData.enterPoints[leftCellIndex].date)
    }
    
    fileprivate func setupMonthContainerView() {
        addSubview(monthContainerView)
        
        NSLayoutConstraint.activate([
            monthContainerView.topAnchor.constraint(equalTo: topAnchor),
            monthContainerView.leftAnchor.constraint(equalTo: leftAnchor, constant: plotInsets.left),
            monthContainerView.rightAnchor.constraint(equalTo: rightAnchor, constant: plotInsets.right),
            monthContainerView.heightAnchor.constraint(equalToConstant: plotInsets.top)
        ])
    }
}


