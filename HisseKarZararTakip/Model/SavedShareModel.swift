//
//  SavedShareModel.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 16.05.2024.
//

import Foundation

struct SavedShareModel: Decodable, Equatable {
    var name: String?
    var count: Double?
    var price: Double?
    var commission: Double?
    var total: Double?
    var uuid: UUID?
}
