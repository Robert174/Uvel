//
//  AuditInteractor.swift
//  uvel
//
//  Created by Роберт Райсих on 23/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//

import Foundation
import Alamofire

class AuditInteractor {
    
    var wireframe: AuditWireframe?
    let headers = ["device": "mobile", "x-token": "test_2196", "Content-Type": "application/json" ]
    
    func getSchema(completion: @escaping (_ response: Response?) -> Void) {
        Alamofire.request(AuditURL.schemaURL, method: .get, headers: headers).responseJSON {
            response in
            if response.result.isSuccess {
                let result: Response = try! JSONDecoder().decode(Response.self, from: response.data!)
                completion(result)
            }
            else {
                print(response.result.error!)
            }
        }
    }
}
