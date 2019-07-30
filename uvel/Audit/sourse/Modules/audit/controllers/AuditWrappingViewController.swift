//
//  AuditWrappingViewController.swift
//  uvel
//
//  Created by Роберт Райсих on 16/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//

import UIKit

protocol GoToScreenDelegate {
    func GoToScreen(screenNumber: Int)
}

class AuditWrappingViewController: UIViewController {
    
    var viewModel = AuditViewModel()
    
    var pageViewController: AuditPageViewController = {
        let sb = UIStoryboard(name: "Audit", bundle: nil)
        let pageViewController = sb.instantiateViewController(withIdentifier: "AuditPageViewControllerID") as! AuditPageViewController
        return pageViewController
    }()
    
    var goToScreenDelegate: GoToScreenDelegate?

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var viewForTable: UIView! {
        didSet {
            pageViewController.delegate1 = self
            self.goToScreenDelegate = pageViewController
            self.addChild(pageViewController)
            self.viewForTable.addSubview(pageViewController.view)
        }
    }
    @IBOutlet weak var colectionView: CategoryCollectionView!
    @IBOutlet weak var sendButton: UIButton!{
        didSet {
            self.sendButton.layer.cornerRadius = 10
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageViewController.view.frame = view.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        viewModel.getData()
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "AuditVCForTableID") as! AuditVCForTable
        let searchController = UISearchController(searchResultsController: controller)
        searchController.definesPresentationContext = true
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func initController(index: Int) -> AuditVCForTable {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AuditVCForTableID") as! AuditVCForTable
        controller.categoryIndex = index
        
        return controller
    }
    
    func setupViewModel() {
        viewModel.getDataHandler = { [weak self] (response) in
            guard let self = self else {return}
            self.pageViewController.setControllers(count: response.data.schema.count, viewModel: self.viewModel)
            self.initColectionView()
            self.colectionView.categoryNames = self.viewModel.getCategoriesName()
        }
        
        viewModel.calculateSizeHandler = { (id, coord) in
            self.viewModel.coordX = coord
            self.colectionView.scrollToNextCell(withId: id)
        }
    }
}

extension AuditWrappingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func initColectionView() {
        colectionView.showsHorizontalScrollIndicator = false
        colectionView.delegate = self
        colectionView.dataSource = self
        colectionView.selectItem(at: viewModel.selectedIndexPath as IndexPath, animated: false, scrollPosition: [])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return colectionView.getSizeForItem(atIndexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return AuditConstraints.collectionMinimumInteritemSpacingForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.response.data.schema.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.colectionView.createCollectionCell(atIndexPath: indexPath)
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.colectionView.newItemSelected(atIndexPath: indexPath)
        goToScreenDelegate?.GoToScreen(screenNumber: indexPath.item)
    }
}

extension AuditWrappingViewController: swipePCDelegate {
    func didSwiped(id: Int) {
        colectionView.didSwiped(id: id)
    }
}
