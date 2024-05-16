//
//  DataShowViewModel.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 16.05.2024.
//

import Foundation

protocol DataShowViewModelProtocol {
    func fetchShares() -> [SavedShareModel]?
    var recordedShares: [SavedShareModel]? {get}
}

protocol DataShowViewModelDelegate {
    
}

class DataShowViewModel: DataShowViewModelProtocol {

    var recordedShares: [SavedShareModel]?

    var delegate: DataShowViewModelDelegate?
    
    private var shareRepository = ShareRepository()

    func fetchShares() -> [SavedShareModel]? {
     recordedShares = shareRepository.fetchShares()
     return recordedShares
    }
    
}
