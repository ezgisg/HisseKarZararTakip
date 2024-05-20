//
//  TotalShareModel.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 20.05.2024.
//

import Foundation

struct TotalShareModel: Decodable {
    var name: String?
    var count: Double?
    var avgPrice: Double?
    var currentPrice: Double?
    var commission: Double?
    var total: Double?
}
