//
//  ProductsWirefare.swift
//  uvel
//
//  Created by Роберт Райсих on 23/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//

import Foundation

class XAuditReportWireframe: XWireframe {
    
    fileprivate var schema: XAuditReportSchema
    fileprivate var taskId: Int
    
    override var initialViewController: UIViewController! {
        get {
            if _initialViewController == nil {
                
                let pageController = XAuditStoryboards.audit.instantiateViewController(withIdentifier: XAuditReportPageController.storyboardId) as! XAuditReportPageController
                pageController.setup(schema: schema, taskId: taskId)
                pageController.viewModel.wireframe = self
                
                let interactor = self.interactor as? XAuditReportInteractor
                pageController.viewModel.interactor = interactor
                
                _initialViewController = pageController
            }
            return _initialViewController
        }
        
        set {
            fatalError()
        }
    }
    
    init(schema: XAuditReportSchema, taskId: Int) {
        self.schema = schema
        self.taskId = taskId
    }
    
    override func present(in controller: UIViewController?, wrappedInNavigation: Bool, withoutNavBar: Bool, completion: (() -> Void)?) {
        if wrappedInNavigation == true {
            let backBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_back"), style: .plain, target: self, action: #selector(dismissTapped))
            backBarButtonItem.tintColor = UIColor.black
            initialViewController.navigationItem.leftBarButtonItem = backBarButtonItem
        }
        super.present(in: controller, wrappedInNavigation: wrappedInNavigation, withoutNavBar: withoutNavBar, completion: completion)
    }
    
    @objc
    fileprivate func dismissTapped() {
        XAlertHelper.dialog(in: initialViewController, message: "Вы точно хотите выйти из формы отчета? Заполненные данные будут утеряны") { self.dismiss() }
    }
    
    var dismissCompletedHandler: (() -> Void)?
    
    func dismissCompleted() {
        dismiss(handler: dismissCompletedHandler)
    }
    
    override var interactor: Any? {
        get {
            if _interactor == nil {
                let interactor = XAuditReportInteractor()
                _interactor = interactor
                return _interactor
            }
            return _interactor
        }
        
        set {
            fatalError()
        }
    }
    
}
