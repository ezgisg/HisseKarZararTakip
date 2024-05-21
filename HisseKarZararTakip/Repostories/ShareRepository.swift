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
    func deleteShare(share: SavedShareModel, completion:  @escaping () -> ())
}


class ShareRepository: ShareRepositoryProtocol {
    func deleteShare(share: SavedShareModel, completion: @escaping () -> ()) {
        let viewContext = appDelegate?.persistentContainer.viewContext
        guard let viewContext else {return}
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "SavedShare")
        guard let uuid = share.uuid as? NSUUID else {return}
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid)
        
        do {
            if let results = try viewContext.fetch(fetchRequest) as? [NSManagedObject] {
                for result in results {
                    viewContext.delete(result)
                }
                completion()
            }
        
        } catch {
            //TO DO: Make alert
            print("***** \(share.uuid?.uuidString ?? "unknown uuid") core datadan silinemedi *****")
            completion()
        }
        
    }
    
    
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
        newShare.setValue(model.uuid, forKey: "uuid")
        
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
        shares.removeAll(keepingCapacity: false)
        
        let viewContext = appDelegate?.persistentContainer.viewContext
        guard let viewContext else { return }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedShare")
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            if results.count > 0 {
                for result in results {
                    if let result = result as? NSManagedObject {
                        guard let name = result.value(forKey: "name") as? String,
                              let count = result.value(forKey: "count") as? Double,
                              let price = result.value(forKey: "price") as? Double,
                              let commission = result.value(forKey: "commission") as? Double,
                              let total = result.value(forKey: "total") as? Double,
                              let uuid = result.value(forKey: "uuid") as? UUID else { return }
                        
                        let share = SavedShareModel(name: name, count: count, price: price, commission: commission, total: total, uuid: uuid)
                        shares.append(share)
                    } else {
                        completion([])
                    }
                }
                completion(shares)
            } else {
                completion([])
            }
   
        } catch  {
            //TO DO: Alert
            print("***** CoreData dan data çekilemedi *****")
            completion([])
        }
   
    }
    
}
