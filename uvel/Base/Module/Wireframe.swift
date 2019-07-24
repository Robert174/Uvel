//
//  Wireframe.swift
//  uvel
//
//  Created by Роберт Райсих on 23/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//

import Foundation
import UIKit

class XWireframe {
    
    final weak var _initialViewController: UIViewController?
    var initialViewController: UIViewController! {
        get {
            fatalError()
        }
        
        set {
            fatalError()
        }
    }
    
    final weak var _interactor: AnyObject?
    var interactor: Any? {
        get {
            fatalError()
        }
        
        set {
            fatalError()
        }
    }
    
    // MARK: - present & dismiss
    
    weak var transitioningDelegate: UIViewControllerTransitioningDelegate?
    
    func present(in controller: UIViewController?, wrappedInNavigation: Bool, withoutNavBar: Bool, completion: (() -> Void)?) {
        guard let controller = controller else {return}
        if wrappedInNavigation == true {
            let nc = XBaseNavigationController(rootViewController: initialViewController)
            nc.navigationBar.isTranslucent = false
            nc.transitioningDelegate = transitioningDelegate
            nc.setNavigationBarHidden(withoutNavBar, animated: false)
            controller.present(nc, animated: true, completion: completion)
            return
        }
        self.initialViewController.transitioningDelegate = transitioningDelegate
        controller.present(self.initialViewController, animated: true, completion: completion)
    }
    
    var externalNavigationController: UINavigationController?
    
    func push(in navigationController: UINavigationController?, restrictBackGesture: Bool) {
        externalNavigationController = navigationController
        guard let navigationController = navigationController as? XBaseNavigationController else { return }
        restrictBackGesture ? navigationController.pushViewControllerRestrictedBackGesture(initialViewController, animated: true) : navigationController.pushViewController(initialViewController, animated: true)
    }
    
    var dismissHandler: (() -> Void)?
    
    func dismiss(handler: (() -> Void)? = nil) {
        if externalNavigationController != nil {
            if let nc = initialViewController.navigationController, let indexToPop = nc.viewControllers.firstIndex(of: initialViewController) {
                let vcToPop = nc.viewControllers[indexToPop - 1]
                nc.popToViewController(vcToPop, animated: true)
            }
            (handler ?? dismissHandler)?()
        } else {
            (self.initialViewController.navigationController ?? self.initialViewController).dismiss(animated: true, completion: handler ?? dismissHandler)
        }
    }
}

