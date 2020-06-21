//
//  IMTTVCell.swift
//  Charts
//
//  Created by Алексей Ведушев on 21.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit

class IMTTVCell: UITableViewCell {

    static let cellHeight: CGFloat = 175
    
    private let valueViewSize = CGSize(width: 30, height: 20)
    
    @IBOutlet weak var imtView: IMTView!
    @IBOutlet weak var mainContentView: UIView!
    @IBOutlet weak var currentImtColorView: UIView!
    @IBOutlet weak var currentLevellabel: UILabel!
    
    private var currentValue: IMTData = IMTData(value: 30)
    
    lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    lazy var valueView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.3433177471, green: 0.3767276406, blue: 0.4197502136, alpha: 1)
        view.addSubview(valueLabel)
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            valueLabel.leftAnchor.constraint(equalTo: view.leftAnchor),
            valueLabel.rightAnchor.constraint(equalTo: view.rightAnchor),
            valueLabel.topAnchor.constraint(equalTo: view.topAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateVlalueView(CGFloat(currentValue.value))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(valueView)
        let allRangeLength = CGFloat(IMTLevel.secondDegreeObesity.range.upperBound - IMTLevel.verySevereDepletion.range.lowerBound)
        
        IMTLevel.allCases.forEach { (level) in
            let countSymbolAfterPoint1: Int = level.range.lowerBound - Float(Int(level.range.lowerBound)) > 0 ? 1 : 0
            
            let length = CGFloat(level.range.upperBound - level.range.lowerBound)
            if level == .secondDegreeObesity {
                imtView.addElement(percentWidth: length / allRangeLength,
                                   color: level.color,
                                   leftText: String(format: "%.\(countSymbolAfterPoint1)f", level.range.lowerBound),
                                   rightText: String(format: "%.1f", level.range.upperBound))
            } else {
                imtView.addElement(percentWidth: length / allRangeLength,
                                   color: level.color,
                                   leftText: String(format: "%.\(countSymbolAfterPoint1)f", level.range.lowerBound),
                                   rightText: nil)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setValue(_ imtData: IMTData) {
        guard imtData.value >= 15 && imtData.value <= 40 else { return }
        
        currentValue = imtData
        updateVlalueView(CGFloat(imtData.value))
        currentImtColorView.backgroundColor = imtData.level.color
        currentLevellabel.text = imtData.level.name
    }
    
    // MARK: - Private
    
    fileprivate func updateVlalueView(_ value: CGFloat) {
        valueLabel.text = String(format: "%0.1f", value)
        let x = imtView.bounds.width / 25 * (value - 15) - (valueViewSize.width / 2) + imtView.frame.origin.x + mainContentView.frame.origin.x
        let y = imtView.frame.origin.y - valueViewSize.height - 5
        valueView.frame = CGRect(origin: CGPoint(x: x, y: y), size: valueViewSize)
    }
}
