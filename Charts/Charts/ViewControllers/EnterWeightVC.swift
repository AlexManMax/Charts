//
//  EnterWeightVC.swift
//  Charts
//
//  Created by Алексей Ведушев on 17.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import UIKit

extension EnterWeightVC {
    static func build() -> EnterWeightVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EnterWeightVC") as! EnterWeightVC
        vc.modalPresentationStyle = .overFullScreen
        return vc
    }
}

final class EnterWeightVC: UIViewController {

    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
    private let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        datePicker.date = Date()
        let cancelButton = UIBarButtonItem(title: "Отмен", style: .plain, target: self, action: #selector(cancelPickerTouched))
        let startButton = UIBarButtonItem(title: "Начать", style: .plain, target: self, action: #selector(startPickerTouched))
        toolBar.setItems([cancelButton, startButton], animated: false)
        
        dateTextField.inputAccessoryView = toolBar
        dateTextField.inputView = datePicker
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
        dateTextField.text = formatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
}
