//
//  RoundView.swift
//  Charts
//
//  Created by Алексей Ведушев on 21.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit

class RoundView: UIView {

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        updateMask()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateMask()
    }

    
    fileprivate func updateMask() {
        let mask = CAShapeLayer()
        mask.path = UIBezierPath(roundedRect: bounds, cornerRadius: min(bounds.height, bounds.width) / 2).cgPath
        self.layer.mask = mask
    }
}
