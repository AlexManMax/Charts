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
    
    @IBOutlet weak var collumnView: CollumnView!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var lcBottomViewHeight: NSLayoutConstraint!
    
    var pointValue: ChartPoint = ChartPoint(date: Date(), yValue: 0.5)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateColumnView()
    }
    
    func setup(pointValue: ChartPoint) {
        bottomLabel.text = "\(pointValue.date.day)"
        self.pointValue = pointValue
    }
    
    func setBottomViewHeight(_ height: CGFloat) {
        guard lcBottomViewHeight.constant != height else { return }
        lcBottomViewHeight.constant = height
        layoutIfNeeded()
    }
    
    fileprivate func updateColumnView() {
        let width = bounds.width / 3
        let height = (topView.bounds.height * pointValue.yValue)
        let x = (bounds.width - width) / 2
        let y = topView.bounds.height - height
        
        collumnView.frame = CGRect(x: x,
                                   y: y,
                                   width: width,
                                   height: height)
    }
}
