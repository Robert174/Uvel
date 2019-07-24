//
//  ProductsWirefare.swift
//  uvel
//
//  Created by Роберт Райсих on 23/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//
import Foundation
import UIKit

class ProductsWireframe {
    
    final weak var _initialViewController: UIViewController?
    var initialViewController: UIViewController! {
        get {
            if _initialViewController == nil {
                let mainController = AuditStoryboards.audit.instantiateViewController(withIdentifier: "mainViewController") as! MainViewController
                _initialViewController = mainController
            }
            
            return _initialViewController
        }
        
        set {
            fatalError()
        }
    }
    
    final weak var _interactor: AnyObject?
    var interactor: Any? {
        get {
            if _interactor == nil {
                let interactor = ProductsInteractor()
                interactor.wireframe = self
                _interactor = interactor
            }
            return _interactor
        }
        
        set {
            fatalError()
        }
    }
    
    
    
}
