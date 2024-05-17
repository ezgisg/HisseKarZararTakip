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
    
}


