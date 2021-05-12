//
//  Brand.swift
//  Carangas
//
//  Created by Luiz on 5/12/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation

struct Brand: Codable {
    let fipeName: String

    enum CodingKeys: String, CodingKey {
        case fipeName = "fipe_name"
    }
}
