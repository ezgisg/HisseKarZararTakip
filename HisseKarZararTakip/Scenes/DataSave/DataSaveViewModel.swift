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
    func getShareNames()
   

}

protocol DataSaveViewModelDelegate {
    func sendShareName()
    func saveCompleted(title: String, message: String, isSuccess: Bool)
}


class DataSaveViewModel: DataSaveViewModelProtocol {

    var service: ShareServiceProtocol? = ShareService()
    var delegate: DataSaveViewModelDelegate?
    var shareNames = [String]()
    var shareNamesCount = Int()
    private var shareRepository = ShareRepository()
    
    func saveNewShare(share: inout SavedShareModel) {
        share.total = (share.count ?? 0) * (share.price ?? 0) + (share.commission ?? 0)
        let isRecorded = shareRepository.saveShare(model: share)
        if isRecorded {
            self.delegate?.saveCompleted(title: "Başarılı", message: "Kayıt başarıyla gerçekleşti!", isSuccess: true)
        } else {
            self.delegate?.saveCompleted(title: "Başarısız", message: "Kayıt tamamlanamadı!", isSuccess: false)
        }
    }
    
    func getShareNames() {
        let urlString = "https://bigpara.hurriyet.com.tr/api/v1/hisse/list"
        service?.fetchServiceData(urlString: urlString, completion: { (response: Result<ShareList, Error>) in
            switch response {
            case .success(let data):
                let shareNames = data.data
                guard let shareNames else {return}
                for sharename in shareNames {
                    guard let name = sharename.ad else {return}
                    self.shareNames.append(name)
                }
                self.shareNamesCount = shareNames.count
                self.delegate?.sendShareName()
                
            case .failure(_):
                //TO DO: Alert
                print("***** Error happend when fetching name service data *****")
            }
        })
    }
    
    func getShareDetailInfos() {}

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
