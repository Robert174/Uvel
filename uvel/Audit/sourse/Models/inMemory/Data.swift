//
//  Data.swift
//  uvel
//
//  Created by Роберт Райсих on 26/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//

import Foundation

class Data: Decodable {
    var schema: [Category]
    
    enum CodingKeys: String, CodingKey {
        case schema
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.schema = try container.decode([Category].self, forKey: .schema)
    }
}
