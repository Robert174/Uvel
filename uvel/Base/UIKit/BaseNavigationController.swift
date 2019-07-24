//
//  BaseNavigationController.swift
//  uvel
//
//  Created by Роберт Райсих on 23/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//

import UIKit

class XBaseNavigationController: UINavigationController {
    
    var pushTime: Date?
    var swipeRestrictedViewControllers = [WeakArrayElement<UIViewController>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        navigationBar.isTranslucent = true
        navigationBar.barTintColor = .navBarColor
        navigationBar.backgroundColor = .navBarColor
    }
    
    func restrictSwipe(for viewController: UIViewController) {
        swipeRestrictedViewControllers.append(WeakArrayElement(value: viewController))
    }
    
    func deRestrictSwipe(for viewController: UIViewController) {
        if let index = swipeRestrictedViewControllers.firstIndex(of: WeakArrayElement(value: viewController)) {
            swipeRestrictedViewControllers.remove(at: index)
        }
    }
    
    func pushViewControllerRestrictedBackGesture(_ viewController: UIViewController, animated: Bool) {
        restrictSwipe(for: viewController)
        pushViewController(viewController, animated: animated)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        guard let topViewController = topViewController else {
            super.pushViewController(viewController, animated: animated)
            return
        }
        if type(of: viewController) == type(of: topViewController), let pushTime = pushTime, Date().timeIntervalSince(pushTime) < 1 {
            return
        }
        
        super.pushViewController(viewController, animated: true)
        pushTime = Date()
        
        if let viewController = viewController as? XBaseViewController {
            let customBackButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_back"), style: .plain, target: viewController, action: XBaseViewController.backTappedSelector)
            customBackButtonItem.tintColor = UIColor.black
            viewController.navigationItem.leftBarButtonItem = customBackButtonItem
        }
        
        navigationBar.isTranslucent = false
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        guard let controller = super.popViewController(animated: animated) else {return nil}
        if let index = swipeRestrictedViewControllers.firstIndex(of: WeakArrayElement(value: controller)) {
            swipeRestrictedViewControllers.remove(at: index)
        }
        return controller
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        guard let controllers = super.popToRootViewController(animated: true) else {return nil}
        controllers.forEach({
            if let index = swipeRestrictedViewControllers.firstIndex(of: WeakArrayElement(value: $0)) {
                swipeRestrictedViewControllers.remove(at: index)
            }
        })
        return controllers
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if let alertPendingToPresent = viewControllerToPresent as? UIAlertController, let alertNowPresenting = presentedViewController as? UIAlertController  {
            alertNowPresenting.dismiss(animated: false) {
                super.present(alertPendingToPresent, animated: flag, completion: completion)
            }
            return
        }
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}

extension XBaseNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let topViewController = topViewController, let pushTime = pushTime else { return false }
        if swipeRestrictedViewControllers.contains(WeakArrayElement(value: topViewController)) || viewControllers.count == 1 || Date().timeIntervalSince(pushTime) < 1 {
            return false
        }
        return true
    }
    
}


final class WeakArrayElement<T: AnyObject> {
    
    weak var value : T?
    
    
    init (value: T) {
        self.value = value
    }
    
}

extension WeakArrayElement: Equatable where T: Equatable {
    
    static func == (lhs: WeakArrayElement, rhs: WeakArrayElement) -> Bool {
        return lhs.value == rhs.value
    }
    
}
