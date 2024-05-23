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
    // MARK: - Fetched Parameters
    let firstTradeDate: Int?
    let regularMarketPrice: Double?
    let regularMarketDayHigh: Double?
    let regularMarketDayLow: Double?
    let previousClose: Double?
    
    // MARK: - Init
    init(
        firstTradeDate: Int? = nil,
        regularMarketPrice: Double? = nil,
        regularMarketDayHigh: Double? = nil,
        regularMarketDayLow: Double? = nil,
        previousClose: Double? = nil
    ) {
        self.firstTradeDate = firstTradeDate
        self.regularMarketPrice = regularMarketPrice
        self.regularMarketDayHigh = regularMarketDayHigh
        self.regularMarketDayLow = regularMarketDayLow
        self.previousClose = previousClose
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.firstTradeDate = try container.decodeIfPresent(Int.self, forKey: .firstTradeDate)
        self.regularMarketPrice = try container.decodeIfPresent(Double.self, forKey: .regularMarketPrice)
        self.regularMarketDayHigh = try container.decodeIfPresent(Double.self, forKey: .regularMarketDayHigh)
        self.regularMarketDayLow = try container.decodeIfPresent(Double.self, forKey: .regularMarketDayLow)
        self.previousClose = try container.decodeIfPresent(Double.self, forKey: .previousClose)
        self.firstTradeDateString = try container.decodeIfPresent(String.self, forKey: .firstTradeDateString)

        guard let firstTradeDate else {
            firstTradeDateString = nil
            return }
        var firstDate = Date(timeIntervalSince1970: TimeInterval(firstTradeDate))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let newDateString = dateFormatter.string(from: firstDate)
        let newDate = dateFormatter.date(from: newDateString)
        firstTradeDateString = newDateString
    }
    
    // MARK: - Custom Parameters
    var name: String?
    var firstTradeDateString: String?
}
