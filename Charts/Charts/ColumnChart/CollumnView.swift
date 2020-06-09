//
//  ColumnView.swift
//  Charts
//
//  Created by Алексей Ведушев on 03.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit

@IBDesignable
final class CollumnView: UIView {
    
    @IBInspectable var topColor: UIColor = .green {
        didSet{
            updateUI()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = .red {
        didSet{
            updateUI()
        }
    }
    
    override public class var layerClass: AnyClass { CAGradientLayer.self }

    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        updateUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
    
    fileprivate func updateUI() {
        let maskLayer = CAShapeLayer()
        let cornerRadius = min(bounds.height, bounds.width) / 2
        maskLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        maskLayer.fillColor  = UIColor.white.cgColor
        layer.mask = maskLayer
        backgroundColor = .clear
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
    }
}
