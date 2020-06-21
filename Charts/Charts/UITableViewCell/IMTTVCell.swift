//
//  IMTTVCell.swift
//  Charts
//
//  Created by Алексей Ведушев on 21.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit

class IMTTVCell: UITableViewCell {

    static let cellHeight: CGFloat = 145
    
    private let valueViewSize = CGSize(width: 30, height: 20)
    
    @IBOutlet weak var imtView: IMTView!
    @IBOutlet weak var mainContentView: UIView!
    
    private var currentValue: CGFloat = 30
    
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
        updateVlalueView(currentValue)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(valueView)
        imtView.addElement(percentWidth: 1 / 25, color: #colorLiteral(red: 0.1819873154, green: 0.2744832635, blue: 0.8309889436, alpha: 1), leftText: "15", rightText: nil)
        imtView.addElement(percentWidth: 2.5 / 25, color: #colorLiteral(red: 0.3122283816, green: 0.5883885026, blue: 0.9939255118, alpha: 1), leftText: "16", rightText: nil)
        imtView.addElement(percentWidth: 6.5 / 25, color: #colorLiteral(red: 0.05180351436, green: 0.7864189744, blue: 0.8669361472, alpha: 1), leftText: "18.5", rightText: nil)
        imtView.addElement(percentWidth: 5 / 25, color: #colorLiteral(red: 0.9944290519, green: 0.8150370717, blue: 0.1587764919, alpha: 1), leftText: "25", rightText: nil)
        imtView.addElement(percentWidth: 5 / 25, color: #colorLiteral(red: 0.989759028, green: 0.6979183555, blue: 0.3566628695, alpha: 1), leftText: "30", rightText: nil)
        imtView.addElement(percentWidth: 5 / 25, color: #colorLiteral(red: 0.9955756068, green: 0.2813150883, blue: 0.3798769116, alpha: 1), leftText: "35", rightText: "40")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setValue(_ value: CGFloat) {
        guard value >= 15 && value <= 40 else { return }
        
        currentValue = value
        updateVlalueView(value)
    }
    
    // MARK: - Private
    
    fileprivate func updateVlalueView(_ value: CGFloat) {
        valueLabel.text = String(format: "%0.1f", value)
        let x = imtView.bounds.width / 25 * (value - 15) - (valueViewSize.width / 2) + imtView.frame.origin.x + mainContentView.frame.origin.x
        let y = imtView.frame.origin.y - valueViewSize.height - 5
        valueView.frame = CGRect(origin: CGPoint(x: x, y: y), size: valueViewSize)
    }
}
