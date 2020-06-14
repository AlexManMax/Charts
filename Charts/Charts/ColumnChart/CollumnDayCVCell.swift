//
//  ColumnCVCell.swift
//  Charts
//
//  Created by Алексей Ведушев on 03.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit

class CollumnDayCVCell: UICollectionViewCell {
    static let cellWidth: CGFloat = 40
    static let topInset: CGFloat = 25
    
    private let valueViewHeight: CGFloat = 20
    @IBOutlet weak var collumnView: CollumnView!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var lcBottomViewHeight: NSLayoutConstraint!
    
    lazy var valueView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2689377666, green: 1, blue: 0.3203957379, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 4
        return view
    }()
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        valueView.addSubview(label)
        label.frame = valueView.bounds
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            valueView.isHidden = !isSelected
        }
    }
    
    var chartPointValue: ChartPoint = ChartPoint(date: Date(), yValue: 0.5)
    var plotPoint: PlotPointData = PlotPointData(value: 0, date: Date())
    
    private var collumnViewFrame: CGRect {
        let width = bounds.width / 3
        let height = (topView.bounds.height - CollumnDayCVCell.topInset) * chartPointValue.yValue
        let x = (bounds.width - width) / 2
        let y = topView.bounds.height - height
        return CGRect(x: x,
                      y: y,
                      width: width,
                      height: height)
    }
    
    private var valueViewFrame: CGRect {
        let width = bounds.width / 3 * 2
        let height: CGFloat = valueViewHeight
        let y = collumnViewFrame.origin.y - 5 - height
        let x = (bounds.width - width) / 2
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateColumnView()
        updateValueView()
    }
    
    
    func setup(chartPoint: ChartPoint, plotPoint: PlotPointData) {
        bottomLabel.text = "\(chartPoint.date.day)"
        self.chartPointValue = chartPoint
        self.plotPoint = plotPoint
        self.valueLabel.text = String(format: "%.0f", arguments: [plotPoint.value])
    }
    
    func setBottomViewHeight(_ height: CGFloat) {
        guard lcBottomViewHeight.constant != height else { return }
        lcBottomViewHeight.constant = height
        layoutIfNeeded()
    }
    
    fileprivate func updateColumnView() {
        collumnView.frame = collumnViewFrame
    }
    
    fileprivate func updateValueView() {
        if valueView.superview == nil {
            addSubview(valueView)
        }
        valueView.frame = valueViewFrame
        valueLabel.frame = valueView.bounds
        valueView.isHidden = !isSelected
    }
}
