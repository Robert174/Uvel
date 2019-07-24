//
//  ParseData.swift
//  uvel
//
//  Created by Роберт Райсих on 15/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//

import Foundation

struct Response: Decodable {
    var data: Data
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        
        self.data = try container.decode(Data.self, forKey: .data)
    }
}

struct Data: Decodable {
    var schema: [Category]
    
    enum CodingKeys: String, CodingKey {
        case schema
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.schema = try container.decode([Category].self, forKey: .schema)
    }
}

struct Category: Decodable {
    var categoryName: String?
    var tradeMarks: [TradeMark]?
    var isChosen: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case categoryName
        case tradeMarks
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.categoryName = try? container.decode(String.self, forKey: .categoryName)
        self.tradeMarks = try? container.decode([TradeMark].self, forKey: .tradeMarks)
    }
}

struct TradeMark: Decodable {
    var tradeMarkName: String?
    var products: [Product]
    var opened: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case tradeMarkName
        case products
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.tradeMarkName = try? container.decode(String.self, forKey: .tradeMarkName)
        self.products = try container.decode([Product].self, forKey: .products)
    }
}

struct Product: Decodable {
    var productName: String?
    var opened: Bool = false
    var switchOn: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case productName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.productName = try? container.decode(String.self, forKey: .productName)
    }
}
