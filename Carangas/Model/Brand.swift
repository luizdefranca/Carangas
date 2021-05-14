//  Brand.swift
//  Carangas
//

import Foundation

struct Brand: Codable {
    let fipeName: String

    enum CodingKeys: String, CodingKey {
        case fipeName = "fipe_name"
    }
}
