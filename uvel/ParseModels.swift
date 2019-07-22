//
//  ParseModels.swift
//  uvel
//
//  Created by Роберт Райсих on 15/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//

import Foundation

struct Response: Decodable {
    enum CodingKeys: String, CodingKey {
        case items
    }
    let items: [SectionObject]
}
