//
//  ColumnChartView.swift
//  Charts
//
//  Created by Алексей Ведушев on 03.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit

class CollumnChartView: UIView, IChart {
    private let monthContainerHeight: CGFloat = 20
    private let plotInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
    private let xValuesHeight: CGFloat = 20
    private let labelLeftOffset: CGFloat = 5
    
    private let horizontalLineColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5)
    private let labelColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    private var yAxisLineValues: [String] = []
    private var plotData = PlotData(enterPoints: [], defaultYAxisMax: 1)
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: CollumnChartFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.registerCellNib(cellType: CollumnDayCVCell.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
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
        collectionView.dataSource = self
        collectionView.delegate = self
        updateUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateYValuesLabels()
        updateHorizontalLinesLayer()
    }
    
    func setupData(plotData: PlotData) {
        self.plotData = plotData
        self.yAxisLineValues = plotData.yAxisLineValues
        updateYValuesLabels()
        updateHorizontalLinesLayer()
    
        collectionView.addObserver(self, forKeyPath: "contentOffset", options: .old, context: nil)
        collectionView.reloadData()
        let indexPath = IndexPath(row: plotData.сhartPoints.count - 1, section: 0)
        collectionView.scrollToItem(at: indexPath,
                                          at: .right,
                                          animated: false)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let observedObject = object as? UICollectionView, observedObject == collectionView {
            updateMonthLabels()
        }
    }
    
    // MARK: - Private
    
    fileprivate func updateUI() {
        updateYValuesLabels()
        setupMonthContainerView()
        setupCollectionView()
        updateHorizontalLinesLayer()
    }
    
    fileprivate func updateYValuesLabels() {
        subviews.compactMap{ $0 as? UILabel }
            .filter{ $0.tag == 100 }
            .forEach { (label) in
                label.removeFromSuperview()
        }
        guard yAxisLineValues.count > 1 else {
            return
        }
        yAxisLineValues.enumerated().forEach { (index, text) in
            let stepSize = (bounds.height - xValuesHeight - monthContainerHeight - CollumnDayCVCell.topInset) /  CGFloat(yAxisLineValues.count - 1)
            let label = makeLabel(text)
            let y = bounds.height - xValuesHeight - label.bounds.height / 2 - stepSize * CGFloat(index)
            let x = plotInsets.left - label.bounds.width - labelLeftOffset
            label.frame.origin = CGPoint(x: x, y: y)
            label.tag = 100
            addSubview(label)
        }
    }
    
    fileprivate func setupCollectionView() {
        guard collectionView.superview == nil else {
            return
        }
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: plotInsets.left),
            collectionView.topAnchor.constraint(equalTo: monthContainerView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: plotInsets.bottom),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: plotInsets.right)
        ])
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
        
        if let firstDayCellData = getVisibleMonthFirstDayData(collectionView.contentOffset) {
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
            guard let leftCellData = getLeftBorderCellDayData(collectionView.contentOffset) else {
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
        let contentSize = collectionView.contentSize
        
        guard contentSize.width > 0 else { return nil }
        let leftBorder = contentOffset.x
        let rightBorder = leftBorder + collectionView.bounds.width
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
        let contentSize = collectionView.contentSize
        
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
            monthContainerView.heightAnchor.constraint(equalToConstant: monthContainerHeight)
        ])
    }
}

extension CollumnChartView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return plotData.сhartPoints.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeResusable(cellType: CollumnDayCVCell.self, for: indexPath)
        let chartPoint = plotData.сhartPoints[indexPath.row]
        let plotPoint = plotData.enterPoints[indexPath.row]
        cell.setBottomViewHeight(xValuesHeight)
        cell.setup(chartPoint: chartPoint, plotPoint: plotPoint)
        cell.bottomLabel.textColor = labelColor
        return cell
    }
}

extension CollumnChartView: UICollectionViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        updateMonthLabels()
//    }
}
