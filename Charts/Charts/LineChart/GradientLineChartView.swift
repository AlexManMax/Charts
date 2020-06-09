//
//  GradientLineChartView.swift
//  Charts
//
//  Created by Алексей Ведушев on 09.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit

class GradientLineChartView: UIView {
    static let pointSpacing: CGFloat = 80
    static let insets = UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 0)
    
    static func calculateWidth(pointsCount: Int) -> CGFloat {
        insets.left + insets.right + GradientLineChartView.pointSpacing * CGFloat(pointsCount)
    }
    
    @IBInspectable var startColor: UIColor = .red
    @IBInspectable var endColor: UIColor = .clear
    @IBInspectable var pointColor: UIColor = .green
    
    var plotData = PlotData(enterPoints: [])
    
    private var graphPoints: [CGFloat] {
        let height = bounds.height - GradientLineChartView.insets.top - GradientLineChartView.insets.bottom
        return plotData.сhartPoints.map{bounds.height - ($0.yValue * height) + GradientLineChartView.insets.top }
    }
    
    private var points: [CGPoint] {
        guard !graphPoints.isEmpty else {
            return []
        }
        let averageValue = CGFloat(graphPoints.reduce(CGFloat(0), { $0 + $1 }) / CGFloat(graphPoints.count))
        let maxValue = averageValue * 2
        let scaleY = bounds.height / maxValue
        let yPoints = graphPoints.map { $0 * scaleY }
        
        return yPoints.enumerated()
            .map { (index, y) -> CGPoint in
                let x = CGFloat(index) * GradientLineChartView.pointSpacing + GradientLineChartView.insets.left
                return CGPoint(x: x, y: y)
            }
    }
    
    private var controlPoints: [CubicCurveSegment] {
        CubicCurveAlgorithm().controlPointsFromPoints(dataPoints: points)
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [startColor.cgColor, endColor.cgColor]
        layer.locations = [0, 1]
        return layer
    }()

    private lazy var chartLayr: CAShapeLayer = {
        let layer = CAShapeLayer()
        return layer
    }()

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        layer.addSublayer(gradientLayer)
        gradientLayer.frame = bounds
        updateGradientLayer()
        
        layer.addSublayer(chartLayr)
        chartLayr.frame = bounds
        updateChartLayer()
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        updateGradientLayer()
        updateChartLayer()
    }

    func setupData(plotData: PlotData) {
        self.plotData = plotData
        updateGradientLayer()
        updateChartLayer()
    }
    
    fileprivate func updateChartLayer() {
        chartLayr.frame = bounds
        
        let path = UIBezierPath()

        guard graphPoints.count > 0 else {
            return
        }
        path.move(to: points[0])
        points[1 ... points.count - 1]
        .enumerated()
        .forEach { index, point in
            path.addCurve(to: point,
                          controlPoint1: controlPoints[index].controlPoint1,
                          controlPoint2: controlPoints[index].controlPoint2)
        }
        chartLayr.strokeColor = UIColor.black.cgColor
        chartLayr.path = path.cgPath
        chartLayr.lineWidth = 2
        chartLayr.fillColor = UIColor.clear.cgColor
    }

    fileprivate func updateGradientLayer() {
        gradientLayer.frame = bounds
        let path = UIBezierPath()
        
        guard graphPoints.count > 0 else {
            return
        }
        path.move(to: points[0])

        points[1 ... points.count - 1]
            .enumerated()
            .forEach { index, point in
                path.addCurve(to: point,
                              controlPoint1: controlPoints[index].controlPoint1,
                              controlPoint2: controlPoints[index].controlPoint2)
            }

        let maskPath = path.copy() as! UIBezierPath
        maskPath.addLine(to: CGPoint(x: points[points.count - 1].x, y: bounds.height))
        maskPath.addLine(to: CGPoint(x: points[0].x, y: bounds.height))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        gradientLayer.mask = maskLayer
        
        removeAllCircleLayer()
        
        points.forEach { (point) in
            let circleLayer = makeCircleLayer(point: point)
            chartLayr.addSublayer(circleLayer)
        }
    }
    
    fileprivate func makeCircleLayer(point: CGPoint) -> CAShapeLayer {
        let circleLayer = CAShapeLayer()
        circleLayer.bounds = CGRect(x: 0, y: 0, width: 12, height: 12)
        circleLayer.path = UIBezierPath(ovalIn: circleLayer.bounds).cgPath
        circleLayer.fillColor = pointColor.cgColor
        circleLayer.position = point
        circleLayer.name = "circleLayer"
        return circleLayer
    }
    
    fileprivate func maketextLayer() -> CATextLayer {
        let layer = CATextLayer()
        
        layer.font = CTFontDescriptorCreateWithNameAndSize(UIFont.systemFont(ofSize: 1).fontName as CFString, 10)
        return layer
    }
    
    func removeAllCircleLayer() {
        chartLayr.sublayers?
            .compactMap{$0 as? CAShapeLayer}
            .filter({ $0.name == "circleLayer"})
            .forEach{ $0.removeFromSuperlayer()}
    }
}
