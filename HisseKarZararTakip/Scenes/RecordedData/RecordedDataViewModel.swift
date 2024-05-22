//
//  RecordedDataViewModel.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 21.05.2024.
//

import Foundation

protocol RecordedDataViewModelProtocol {
    func fetchShares()
    func deleteShares(shares: [SavedShareModel]?)
    func controlSelectedCountandChangeButtonStatus(count: Int, completion: (_ isEditButtonEnabled: Bool, _ isDeleteButtonEnabled: Bool) -> ())
    func filterRecords(searchText: String?)
    var allRecordedShares: [SavedShareModel]? {get}
    var filteredRecordedShares: [SavedShareModel]? {get}
    
}

// MARK: -  RecordedDataViewModelDelegate
protocol  RecordedDataViewModelDelegate {
    func getRecords()
    func filterRecords()
}


class RecordedDataViewModel: RecordedDataViewModelProtocol {

    var delegate: RecordedDataViewModelDelegate?
    private var shareRepository = ShareRepository()
    var allRecordedShares: [SavedShareModel]?
    var filteredRecordedShares: [SavedShareModel]?
    
    func fetchShares() {
        shareRepository.fetchShares { [weak self] shares in
            guard let self else {return}
            allRecordedShares = shares
            filteredRecordedShares = shares
            delegate?.getRecords()
  
        }
    }
    
    func deleteShares(shares: [SavedShareModel]? ) {
        guard let shares else {return}
        shareRepository.deleteShare(shares: shares) { [weak self] in
            guard let self else { return }
            self.fetchShares()
        }
    }
    
    func controlSelectedCountandChangeButtonStatus(count: Int, completion: (Bool, Bool) -> ()) {
            if count == 1  {
               completion(true, true)
            } else if count > 1 {
                completion(false, true)
            }
            else {
                completion(false, false)
            }
    }
    
    
    func filterRecords(searchText: String?) {
        if (searchText?.count ?? 0) > 3 {
            filteredRecordedShares = allRecordedShares?.filter { share in
                return share.name?.lowercased().contains(searchText?.lowercased() ?? "") ?? false
            }
            delegate?.getRecords()
        } else {
            filteredRecordedShares = allRecordedShares
            delegate?.filterRecords()
        }
    }
}
