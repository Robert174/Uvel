//
//  Constants.swift
//  uvel
//
//  Created by Роберт Райсих on 23/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//

import Foundation
import UIKit

struct AuditColors {
    static let navBarColor = #colorLiteral(red: 0.9725490196, green: 0.968627451, blue: 0.9607843137, alpha: 1)
    static let selectedColor = UIColor.red
    static let notSelectedColor = UIColor.gray
}

struct AuditURL {
    static let schemaURL = "https://test.agentx.napoleonit.ru/api/v1/audit/tasks/196186/schema"
}

struct AuditStoryboards {
    static let audit = UIStoryboard(name: "Audit", bundle: nil)
}

struct AuditConstraints {
    static let horizontalBarIndent = 10
    static let leftIndentOfCV = 20
    static let horizontalBarHeight = 2
    
    static let collectionMinimumInteritemSpacingForSection: CGFloat = 15
    static let collectionCellHeight: CGFloat = 60
    
    static let sizeBetweenScreen = 0
    //TableView
    
    static let heightForRow: CGFloat = 48
    static let heightForSection: CGFloat = 60
}

