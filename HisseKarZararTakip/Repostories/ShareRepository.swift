//
//  ShareRepository.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 16.05.2024.
//

import Foundation
import UIKit
import CoreData

protocol ShareRepositoryProtocol {
    func saveShare(model: SavedShareModel) -> Bool
    func fetchShares(completion: @escaping ([SavedShareModel]?) -> () )
}


class ShareRepository: ShareRepositoryProtocol {
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var shares = [SavedShareModel]()
   
    func saveShare(model: SavedShareModel) -> Bool {
        let viewContext = appDelegate?.persistentContainer.viewContext
        guard let viewContext else {return false}
        let newShare = NSEntityDescription.insertNewObject(forEntityName: "SavedShare", into: viewContext)
        
        newShare.setValue(model.name, forKey: "name")
        newShare.setValue(model.count, forKey: "count")
        newShare.setValue(model.price, forKey: "price")
        newShare.setValue(model.commission, forKey: "commission")
        newShare.setValue(model.total, forKey: "total")
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
                print("***** Data core dataya kaydedildi *****")
                return true
            } catch  {
                print("***** Core Data ya kaydedilemedi*****")
                return false
            }
        }
        
        return false
        
    }
    
    func fetchShares(completion: @escaping ([SavedShareModel]?) -> ()) {
        let viewContext = appDelegate?.persistentContainer.viewContext
        guard let viewContext else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedShare")
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            if results.count > 0 {
                for result in results {
                    if let result = result as? NSManagedObject {
                        guard let name = result.value(forKey: "name") as? String else {return}
                        guard let count = result.value(forKey: "count") as? Double else {return}
                        guard let price = result.value(forKey: "price") as? Double else {return}
                        guard let commission = result.value(forKey: "commission") as? Double else {return}
                        guard let total = result.value(forKey: "total") as? Double else {return}
                        
                        let share = SavedShareModel(name: name, count: count, price: price, commission: commission, total: total)
                        shares.append(share)
                    }
                }
                completion(shares)
            }
   
        } catch  {
            //TO DO: Alert
            print("***** CoreData dan data çekilemedi *****")
            
        }
   
    }
    
}
