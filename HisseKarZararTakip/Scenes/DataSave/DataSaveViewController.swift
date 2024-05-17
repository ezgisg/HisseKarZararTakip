//
//  DataSaveViewController.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 15.05.2024.
//

import UIKit

class DataSaveViewController: UIViewController {

    let viewModel = DataSaveViewModel()
  
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var commissionTextField: UITextField!
    private let shareNamePickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        TextFieldArrangements()
        viewModel.getShareNames()
    }

}

//Textfield controls
extension DataSaveViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let currentText = textField.text else {return true}
        
        switch textField {
        case priceTextField,
        commissionTextField:
            let newText = viewModel.controlDecimalNumberText(currentText: currentText, replacementString: string, range: range)
            if let newText {
                textField.text = newText
            }
            return false
        case countTextField:
            let bool = viewModel.controlIntegerNumberText(currentText: currentText, replacementString: string, range: range)
            return bool
        default:
            return false
        }
    }
}

//Picker things
extension DataSaveViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.shareNamesCount
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.shareNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        nameTextField.text = viewModel.shareNames[row]
    }

}

//Actions
extension DataSaveViewController {
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        guard let name = nameTextField.text, !name.isEmpty,
              let count = Double(countTextField.text ?? ""),
              let price =  Double(priceTextField.text ?? ""),
              let commission = Double(commissionTextField.text ?? "") else {
            showAlert(title: "Eksik Bilgi", message: "Kayıt yapılamadı. Eksik bilgileri tamamlayınız.")
            return
        }
        
        var newShare = SavedShareModel(name: name, count: count, price: price, commission: commission, total: nil)
        
        viewModel.saveNewShare(share: &newShare)
        
    }
    
    private func TextFieldArrangements() {
        priceTextField.delegate = self
        commissionTextField.delegate = self
        countTextField.delegate = self
        nameTextField.delegate = self
        
        shareNamePickerView.delegate = self
        shareNamePickerView.dataSource = self
        nameTextField.inputView = shareNamePickerView
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([space, doneButton], animated: false)
        nameTextField.inputAccessoryView = toolbar
        
    }
    
    @objc func doneTapped() {
        self.view.endEditing(true)

    }
}

extension DataSaveViewController: DataSaveViewModelDelegate {
    func saveCompleted(title: String, message: String, isSuccess: Bool) {
        showAlert(title: title, message: message) {
            
            //if core data save operation completed with success then show list screen with animation
            if isSuccess {
                
                guard let tabBarController = self.tabBarController,
                      let viewControllers = tabBarController.viewControllers,
                      viewControllers.count > 1 else {return}
                
                let fromView = tabBarController.selectedViewController?.view
                let toView = viewControllers[1].view
                
                guard let fromView = fromView, let toView = toView else {return}
                UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionFlipFromLeft], completion: { _ in
                    tabBarController.selectedIndex = 1
                })
                
            }
                
                
        }
    }
    
    func sendShareName() {
        shareNamePickerView.reloadAllComponents()
    }
    
}


