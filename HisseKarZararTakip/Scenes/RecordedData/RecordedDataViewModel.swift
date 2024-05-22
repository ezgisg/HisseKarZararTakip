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
    func updateShare(uuid: UUID, newCount: Double?, newPrice: Double?, newCommission: Double? )
    func controlSelectedCountandChangeButtonStatus(count: Int, completion: (_ isEditButtonEnabled: Bool, _ isDeleteButtonEnabled: Bool) -> ())
    func filterRecords(searchText: String?)
    var allRecordedShares: [SavedShareModel]? {get}
    var filteredRecordedShares: [SavedShareModel]? {get}
    
}

// MARK: -  RecordedDataViewModelDelegate
protocol  RecordedDataViewModelDelegate {
    func getRecords()
    func reloadCollectionView()
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
            filteredRecordedShares = allRecordedShares
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
    
    func updateShare(uuid: UUID, newCount: Double?, newPrice: Double?, newCommission: Double?) {
        shareRepository.updateShare(shareUUID: uuid, newCount: newCount, newPrice: newPrice, newCommission: newCommission) { [weak self] model in
            guard let self else { return }
            guard let model, let changedElementUUID = model.uuid else { return }
            if let index = self.filteredRecordedShares?.firstIndex(where: { $0.uuid == changedElementUUID }) {
                    self.filteredRecordedShares?[index] = model
                }
            if let index = self.allRecordedShares?.firstIndex(where: { $0.uuid == changedElementUUID }) {
                    self.allRecordedShares?[index] = model
                }
            delegate?.reloadCollectionView()
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
            if filteredRecordedShares != allRecordedShares {
                filteredRecordedShares = allRecordedShares
                delegate?.getRecords()
            }
        }
    }
}


