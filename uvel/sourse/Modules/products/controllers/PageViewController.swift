//
//  PageViewController.swift
//  uvel
//
//  Created by Роберт Райсих on 16/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//

import UIKit

protocol swipePCDelegate {
    func didSwiped(id: Int)
}

class PageViewController: UIPageViewController {
    
    var categoryIndex = Int()
    var currentIndex = 0
    var controllers = [ViewController]()
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
        RequestManager().getSchema { (response) in
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
    
    func initController(index: Int) -> ViewController {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ViewControllerId") as! ViewController
        controller.categoryIndex = index
        
        return controller
    }
}

extension PageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        delegate1?.didSwiped(id: (pageViewController.viewControllers?.first!.view.tag)!)
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let prevCategoryIndex = (viewController as! ViewController).categoryIndex - 1
        if prevCategoryIndex >= 0 {
            currentIndex = controllers[prevCategoryIndex].categoryIndex
            return controllers[prevCategoryIndex]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let nextCategoryIndex = (viewController as! ViewController).categoryIndex + 1
        if nextCategoryIndex < controllers.count {
            currentIndex = controllers[nextCategoryIndex].categoryIndex
            return controllers[nextCategoryIndex]
        }
        return nil
    }
}

extension PageViewController: GoToScreenDelegate {
    
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
