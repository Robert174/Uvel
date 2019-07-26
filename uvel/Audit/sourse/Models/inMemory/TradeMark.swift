//
//  TradeMark.swift
//  uvel
//
//  Created by Роберт Райсих on 26/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//

import Foundation

class TradeMark: Decodable {
    var tradeMarkName: String?
    var products: [Product]
    var opened: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case tradeMarkName
        case products
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.tradeMarkName = try? container.decode(String.self, forKey: .tradeMarkName)
        self.products = try container.decode([Product].self, forKey: .products)
    }
}
