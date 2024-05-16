//
//  DataSaveViewModel.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 15.05.2024.
//

import Foundation


protocol DataSaveViewModelProtocol {
    func controlDecimalNumberText(currentText: String? , replacementString: String, range: NSRange) -> (String?)
    func controlIntegerNumberText(currentText: String? , replacementString: String, range: NSRange) -> Bool
    
    func saveNewShare(share: inout SavedShareModel)
   

}

protocol DataSaveViewModelDelegate {
    
}


class DataSaveViewModel: DataSaveViewModelProtocol {


    var delegate: DataSaveViewModelDelegate?
    private var shareRepository = ShareRepository()
    
    func saveNewShare(share: inout SavedShareModel) {
        share.total = (share.count ?? 0) * (share.price ?? 0) + (share.commission ?? 0)
        shareRepository.saveShare(model: share)
    }

}


// Text Control Functions
extension DataSaveViewModel {
    
    func controlDecimalNumberText(currentText: String?, replacementString: String,  range: NSRange) -> (String?) {
        guard var currentText = currentText else {return (nil)}
        let allowedCharacterSet = CharacterSet(charactersIn: "0123456789,").inverted
        let components = replacementString.components(separatedBy: allowedCharacterSet)
        let filtered = components.joined(separator: "")
        
        //To forbid more than "." and "." as a first chr
        if (currentText.contains(".") || currentText.count < 1) && replacementString == "," {
            return nil
        //To change chr as "0." if first chr enter is 0
        } else if currentText.count < 1 && replacementString == "0" {
            let newText = (currentText as NSString).replacingCharacters(in: range, with: "0.")
            currentText = newText
            return currentText
        //To control new chr whether is allowed or not
        } else if replacementString == filtered {
            let newText = (currentText as NSString).replacingCharacters(in: range, with: replacementString)
            currentText = newText.replacingOccurrences(of: ",", with: ".")
            return currentText
        } else {
            return nil
        }
    }
    
    func controlIntegerNumberText(currentText: String?, replacementString: String, range: NSRange) -> Bool {
        let allowedCharacterSet = CharacterSet(charactersIn: "0123456789").inverted
        let components = replacementString.components(separatedBy: allowedCharacterSet)
        let filtered = components.joined(separator: "")
        
        //To prevent entering "0" as a initial of this
        if range.location == 0 && replacementString == "0" {
            return false
        } else if replacementString == filtered {
           return true
        } else {
            return false
        }
    }
}
