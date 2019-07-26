//
//  Product.swift
//  uvel
//
//  Created by Роберт Райсих on 26/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//

import Foundation

class Product: Decodable {
    var productName: String?
    var opened: Bool = false
    var switchOn: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case productName
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.productName = try? container.decode(String.self, forKey: .productName)
    }
}
