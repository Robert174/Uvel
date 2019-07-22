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
    var controllers = [ViewController]()
    var delegate1: swipePCDelegate?
    var nextIndex = Int()
    struct globalVar {
        static var Categories = [String]()
    }
    
    var response: Response? {
        didSet {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width + 40, height: self.view.frame.size.height - 120);
            for elem in 0 ... (self.response?.data.schema.count)! - 1 {
                globalVar.Categories.append((self.response?.data.schema[elem].categoryName)!)
            }
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
            
            response?.data.schema.enumerated().forEach({ (offset, category) in
                let controller = self.initController(index: offset)
                controller.response = response!
                self.controllers.append(controller)
            })
            
            self.setViewControllers([self.controllers.first!], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func initController(index: Int) -> ViewController {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ViewControllerId") as! ViewController
        controller.categoryIndex = index
        
        return controller
    }
    
    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil, number: Int) {
        
        if let nextPage = dataSource?.pageViewController(self, viewControllerAfter: controllers[number]) {
            setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
        }
        
    }
}

extension PageViewController: UIPageViewControllerDelegate, GoToScreenDelegate {
    func GoToScreen(screenNumber: Int) {
        if categoryIndex > screenNumber {
            self.setViewControllers([self.controllers[screenNumber]], direction: .reverse, animated: true, completion: nil)
            categoryIndex = screenNumber
        } else {
            self.setViewControllers([self.controllers[screenNumber]], direction: .forward, animated: true, completion: nil)
            categoryIndex = screenNumber
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        delegate1?.didSwiped(id: nextIndex)
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let prevCategoryIndex = (viewController as! ViewController).categoryIndex - 1
        if prevCategoryIndex >= 0 {
            self.nextIndex = prevCategoryIndex
            return controllers[prevCategoryIndex]
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let nextCategoryIndex = (viewController as! ViewController).categoryIndex + 1
        if nextCategoryIndex < controllers.count {
            self.nextIndex = nextCategoryIndex
            return controllers[nextCategoryIndex]
        }
        
        return nil
    }
    
    
}
