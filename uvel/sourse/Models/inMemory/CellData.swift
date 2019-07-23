//
//  CellData.swift
//  uvel
//
//  Created by Роберт Райсих on 10/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//

import Foundation




struct SectionObject {
    var opened = Bool()
    var title = String()
    var sectionData = [CellObject]()
}

struct CellObject {
    var opened = Bool()
    var title = String()
    var switchOn = Bool()
}
