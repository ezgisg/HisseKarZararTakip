//
//  RecordedDataViewModel.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 21.05.2024.
//

import Foundation

protocol RecordedDataViewModelProtocol {
    func getAllShares()
    func getAllSharesAfterUpdateShare()
    func deleteShares(shares: [SavedShareModel]?)
    func updateShare(uuid: UUID, newCount: Double?, newPrice: Double?, newCommission: Double? )
    func controlSelectedCountandChangeButtonStatus(count: Int, completion: (ButtonStatusModel) -> ())
    func filterRecordsWithWhenSearchTextChanged(searchText: String?)
    func filterAfterUpdateShare(searchText: String?)
    var allRecordedShares: [SavedShareModel]? {get}
    var filteredRecordedShares: [SavedShareModel]? {get}
    
}

// MARK: -  RecordedDataViewModelDelegate
protocol  RecordedDataViewModelDelegate {
    func getRecords()
    func reloadCollectionView()
    func filterWithSearchText()

}


class RecordedDataViewModel: RecordedDataViewModelProtocol {

    var delegate: RecordedDataViewModelDelegate?
    private var shareRepository = ShareRepository()
    var allRecordedShares: [SavedShareModel]?
    var filteredRecordedShares: [SavedShareModel]?
    
    func getAllShares() {
        shareRepository.fetchShares { [weak self] shares in
            guard let self else {return}
            allRecordedShares = shares
            filteredRecordedShares = allRecordedShares
            delegate?.getRecords()
            delegate?.filterWithSearchText()
        }
    }
    
    func deleteShares(shares: [SavedShareModel]? ) {
        guard let shares else {return}
        shareRepository.deleteShare(shares: shares) { [weak self] in
            guard let self else { return }
            self.getAllShares()
        }
    }
    
    func updateShare(uuid: UUID, newCount: Double?, newPrice: Double?, newCommission: Double?) {
        shareRepository.updateShare(shareUUID: uuid, newCount: newCount, newPrice: newPrice, newCommission: newCommission) { [weak self] in
            guard let self else {return}
            self.getAllSharesAfterUpdateShare()
        }
    }
    
    func getAllSharesAfterUpdateShare() {
        shareRepository.fetchShares { [weak self] shares in
            guard let self else {return}
            allRecordedShares = shares
            delegate?.filterWithSearchText()
        }
    }
    
    func controlSelectedCountandChangeButtonStatus(count: Int, completion: (ButtonStatusModel) -> ()) {
        var buttonStatus = ButtonStatusModel()
        if count == 1  {
            buttonStatus.isDeleteButtonEnabled = true
            buttonStatus.isEditButtonEnabled = true
        } else if count > 1 {
            buttonStatus.isDeleteButtonEnabled = true
            buttonStatus.isEditButtonEnabled = false
        }
        else {
            buttonStatus.isDeleteButtonEnabled = false
            buttonStatus.isEditButtonEnabled = false
        }
        completion(buttonStatus)
    }
    
    func filterRecordsWithWhenSearchTextChanged(searchText: String?) {
        if (searchText?.count ?? 0) > 3 {
            filteredRecordedShares = allRecordedShares?.filter { share in
                return share.name?.lowercased().contains(searchText?.lowercased() ?? "") ?? false
            }
            delegate?.getRecords()
        } else {
            if filteredRecordedShares != allRecordedShares {
                filteredRecordedShares = allRecordedShares
                delegate?.getRecords()
            }
        }
    }
    
    func filterAfterUpdateShare(searchText: String?) {
        guard searchText != "",
        let searchText else {
            filteredRecordedShares = allRecordedShares
            delegate?.reloadCollectionView()
            return
        }
        filteredRecordedShares = allRecordedShares?.filter { share in
            return share.name?.lowercased().contains(searchText.lowercased()) ?? false
        }
        delegate?.reloadCollectionView()
    }
    
    
}
