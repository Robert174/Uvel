//
//  ParseData.swift
//  uvel
//
//  Created by Роберт Райсих on 15/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//

import Foundation

class Response: Decodable {
    var data: Data
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        
        self.data = try container.decode(Data.self, forKey: .data)
    }
}
