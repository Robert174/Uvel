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
            categories = self.response.data.schema
        }
    }
    var categories = [Category]()
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
    
    func getCategoriesName() -> [String] {
        var categoriesNameArray: [String] = []
        response.data.schema.enumerated().forEach({
            if let categoryName = $0.element.categoryName {
                categoriesNameArray.append(categoryName)
            }
        })
        return categoriesNameArray
    }
    
    func getCountOfCategories() -> Int {
        return categories.count
    }
    
    func getCountOfTradeMarksInCategory(with number: Int) -> Int {
        return response.data.schema[number].tradeMarks!.count
    }
    
    func getTradeMark(InCategory category: Int, InSection section: Int) -> TradeMark {
        return response.data.schema[category].tradeMarks![section]
    }
    
    func getProduct(inCategory category: Int, inSection section: Int, inRow row: Int) -> Product {
        return categories[category].tradeMarks![section].products[row]
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
