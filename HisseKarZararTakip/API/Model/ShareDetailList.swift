//
//  ShareDetailList.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 15.05.2024.
//

import Foundation

// MARK: - ShareDetailList
struct ShareDetailList: Codable {
    let chart: Chart?
}

// MARK: - Chart
struct Chart: Codable {
    let result: [ShareDetail]?
}

// MARK: - Result
struct ShareDetail: Codable {
    let meta: Meta?
    let timestamp: [Int]?
    let indicators: Indicators?
}

// MARK: - Indicators
struct Indicators: Codable {
    let quote: [Quote]?
}

// MARK: - Quote
struct Quote: Codable {
    let close, low, quoteOpen: [Double?]
    let volume: [Int?]
    let high: [Double?]

    enum CodingKeys: String, CodingKey {
        case close, low
        case quoteOpen = "open"
        case volume, high
    }
}

// MARK: - Meta
struct Meta: Codable {
    let regularMarketPrice: Double?

}
