//
//  PointValueView.swift
//  Charts
//
//  Created by Алексей Ведушев on 11.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit

class PointValueView: UIView {

    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.leftAnchor.constraint(equalTo: leftAnchor),
            label.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: min(bounds.width, bounds.height) / 2).cgPath
        layer.mask = maskLayer
    }

}
