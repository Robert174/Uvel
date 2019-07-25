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
    
    let selectedIndexPath = NSIndexPath(item: 0, section: 0)
    var refreshDataHandler: (() -> Void)?
    var cellWidthHandler: (() -> Void)?
    var calculateSizeHandler: ((_ id: Int, _ coord: Int) -> Void)?
    
    var cellWidth = [Int]() {
        didSet {
            cellWidthHandler?()
        }
    }
    var response: Response! {
        didSet {
            refreshDataHandler?()
            initCellWidth()
        }
    }
    var coordX: Int = 15
}

extension AuditViewModel {
    
    func getData() {
        AuditInteractor().getSchema { (response) in
            self.response = response
        }
    }
    
    func initCellWidth() {
        for i in 0 ... response.data.schema.count - 1 {
            cellWidth.append(response.data.schema[i].categoryName!.count * 8 + 40)
        }
    }
}

extension AuditViewModel {
    
    func updateLabelFrame(label: UILabel) {
        let maxSize = CGSize(width: 300, height: 40)
        let size = label.sizeThatFits(maxSize)
        label.frame = CGRect(origin: CGPoint(x: 0, y: 20), size: size)
    }
    
    func calculateSize(id: Int) {
        var x = 15
        if id != 0 {
            for i in 0 ... id - 1 {
                x += cellWidth[i]
            }
            coordX = x
        } else {
            coordX = 15
        }
        calculateSizeHandler?(id, coordX)
    }
    
}
