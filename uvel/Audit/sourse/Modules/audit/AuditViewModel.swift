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
    var coordX: Int = AuditConstraints.leftIndentOfCV
    var lastId: Int = 0
    var filteredSearchData: [String]!
    // AuditPageViewController vars
    
    
    
    //AuditVCForTable vars
    

    
}

//AuditWrapperViewController functions

extension AuditViewModel {
    
    func getData() {
        AuditInteractor().getSchema { (response) in
            self.response = response
        }
    }
    
    func calculateSize(id: Int, cellWidthArr: [CGFloat]) {
        var x = AuditConstraints.leftIndentOfCV
        if id != 0 {
            for i in 0 ... id - 1 {
                x += Int(cellWidthArr[i] + AuditConstraints.collectionMinimumInteritemSpacingForSection)
            }
            coordX = x
        } else {
            coordX = AuditConstraints.leftIndentOfCV
        }
    }
    
    
}

// AuditPageController functions

extension AuditViewModel {
    
    
}
