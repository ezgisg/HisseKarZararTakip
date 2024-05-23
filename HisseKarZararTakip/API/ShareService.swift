//
//  ShareService.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 15.05.2024.
//

import Foundation
import Alamofire

protocol ShareServiceProtocol {
    func fetchServiceData<T:Decodable>(urlString: String, completion: @escaping (Result<T,Error>) -> Void)
}

class ShareService: ShareServiceProtocol {
    func fetchServiceData<T>(urlString: String, completion: @escaping (Result<T, any Error>) -> Void) where T : Decodable {
        AF.request(urlString).responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let dataResponse =  try decoder.decode(T.self, from: data)
                    completion(.success(dataResponse))
                } catch {
                    //TODO: ALERT
                    let error = response.error
                    print("*****JSON DECODE ERROR \(String(describing: error))*****")
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
 
}
