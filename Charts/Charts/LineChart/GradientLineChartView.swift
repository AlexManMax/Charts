//
//  GradientLineChartView.swift
//  Charts
//
//  Created by Алексей Ведушев on 09.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit

class GradientLineChartView: UIView, IChart {
    static let pointSpacing: CGFloat = 40
    static let insets = UIEdgeInsets(top: 25, left: 20, bottom: 20, right: 0)
    
    static func calculateWidth(pointsCount: Int) -> CGFloat {
        insets.left + insets.right + GradientLineChartView.pointSpacing * CGFloat(pointsCount)
    }
    
    private let valueContainerSize = CGSize(width: 30, height: 20)
    
    @IBInspectable var lineColor: UIColor = #colorLiteral(red: 0.07329701632, green: 0.7598437667, blue: 0.4869676232, alpha: 1)
    @IBInspectable var startColor: UIColor = #colorLiteral(red: 0.07329701632, green: 0.7598437667, blue: 0.4869676232, alpha: 1).withAlphaComponent(0.8)
    @IBInspectable var endColor: UIColor = .clear
    @IBInspectable var pointColor: UIColor = .white
    @IBInspectable var valueTextColor: UIColor = .white
    @IBInspectable var valueContainerColor: UIColor = .green
    @IBInspectable var circleRadius: CGFloat = 4
    
    var plotData = PlotData(enterPoints: [], defaultYAxisMax: 1)
    
    private var graphPoints: [CGFloat] {
        let height = bounds.height - GradientLineChartView.insets.top - GradientLineChartView.insets.bottom
        guard height > 0 else {
            return []
        }
        return plotData.сhartPoints.map { (chartPoint) -> CGFloat in
            bounds.height - (chartPoint.yValue * height) - GradientLineChartView.insets.bottom
        }
    }
    
    private var points: [CGPoint] {
        guard !graphPoints.isEmpty else {
            return []
        }
        return graphPoints.enumerated()
            .map { (index, y) -> CGPoint in
                let x = CGFloat(index) * GradientLineChartView.pointSpacing + GradientLineChartView.insets.left
                return CGPoint(x: x, y: y)
            }
    }
    
    private var controlPoints: [CubicCurveSegment] {
        CubicCurveAlgorithm().controlPointsFromPoints(dataPoints: points)
    }
    
    private weak var valueLabel: UILabel?
    
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
        
        updateDayTexts()
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        updateGradientLayer()
        updateChartLayer()
        updateDayTexts()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        guard let location = touches.first?.location(in: self) else { return }
        let locationFrame = CGRect(x: location.x - 20, y: location.y - 20, width: 40, height: 40)
        
        guard let index = points.firstIndex(where: { locationFrame.contains($0) }) else { return }
        drawValueLayer(index: index)
    }
    
    fileprivate func drawValueLayer(index: Int) {
        let valueLabel: UILabel
        
        if self.valueLabel == nil {
            let label = UILabel()
            label.backgroundColor = valueContainerColor
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
            label.textAlignment = .center
            label.layer.cornerRadius = 4
            label.clipsToBounds = true
            self.addSubview(label)
            self.valueLabel = label
            valueLabel = label
        } else {
            valueLabel = self.valueLabel!
        }
        let point = points[index]
        valueLabel.text = String(format: "%.1f", plotData.enterPoints[index].value)
        valueLabel.frame = CGRect(x: point.x - valueContainerSize.width / 2,
                                      y: point.y - 10 - valueContainerSize.height,
                                      width: valueContainerSize.width,
                                      height: valueContainerSize.height)
    }

    func setupData(plotData: PlotData) {
        guard self.plotData.enterPoints != plotData.enterPoints else {
            return
        }
        self.plotData = plotData
        updateGradientLayer()
        updateChartLayer()
        updateDayTexts()
    }
    
    fileprivate func updateDayTexts() {
        removeAllDayText()
        points.enumerated().forEach { (index, point) in
            let day = plotData.enterPoints[index].date.day
            let centerY = bounds.height - GradientLineChartView.insets.bottom / 2
            let textLayer = makeTextLayer("\(day)")
            let size = textLayer.preferredFrameSize()
            let y = centerY - size.height / 2
            textLayer.frame = CGRect(x: point.x - size.width / 2,
                                     y: y,
                                     width: size.width,
                                     height: size.height)
            chartLayr.addSublayer(textLayer)
        }
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
        chartLayr.strokeColor = lineColor.cgColor
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
        circleLayer.bounds = CGRect(x: 0,
                                    y: 0,
                                    width: circleRadius * 2,
                                    height: circleRadius * 2)
        circleLayer.path = UIBezierPath(ovalIn: circleLayer.bounds).cgPath
        circleLayer.fillColor = UIColor.white.cgColor
        circleLayer.strokeColor = lineColor.cgColor
        circleLayer.lineWidth = 2
        circleLayer.position = point
        circleLayer.name = "circleLayer"
        return circleLayer
    }
    
    fileprivate func makeTextLayer(_ text: String,
                                   font: UIFont = UIFont.systemFont(ofSize: 10),
                                   foregroundColor: UIColor = .white) -> CATextLayer {
        let layer = CATextLayer()

        let myAttributes = [
            NSAttributedString.Key.font: font , // font
            NSAttributedString.Key.foregroundColor: foregroundColor                    // text color
        ]
        let myAttributedString = NSAttributedString(string: text, attributes: myAttributes )
        layer.foregroundColor = foregroundColor.cgColor
        layer.string = myAttributedString
        layer.name = "dayText"
        
        return layer
    }
    
    fileprivate func removeAllDayText() {
        chartLayr.sublayers?
            .filter{ $0.name == "dayText"}
            .forEach{ $0.removeFromSuperlayer()}
    }
    
    func removeAllCircleLayer() {
        chartLayr.sublayers?
            .compactMap{$0 as? CAShapeLayer}
            .filter({ $0.name == "circleLayer"})
            .forEach{ $0.removeFromSuperlayer()}
    }
}
