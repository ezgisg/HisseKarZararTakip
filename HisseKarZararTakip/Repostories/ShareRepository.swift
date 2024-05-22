//
//  ShareRepository.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 16.05.2024.
//

import Foundation
import UIKit
import CoreData

enum ShareRepositoryKeys: String {
    case name
    case count
    case price
    case commission
    case total
    case uuid
}

protocol ShareRepositoryProtocol {
    func saveShare(model: SavedShareModel) -> Bool
    func fetchShares(completion: @escaping ([SavedShareModel]?) -> () )
    func deleteShare(shares: [SavedShareModel], completion:  @escaping () -> ())
    func updateShare(shareUUID: UUID, newCount:  Double?, newPrice: Double?, newCommission: Double?, completion: @escaping () -> ())
}

class ShareRepository: ShareRepositoryProtocol {
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var shares = [SavedShareModel]()
    
    func deleteShare(shares: [SavedShareModel], completion: @escaping () -> ()) {
        for share in shares {
            let viewContext = appDelegate?.persistentContainer.viewContext
            guard let viewContext else { return }
            
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "SavedShare")
            guard let uuid = share.uuid as? NSUUID else { return }
            fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid)
            
            do {
                if let results = try viewContext.fetch(fetchRequest) as? [NSManagedObject] {
                    for result in results {
                        viewContext.delete(result)
                    }
                }
            } catch {
                //TODO: Make alert
                print("***** \(share.uuid?.uuidString ?? "unknown uuid") core datadan silinemedi *****")
            }
        }
        completion()
    }
   
    //TODO: saveshare yerine kayıt edilip edilmediğine göre boolean verdiği anlaşılacak bir isim verelim
    func saveShare(model: SavedShareModel) -> Bool {
        let viewContext = appDelegate?.persistentContainer.viewContext
        guard let viewContext else { return false }
        let newShare = NSEntityDescription.insertNewObject(forEntityName: "SavedShare", into: viewContext)
        
        newShare.setValue(model.name, forKey: ShareRepositoryKeys.name.rawValue)
        newShare.setValue(model.count, forKey: ShareRepositoryKeys.count.rawValue)
        newShare.setValue(model.price, forKey: ShareRepositoryKeys.price.rawValue)
        newShare.setValue(model.commission, forKey: ShareRepositoryKeys.commission.rawValue)
        newShare.setValue(model.total, forKey: ShareRepositoryKeys.total.rawValue)
        newShare.setValue(model.uuid, forKey: ShareRepositoryKeys.uuid.rawValue)
        
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
                        guard let name = result.value(forKey: ShareRepositoryKeys.name.rawValue) as? String,
                              let count = result.value(forKey: ShareRepositoryKeys.count.rawValue) as? Double,
                              let price = result.value(forKey: ShareRepositoryKeys.price.rawValue) as? Double,
                              let commission = result.value(forKey: ShareRepositoryKeys.commission.rawValue) as? Double,
                              let total = result.value(forKey: ShareRepositoryKeys.total.rawValue) as? Double,
                              let uuid = result.value(forKey: ShareRepositoryKeys.uuid.rawValue) as? UUID else { return }
                        
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
            //TODO: Alert
            print("***** CoreData dan data çekilemedi *****")
            completion([])
        }
   
    }
    
    func updateShare(shareUUID: UUID, newCount: Double?, newPrice: Double?, newCommission: Double?, completion: @escaping () -> ()) {
        
        let viewContext = appDelegate?.persistentContainer.viewContext
        guard let viewContext else { return }
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "SavedShare")
        let uuid = shareUUID as NSUUID
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid)
        
        do {
               let results = try viewContext.fetch(fetchRequest) as? [NSManagedObject]
               guard let result = results?.first else { return }
            
                if let newCount {
                    result.setValue(newCount, forKey: "count")
                }
                if let newPrice {
                    result.setValue(newPrice, forKey: "price")
                }
                if let newCommission {
                    result.setValue(newCommission, forKey: "commission")
                }
                
                let currentPrice = result.value(forKey:"price") as? Double
                let currentCount = result.value(forKey:"count") as? Double
                let currentCommission = result.value(forKey:"commission") as? Double
                
                guard let currentPrice,
                      let currentCount,
                      let currentCommission else {return}
                
                let total = currentPrice * currentCount + currentCommission
                
                result.setValue(total, forKey: "total")
            
            completion()
            
        } catch  {
            //TODO: Make alert
            print("***** \(uuid) uuidli elemanda core datada değişiklik yapılamadı *****")
            completion()
        }

 
    }
    
}
