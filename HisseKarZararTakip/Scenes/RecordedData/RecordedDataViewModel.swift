//
//  RecordedDataViewModel.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 21.05.2024.
//

import Foundation

protocol RecordedDataViewModelProtocol {
    func fetchShares()
    func deleteShares(share: SavedShareModel?)
    var allRecordedShares: [SavedShareModel]? {get}


}

// MARK: -  RecordedDataViewModelDelegate
protocol  RecordedDataViewModelDelegate {
    func getRecords()

}


class RecordedDataViewModel: RecordedDataViewModelProtocol {

    var delegate: RecordedDataViewModelDelegate?
    private var shareRepository = ShareRepository()
    var allRecordedShares: [SavedShareModel]?
    
    func fetchShares() {
        shareRepository.fetchShares { [weak self] shares in
            guard let self else {return}
            allRecordedShares = shares
            self.delegate?.getRecords()
  
        }
    }
    
    func deleteShares(share: SavedShareModel?) {
        guard let share else {return}
        shareRepository.deleteShare(share: share) { [weak self] in
            guard let self else { return }
            self.fetchShares()
        }
    }
    
}
