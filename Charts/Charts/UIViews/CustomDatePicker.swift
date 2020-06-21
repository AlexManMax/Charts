//
//  CustomDatePicker.swift
//  Charts
//
//  Created by Алексей Ведушев on 19.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit

protocol CustomDatePickerDelegate: class {
    func selectDate(_ date: Date)
}

class CustomDatePicker: UIView {

    @IBOutlet weak var pickerView: UIPickerView!

    weak var delegate: CustomDatePickerDelegate?
    
    var date = Date()
    
    private var monthArray = Date.monthArray
    
    private var dayArray: [Int] {
        Array<Int>(1...date.numDaysInMonth - 1)
    }
    
    private var yearArray: [Int] {
        Array<Int>((Date().year - 100)...Date().year)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.delegate = self
        pickerView.dataSource = self
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        selectCurrentDate()
        delegate?.selectDate(date)
    }
    
    private func selectCurrentDate() {
        pickerView.selectRow(date.month - 1, inComponent: 0, animated: false)
        pickerView.selectRow(date.day - 1, inComponent: 1, animated: false)
        guard let index = yearArray.firstIndex(of: date.year) else { return }
        pickerView.selectRow(index, inComponent: 2, animated: false)
    }
}

// MARK: - UIPickerViewDataSource

extension CustomDatePicker: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return monthArray.count
        case 1:
            return dayArray.count
        case 2:
            return yearArray.count
        default:
            return 0
        }
    }
}

// MARK: - UIPickerViewDelegate

extension CustomDatePicker: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0:
            return 100
        case 1:
            return 50
        case 2:
            return 100
        default:
            break
        }
        return 50
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 25
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var string = ""
        
        switch component {
        case 0:
            string = monthArray[row]
        case 1:
            string = String(format: "%d", dayArray[row])
        case 2:
            string = String(format: "%d", yearArray[row])
        default:
            break
        }
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 10),
                                                               .foregroundColor: UIColor.white.withAlphaComponent(0.6)])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = pickerView.selectedRow(inComponent: 0) + 1
        let day = pickerView.selectedRow(inComponent: 1) + 1
        let year = yearArray[pickerView.selectedRow(inComponent: 2)]
        
        guard let date = DateComponents(calendar: Calendar.current,year: year, month: month, day: day).date else {
            return
        }
        guard date <= self.date else {
            selectCurrentDate()
            return
        }
        self.date = date
        delegate?.selectDate(date)
        
        if component == 0 || component == 2 {
            pickerView.reloadComponent(1)
        }
    }
}
