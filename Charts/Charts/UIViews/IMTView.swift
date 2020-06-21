//
//  LineDiagramView.swift
//  Charts
//
//  Created by Алексей Ведушев on 21.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit

class IMTView: UIView {
    
    private let labelFont = UIFont.systemFont(ofSize: 10, weight: .semibold)
    let colorViewSideInset: CGFloat = 1
    
    private lazy var stView: UIStackView = {
       let stView = UIStackView()
        stView.distribution = .equalSpacing
        stView.axis = .horizontal
        stView.translatesAutoresizingMaskIntoConstraints = false
        stView.backgroundColor = .blue
        return stView
    }()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard superview != nil else {
            return
        }
        
        if stView.superview == nil {
            addSubview(stView)

            NSLayoutConstraint.activate([
                stView.leftAnchor.constraint(equalTo: leftAnchor),
                stView.rightAnchor.constraint(equalTo: rightAnchor),
                stView.bottomAnchor.constraint(equalTo: bottomAnchor),
                stView.topAnchor.constraint(equalTo: topAnchor)
            ])
        }
    }
    
    func addElement(percentWidth: CGFloat, color: UIColor, leftText: String?, rightText: String?) {
        let elementView = makeElementView(color: color, leftText: leftText, rightText: rightText)
        stView.addArrangedSubview(elementView)
        
        NSLayoutConstraint.activate([
            elementView.widthAnchor.constraint(equalTo: stView.widthAnchor, multiplier: percentWidth)
        ])
    }
    
    private func makeElementView(color: UIColor, leftText: String?, rightText: String?) -> UIView {
        let view = UIView()
        let colorView = UIView()
        colorView.backgroundColor = color
        view.addSubview(colorView)
        view.translatesAutoresizingMaskIntoConstraints = false
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.layer.cornerRadius = 4
        colorView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            colorView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: colorViewSideInset),
            colorView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -colorViewSideInset),
            colorView.topAnchor.constraint(equalTo: view.topAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 8)
        ])
        
        
        let leftLabel = makeLabel(text: leftText)

        let rightLabel = makeLabel(text: rightText)

        view.addSubview(leftLabel)
        view.addSubview(rightLabel)
        

        NSLayoutConstraint.activate([
            leftLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: colorViewSideInset),
            leftLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            rightLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -colorViewSideInset),
            rightLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        return view
    }
    
    fileprivate func makeLabel(text: String?) -> UILabel{
        let leftLabel = UILabel()
        leftLabel.font = labelFont
        leftLabel.textColor = UIColor.white
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        leftLabel.text = text
        return leftLabel
    }
}
