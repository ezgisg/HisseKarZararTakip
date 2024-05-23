//
//  DetailViewModel.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 23.05.2024.
//

import Foundation


protocol DetailViewModelProtocol {
    var detailModel: Meta? { get }
    func getShareDetail(selectedShare: String, completion: @escaping (_ detailModel: Meta?) -> ())
}

protocol DetailViewModelDelegate {
}


class DetailViewModel {
    var detailModel: Meta?
    var name: String
    
    init(name: String) {
        self.name = name
    }
    
    func getShareDetail(selectedShare: String, completion: @escaping (_ detailModel: Meta?) -> ()) {
        let urlString = "https://query1.finance.yahoo.com/v8/finance/chart/\(selectedShare).IS?region=US&lang=en-US&includePrePost=false&interval=2m&useYfid=true&range=1d&corsDomain=finance.yahoo.com&.tsrc=finance"
        let service: ShareServiceProtocol? = ShareService()
        service?.fetchServiceData(urlString: urlString, completion: { [weak self] (response: Result<ShareDetailList, Error>) in
            guard let self else { return }
            switch response {
            case .success(let data):
                guard let data = data.chart?.result?.first?.meta else {
                    completion(nil)
                    return  }
                detailModel = data
                detailModel?.name = selectedShare
                completion(detailModel)
            case .failure(_):
                //TODO: Alert
                print("***** Error happened when fetching detail data for \(selectedShare)*****")
                completion(nil)
            }
        })
    }
}
