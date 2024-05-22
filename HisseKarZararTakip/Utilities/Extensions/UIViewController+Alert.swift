//
//  UIViewController+Alert.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 17.05.2024.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, buttonTitle: String = "OK", completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completion?()
        }
            
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getDataAlert(model: SavedShareModel , message: String, button1Title: String = "Vazgeç", button2Title: String = "Değiştir",  completion: @escaping ((UpdatedShareModel) -> Void))  {
        guard let uuid = model.uuid else { return }
        
        let alertController = UIAlertController(title: model.name , message: message, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Adet: \(model.count ?? 0)"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Maliyet: \(model.price ?? 0)"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Komisyon: \(model.commission ?? 0)"
        }
        
        let firstAction = UIAlertAction(title: button1Title, style: .default)
        let secondAction = UIAlertAction(title: button2Title, style: .default) { _ in
            //TODO: Double a dönüştürülemeyen hiçbir data kaydedilemiyor ancak kaydedilemediğine dair uyarı çıkmıyor, eklenebilir
            let newCount = Double(alertController.textFields?[0].text ?? "")
            let newPrice = Double(alertController.textFields?[1].text ?? "")
            let newCommission = Double(alertController.textFields?[2].text ?? "")
            let updatedShare = UpdatedShareModel(uuid: uuid, newCount: newCount, newPrice: newPrice, newCommission: newCommission)
            completion(updatedShare)
        }
        
        alertController.addAction(firstAction)
        alertController.addAction(secondAction)
        
        self.present(alertController, animated: true, completion: nil)
            
    }
    
}


