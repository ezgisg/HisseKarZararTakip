//
//  DataSaveViewController.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 15.05.2024.
//

import UIKit

class DataSaveViewController: UIViewController, DataSaveViewModelDelegate {

    
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
            return true
        }
    }
}

//Picker things
extension DataSaveViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    
}

//Actions
extension DataSaveViewController {
    @IBAction func saveButtonClicked(_ sender: Any) {

        guard let name = nameTextField.text else {return}
        guard let count = Double(countTextField.text ?? "") else {return}
        guard let price =  Double(priceTextField.text ?? "") else {return}
        guard let commission = Double(commissionTextField.text ?? "") else {return}

        
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
        nameTextField.inputAccessoryView = UIToolbar()
    }
}
