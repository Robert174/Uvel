//
//  AuditViewModel.swift
//  uvel
//
//  Created by Роберт Райсих on 24/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//

import Foundation
import UIKit

class AuditViewModel {
    
    // AuditWrapperViewController vars
    
    let selectedIndexPath = NSIndexPath(item: 0, section: 0)
    var calculateSizeHandler: ((_ id: Int, _ coord: Int) -> Void)?
    var getDataHandler: ((_ response: Response) -> Void)?
    
    var response: Response! {
        didSet {
            getDataHandler?(response)
        }
    }
    var coordX: Int = 15
    
    // AuditPageViewController vars
    
    var controllers = [AuditVCForTable]()
}

//AuditWrapperViewController functions

extension AuditViewModel {
    
    func getData() {
        AuditInteractor().getSchema { (response) in
            self.response = response
        }
    }
    
    
    
}

// AuditPageController functions

extension AuditViewModel {
    
    
}
