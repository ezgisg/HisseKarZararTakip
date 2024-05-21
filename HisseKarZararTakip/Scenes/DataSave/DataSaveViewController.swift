//
//  DataSaveViewController.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 15.05.2024.
//

import UIKit

class DataSaveViewController: UIViewController {
  
    // MARK: - UI Components
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var commissionTextField: UITextField!
    
    private let shareNamePickerView = UIPickerView()
    
    // MARK: - MVVM Components
    let viewModel = DataSaveViewModel()

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        arrangeTextFields()
        viewModel.getShareNames()
        hideKeyboardWhenTappedAround()
        setupNavigationBar()

    }
}

// MARK: - Setup / Configuration
private extension DataSaveViewController {
    final func setupNavigationBar() {
        navigationItem.title = "Hisse Bilgilerimi Kaydet"
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 24, weight: .bold)
        ]
        navigationController?.navigationBar.standardAppearance = appearance
    }
}

// MARK: - UITextFieldDelegate
extension DataSaveViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
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
            return viewModel.controlIntegerNumberText(
                currentText: currentText,
                replacementString: string,
                range: range
            )
        default:
            return false
        }
    }
}

// MARK: - UIPickerViewDelegate
extension DataSaveViewController: UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

// MARK: - UIPickerViewDataSource
extension DataSaveViewController: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.shareNamesCount
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return ""
        } else {
            return viewModel.shareNames[row - 1] 
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            nameTextField.text = ""
        } else {
            return nameTextField.text = viewModel.shareNames[row-1]
        }
    }
}

// MARK: - Actions
private extension DataSaveViewController {
    final func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        guard let name = nameTextField.text, !name.isEmpty,
              let count = Double(countTextField.text ?? ""),
              let price =  Double(priceTextField.text ?? ""),
              let commission = Double(commissionTextField.text ?? "") else {
            showAlert(title: "Eksik Bilgi", message: "Kayıt yapılamadı. Eksik bilgileri tamamlayınız.")
            return
        }
        let uuid = UUID()
        var newShare = SavedShareModel(name: name, count: count, price: price, commission: commission, total: nil, uuid: uuid)
        
        viewModel.saveNewShare(share: &newShare)
        
    }
    
    final func arrangeTextFields() {
        priceTextField.delegate = self
        commissionTextField.delegate = self
        countTextField.delegate = self
        nameTextField.delegate = self
        
        shareNamePickerView.delegate = self
        shareNamePickerView.dataSource = self
        
        nameTextField.inputView = shareNamePickerView
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneTapped)
        )
        let space = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
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

            if isSuccess {
                // if core data save operation completed with success then show list screen with animation
         
                /*
                 //kayıt ettikten sonra kayıtlarım ekranına gitmek istersek
                let secondViewController = RecordedDataViewController()
                self.navigationController?.pushViewController(secondViewController, animated: true)
                  */
                
                guard let tabBarController = self.tabBarController,
                      let viewControllers = tabBarController.viewControllers,
                      viewControllers.count > 1 else { return }
                
                let fromView = tabBarController.selectedViewController?.view
                let toView = viewControllers[1].view
                
                guard let fromView,
                      let toView else { return }
                UIView.transition(from: fromView, to: toView, duration: 0.5, options: [.transitionCrossDissolve], completion: { _ in
                    tabBarController.selectedIndex = 1
                })
                
                self.clearFields()
            }
        }
    }
    
    func sendShareName() {
        shareNamePickerView.reloadAllComponents()
    }
    
    func clearFields() {
        nameTextField.text = ""
        countTextField.text = ""
        commissionTextField.text = ""
        priceTextField.text = ""
        shareNamePickerView.selectRow(0, inComponent: 0, animated: false)
    }
}


