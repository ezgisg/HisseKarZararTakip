//
//  RecordedDataViewModel.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 21.05.2024.
//

import Foundation

protocol RecordedDataViewModelProtocol {
    var allRecordedShares: [SavedShareModel]? { get }
    var filteredRecordedShares: [SavedShareModel]? { get }
    
    func getShares(willSelectClear: Bool)
    func deleteShares(shares: [SavedShareModel]?)
    func updateShare(uuid: UUID, newCount: Double?, newPrice: Double?, newCommission: Double? )
    func controlSelectedCountandChangeButtonStatus(count: Int, completion: (ButtonStatusModel) -> ())
    func filterRecordsWithWhenSearchTextChanged(searchText: String?)
    func filterAfterUpdateShare(searchText: String?)
}

// MARK: -  RecordedDataViewModelDelegate
protocol  RecordedDataViewModelDelegate {
    func reloadView()
    func reloadCollectionView()
    func filterWithSearchText()
}

// MARK: - RecordedDataViewModel
class RecordedDataViewModel: RecordedDataViewModelProtocol {
    /// MARK: -  private variables
    private var shareRepository = ShareRepository()
    
    /// MARK: -  variables
    var delegate: RecordedDataViewModelDelegate?
    var allRecordedShares: [SavedShareModel]?
    var filteredRecordedShares: [SavedShareModel]?
    
    func deleteShares(shares: [SavedShareModel]? ) {
        guard let shares else {return}
        shareRepository.deleteShare(shares: shares) { [weak self] in
            guard let self else { return }
            self.getShares(willSelectClear: true)
        }
    }
    
    func updateShare(uuid: UUID, newCount: Double?, newPrice: Double?, newCommission: Double?) {
        shareRepository.updateShare(shareUUID: uuid, newCount: newCount, newPrice: newPrice, newCommission: newCommission) { [weak self] in
            guard let self else {return}
            self.getShares(willSelectClear: false)
        }
    }

    func getShares(willSelectClear: Bool) {
        shareRepository.fetchShares { [weak self] shares in
            guard let self else {return}
            allRecordedShares = shares
            if willSelectClear {
                filteredRecordedShares = allRecordedShares
                delegate?.reloadView()
            }
            delegate?.filterWithSearchText()
        }
    }
    
    func controlSelectedCountandChangeButtonStatus(count: Int, completion: (ButtonStatusModel) -> ()) {
        var buttonStatus = ButtonStatusModel()
        
        buttonStatus.isDeleteButtonEnabled = count == 1 || count > 1
        buttonStatus.isEditButtonEnabled = count == 1
        
        completion(buttonStatus)
    }
    
    func filterRecordsWithWhenSearchTextChanged(searchText: String?) {
        if (searchText?.count ?? 0) > 3 {
            filteredRecordedShares = allRecordedShares?.filter { share in
                return share.name?.lowercased().contains(searchText?.lowercased() ?? "") ?? false
            }
            delegate?.reloadView()
        } else if filteredRecordedShares != allRecordedShares {
            filteredRecordedShares = allRecordedShares
            delegate?.reloadView()
        }
    }
    
    func filterAfterUpdateShare(searchText: String?) {
        guard let searchText,
              !searchText.isEmpty else {
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
