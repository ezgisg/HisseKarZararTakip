//
//  DataShowViewModel.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 16.05.2024.
//

import Foundation

protocol DataShowViewModelProtocol {
    func fetchShares()
    var recordedShares: [SavedShareModel]? {get}
  
}

protocol DataShowViewModelDelegate {
    func getShares()
}

class DataShowViewModel: DataShowViewModelProtocol {

  
    var recordedShares: [SavedShareModel]?
    var delegate: DataShowViewModelDelegate?
    private var shareRepository = ShareRepository()

    func fetchShares() {
        shareRepository.fetchShares { shares in
            self.recordedShares = shares
            self.delegate?.getShares()
        }
    }


    
}
