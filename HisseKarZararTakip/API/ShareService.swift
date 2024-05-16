//
//  ShareService.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 15.05.2024.
//

import Foundation
import Alamofire

protocol ShareServiceProtocol {
    func fetchData<T:Decodable>(urlString: String, completion: @escaping (Result<T,Error>) -> Void)
}

class ShareService: ShareServiceProtocol {
    func fetchData<T>(urlString: String, completion: @escaping (Result<T, any Error>) -> Void) where T : Decodable {
        AF.request(urlString).responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    let dataResponse =  try decoder.decode(T.self, from: data)
                    completion(.success(dataResponse))
                } catch  {
                    //TO DO: ALERT
                    print("*****JSON DECODE ERROR*****")
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
 
}
