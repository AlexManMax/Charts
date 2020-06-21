//
//  HeightPicker.swift
//  Charts
//
//  Created by Алексей Ведушев on 21.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit

class HeightPicker: UIView {

    @IBOutlet weak var pickerView: UIPickerView!
    
    weak var delegate: WeightPickerDelegate?
    
    fileprivate var wholePartList: [Int] = Array<Int>(20...200)
    fileprivate var afterPointList: [Int] = Array<Int>(0...9)
    fileprivate var units: [String] = ["kg", "lbs"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil else { return }
        delegate?.didSelectWeight(20, unit: "kg")
    }
}

// MARK: - UIPickerViewDataSource

extension HeightPicker: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return wholePartList.count
        case 1:
            return afterPointList.count
        case 2:
            return units.count
        default:
            return 0
        }
    }
}

// MARK: - UIPickerViewDelegate

extension HeightPicker: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 50
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 25
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var string = ""
        
        switch component {
        case 0:
            string = String(format: "%d", wholePartList[row])
        case 1:
            string = String(format: ".%d", afterPointList[row])
        case 2:
            string = units[row]
        default:
            break
        }
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 10),
                                                               .foregroundColor: UIColor.white.withAlphaComponent(0.6)])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let wholePartIndex = pickerView.selectedRow(inComponent: 0)
        let afterPointIndex = pickerView.selectedRow(inComponent: 1)
        let unitIndex = pickerView.selectedRow(inComponent: 2)
        let weight = Double(wholePartList[wholePartIndex]) + Double(afterPointList[afterPointIndex]) / 10
        let unit = units[unitIndex]
        delegate?.didSelectWeight(weight, unit: unit)
    }
}
