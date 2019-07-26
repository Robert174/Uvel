//
//  Category.swift
//  uvel
//
//  Created by Роберт Райсих on 26/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//

import Foundation

class Category: Decodable {
    var categoryName: String?
    var tradeMarks: [TradeMark]?
    var isChosen: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case categoryName
        case tradeMarks
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.categoryName = try? container.decode(String.self, forKey: .categoryName)
        self.tradeMarks = try? container.decode([TradeMark].self, forKey: .tradeMarks)
    }
}
