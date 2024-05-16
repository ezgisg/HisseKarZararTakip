//
//  ShareList.swift
//  HisseKarZararTakip
//
//  Created by Ezgi Sümer Günaydın on 15.05.2024.
//

import Foundation

struct ShareList: Decodable {
    let code: String?
    let data: [ShareNameData]?
}


struct ShareNameData: Decodable {
    let id: Int?
    let kod: String?
    let ad: String?
}
