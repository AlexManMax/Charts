//
//  EnterWeightVC.swift
//  Charts
//
//  Created by Алексей Ведушев on 17.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit

extension EnterUserDataVC {
    static func build() -> EnterUserDataVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EnterWeightVC") as! EnterUserDataVC
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
}

final class EnterUserDataVC: UIViewController {

    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    private let datePicker: CustomDatePicker = .fromNib()
    private let weightPicker: WeightPicker = .fromNib()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDatePicker()
        setupWeighPicker()
        firstTextField.delegate = self
        weightTextField.delegate = self
    }

    // MARK: - Action
    
    @IBAction func cancelButtonTouched(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func saveButtonTouched(_ sender: Any) {
        
    }
    
    @IBAction func mainViewToched(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func cancelPickerTouched(_ sender: AnyObject) {
        view.endEditing(true)
    }
    
    @objc func startPickerTouched(_ sender: AnyObject) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        firstTextField.text = formatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    // MARK: - Private
    
    fileprivate func setupDatePicker() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        datePicker.date = Date()
        let cancelButton = UIBarButtonItem(title: "Отмен", style: .plain, target: self, action: #selector(cancelPickerTouched))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let startButton = UIBarButtonItem(title: "Начать", style: .done, target: self, action: #selector(startPickerTouched))
        toolBar.setItems([cancelButton, spaceButton, startButton], animated: false)
        toolBar.barTintColor = #colorLiteral(red: 0.1838280857, green: 0.2111999989, blue: 0.2801737189, alpha: 1)
        datePicker.backgroundColor = #colorLiteral(red: 0.1838280857, green: 0.2111999989, blue: 0.2801737189, alpha: 1)
        datePicker.delegate = self
        
        firstTextField.inputAccessoryView = toolBar
        firstTextField.inputView = datePicker
    }
    
    fileprivate func setupWeighPicker() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        
        let cancelButton = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelPickerTouched))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let startButton = UIBarButtonItem(title: "Начать", style: .done, target: self, action: #selector(startPickerTouched))
        toolBar.setItems([cancelButton, spaceButton, startButton], animated: false)
        
        toolBar.barTintColor = #colorLiteral(red: 0.1838280857, green: 0.2111999989, blue: 0.2801737189, alpha: 1)
        weightPicker.backgroundColor = #colorLiteral(red: 0.1838280857, green: 0.2111999989, blue: 0.2801737189, alpha: 1)
        weightPicker.delegate = self
        weightTextField.inputAccessoryView = toolBar
        weightTextField.inputView = weightPicker
    }
}

// MARK: - CustomDatePickerDelegate

extension EnterUserDataVC: CustomDatePickerDelegate {
    func selectDate(_ date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        
        firstTextField.text = formatter.string(from: date)
    }
}

// MARK: - WeightPickerDelegate

extension EnterUserDataVC: WeightPickerDelegate {
    func didSelectWeight(_ weight: Double, unit: String) {
        var text = String(format: "%.1f", weight)
        text += " \(unit)"
        weightTextField.text = text
    }
}


extension EnterUserDataVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = #colorLiteral(red: 0.06107478589, green: 0.7719560862, blue: 0.48526752, alpha: 1)
        textField.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.textColor = UIColor.white.withAlphaComponent(0.6)
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
}
