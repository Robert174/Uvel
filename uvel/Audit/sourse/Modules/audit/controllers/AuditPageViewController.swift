//
//  AuditPageViewController.swift
//  uvel
//
//  Created by Роберт Райсих on 16/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//

import UIKit

protocol swipePCDelegate {
    func didSwiped(id: Int)
}

class AuditPageViewController: UIPageViewController {
    
    var categoryIndex = Int()
    var currentIndex = 0
    var controllers = [AuditVCForTable]()
    var delegate1: swipePCDelegate?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width + 40, height: self.view.frame.height)
    }
    
    func setControllers(count: Int, viewModel: AuditViewModel) {
        for i in 0 ... count - 1 {
            let controller = self.initController(index: i, viewModel: viewModel)
            self.controllers.append(controller)
        }
        self.setViewControllers([self.controllers.first!], direction: .forward, animated: true, completion: nil)
    }
    
    func initController(index: Int, viewModel: AuditViewModel) -> AuditVCForTable {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AuditVCForTableID") as! AuditVCForTable
        controller.categoryIndex = index
        controller.viewModel = viewModel
        
        return controller
    }
}

extension AuditPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ AuditPageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentController = viewControllers?.first! as! AuditVCForTable? {
            delegate1?.didSwiped(id: currentController.categoryIndex)
        }
        
    }
}

extension AuditPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ AuditPageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let prevCategoryIndex = (viewController as! AuditVCForTable).categoryIndex - 1
        if prevCategoryIndex >= 0 {
            currentIndex = controllers[prevCategoryIndex].categoryIndex
            return controllers[prevCategoryIndex]
        }
        return nil
    }
    
    func pageViewController(_ AuditPageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let nextCategoryIndex = (viewController as! AuditVCForTable).categoryIndex + 1
        if nextCategoryIndex < controllers.count {
            currentIndex = controllers[nextCategoryIndex].categoryIndex
            return controllers[nextCategoryIndex]
        }
        return nil
    }
}

extension AuditPageViewController: GoToScreenDelegate {
    
    func GoToScreen(screenNumber: Int) {
        if categoryIndex > screenNumber {
            self.setViewControllers([self.controllers[screenNumber]], direction: .reverse, animated: true, completion: nil)
            categoryIndex = screenNumber
        } else {
            self.setViewControllers([self.controllers[screenNumber]], direction: .forward, animated: true, completion: nil)
            categoryIndex = screenNumber
        }
    }
}
