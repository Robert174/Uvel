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
  
    var response: Response? {
        didSet {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width + 40, height: self.view.frame.size.height - 120);
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        reloadData()
    }
    
    func reloadData() {
        AuditInteractor().getSchema { (response) in
            self.response = response
            
            for i in 0 ... (response?.data.schema.count)! - 1 {
                let controller = self.initController(index: i)
                controller.response = response!
                controller.view.tag = i
                self.controllers.append(controller)
            }
            
            self.setViewControllers([self.controllers.first!], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func initController(index: Int) -> AuditVCForTable {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AuditVCForTableID") as! AuditVCForTable
        controller.categoryIndex = index
        
        return controller
    }
}

extension AuditPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ AuditPageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        delegate1?.didSwiped(id: (AuditPageViewController.viewControllers?.first!.view.tag)!)
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
