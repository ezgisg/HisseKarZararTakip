//
//  DataShowViewModel.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 16.05.2024.
//

import Foundation

protocol DataShowViewModelProtocol {
    func fetchShares()
    var allRecordedShares: [SavedShareModel]? {get}
    var sumRecordedShares: [SavedShareModel]? {get}
    var recordedSharesNames: Set<String> {get set}
  
}

protocol DataShowViewModelDelegate {
    func getShares()
}

class DataShowViewModel: DataShowViewModelProtocol {
    var allRecordedShares: [SavedShareModel]? = [SavedShareModel]()
    

    var recordedSharesNames: Set<String> =  Set<String>()
    var sumRecordedShares: [SavedShareModel]? = [SavedShareModel]()
        
    var delegate: DataShowViewModelDelegate?
    private var shareRepository = ShareRepository()

    func fetchShares() {
        sumRecordedShares?.removeAll(keepingCapacity: false)
        shareRepository.fetchShares { [self] shares in
            allRecordedShares = shares
            let allRecords = shares
            guard let allRecords = allRecords else {return}
            for record in allRecords {
                guard let recordName = record.name else {return}
                self.recordedSharesNames.insert(recordName)
            }
 
            let recordedSharesNamesArray = Array(recordedSharesNames).sorted()
            
            for recordedName in recordedSharesNamesArray {
                var sumRecordedShare: SavedShareModel = SavedShareModel()
                for record in allRecords {
                    if record.name == recordedName {
                        sumRecordedShare.name = record.name
                        sumRecordedShare.count = (sumRecordedShare.count ?? 0) + (record.count ?? 0)
                        sumRecordedShare.total = (sumRecordedShare.total ?? 0) + (record.total ?? 0)
                        sumRecordedShare.commission = (sumRecordedShare.commission ?? 0) + (record.commission ?? 0)

                    }
                }
                sumRecordedShare.price = (sumRecordedShare.total ?? 0) /  (sumRecordedShare.count ?? 0)
                sumRecordedShares?.append(sumRecordedShare)
    
            }
            
            self.delegate?.getShares()
        }
    }


    
}
