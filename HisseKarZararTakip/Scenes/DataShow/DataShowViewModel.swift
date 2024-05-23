//
//  DataShowViewModel.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 16.05.2024.
//

import Foundation

protocol DataShowViewModelProtocol {
    func fetchShares(completion: @escaping ([String]) -> ())
    func getShareCurrentPrice(recordedShare: String, completion: @escaping (Double?) -> ())
    func calculateTotal()
    var allRecordedShares: [SavedShareModel] {get}
    var sumRecordedShares: [TotalShareModel] {get}
    var recordedSharesNames: Set<String> {get set}
    
  
}

protocol DataShowViewModelDelegate {
    func getShares()
}

class DataShowViewModel: DataShowViewModelProtocol {
    var allRecordedShares: [SavedShareModel] = []
    var recordedSharesNames = Set<String>()
    var sumRecordedShares: [TotalShareModel] = []
    var service: ShareServiceProtocol = ShareService()
    var delegate: DataShowViewModelDelegate?
    private var shareRepository: ShareRepositoryProtocol = ShareRepository()
    
    func fetchShares(completion: @escaping ([String]) -> ()) {
        recordedSharesNames.removeAll(keepingCapacity: false)
        shareRepository.fetchShares { [weak self] shares in
            guard let self,
                  let shares else {return}
            allRecordedShares = shares
            for record in allRecordedShares {
                guard let recordName = record.name else {return}
                self.recordedSharesNames.insert(recordName)
            }
            
            let recordedSharesNamesArray = Array(recordedSharesNames).sorted()
            completion(recordedSharesNamesArray)
        }
    }
    
    func calculateTotal() {
        sumRecordedShares.removeAll(keepingCapacity: false)
    
        fetchShares { recordedSharesNamesArray in
            
            let group = DispatchGroup()
            
            for recordedName in recordedSharesNamesArray {
                var sumRecordedShare: TotalShareModel = TotalShareModel()
                for record in self.allRecordedShares {
                    if record.name == recordedName {
                        sumRecordedShare.name = record.name
                        sumRecordedShare.count = (sumRecordedShare.count ?? 0) + (record.count ?? 0)
                        sumRecordedShare.total = (sumRecordedShare.total ?? 0) + (record.total ?? 0)
                        sumRecordedShare.commission = (sumRecordedShare.commission ?? 0) + (record.commission ?? 0)
                    }
                }
                sumRecordedShare.avgPrice = (sumRecordedShare.total ?? 0) /  (sumRecordedShare.count ?? 0)
                
                group.enter()
                self.getShareCurrentPrice(recordedShare: recordedName) { currentPrice in
                    sumRecordedShare.currentPrice = currentPrice
                    self.sumRecordedShares.append(sumRecordedShare)
                    group.leave()
                }
    
            }
   
            group.notify(queue: .main) {
                self.sumRecordedShares.sort {
                         guard let name1 = $0.name, let name2 = $1.name else {
                             return $0.name != nil
                         }
                         return name1 < name2
                     }
                 self.delegate?.getShares()
             }
        }
        
    }
    
    
    func getShareCurrentPrice(recordedShare: String, completion: @escaping (Double?) -> ()) {
        let shareName = recordedShare
        let urlString = "https://query1.finance.yahoo.com/v8/finance/chart/\(shareName).IS?region=US&lang=en-US&includePrePost=false&interval=2m&useYfid=true&range=1d&corsDomain=finance.yahoo.com&.tsrc=finance"
        let service: ShareServiceProtocol? = ShareService()
        service?.fetchServiceData(urlString: urlString, completion: { (response: Result<ShareDetailList, Error>) in
            switch response {
            case .success(let data):
                guard let data = data.chart?.result?[0].meta?.regularMarketPrice else {return completion(0)}
               completion(data)
            case .failure(_):
                //TODO: Alert
                completion(0)
                print("***** Error happened when fetching price service data for \(shareName)*****")
            }
        })
        
  

    }

}

