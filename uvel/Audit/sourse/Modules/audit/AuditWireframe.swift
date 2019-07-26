//
//  ProductsWirefare.swift
//  uvel
//
//  Created by Роберт Райсих on 23/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//
import Foundation
import UIKit

class AuditWireframe {
    
    final weak var _initialViewController: UIViewController?
    var initialViewController: UIViewController! {
        get {
            if _initialViewController == nil {
                let mainController = AuditStoryboards.audit.instantiateViewController(withIdentifier: "AuditWrappingViewControllerID") as! AuditWrappingViewController
                _initialViewController = mainController
            }
            
            return _initialViewController
        }
        
        set {
            fatalError()
        }
    }
}
