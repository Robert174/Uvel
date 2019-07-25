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
    
    
    let horizontalBarView = UIView()
    var coordX: Int = 15
    var lastId = Int()
    var goToScreenDelegate: GoToScreenDelegate?
    
//    var cellWidth = [Int]() {
//        didSet {
//            initColectionView()
//            colectionView.delegate = self
//            setupHorizontalBar(itemNumber: 0)
//        }
//    }
    
    var filteredSearchData: [String]!

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var viewForTable: UIView! {
        didSet {
            let sb = UIStoryboard(name: "Audit", bundle: nil)
            let pageViewController = sb.instantiateViewController(withIdentifier: "AuditPageViewControllerID") as! AuditPageViewController
            pageViewController.delegate1 = self
            self.goToScreenDelegate = pageViewController
            self.addChild(pageViewController)
            self.viewForTable.addSubview(pageViewController.view)
        }
    }
    @IBOutlet weak var colectionView: UICollectionView!
    @IBOutlet weak var sendButton: UIButton!{
        didSet{
            self.sendButton.layer.cornerRadius = 10
        }
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
    
    func setupViewModel() {
        viewModel.refreshDataHandler = {
            self.initNavController()
        }
        
        viewModel.cellWidthHandler = {
            self.initColectionView()
            self.colectionView.delegate = self
            self.setupHorizontalBar(itemNumber: 0)
        }
        
        viewModel.calculateSizeHandler = { (id, coord) in
            self.coordX = coord
            self.scrollToNextCell(id: id)
            
        }
        
    }
    
    func initNavController() {
        self.navigationController?.navigationBar.backgroundColor = AuditColors.navBarColor
        
    }
    
    func setupHorizontalBar(itemNumber: Int) {
        colectionView.addSubview(horizontalBarView)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        horizontalBarView.backgroundColor = AuditColors.selectedColor
        horizontalBarView.frame = CGRect(x: coordX + 9 * itemNumber, y: 45, width: viewModel.cellWidth[itemNumber], height: 2)
    }
    
    
    func scrollToNextCell(id: Int) {
        if let coll = colectionView {
            let indexPath = IndexPath(row: id, section: 0)
            coll.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
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
        return CGSize(width: viewModel.cellWidth[indexPath.row], height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.response.data.schema.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoriesCollectionViewCell
        cell.categoryNameLabel.text = viewModel.response.data.schema[indexPath.row].categoryName
        
        viewModel.updateLabelFrame(label: cell.categoryNameLabel)
        
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.calculateSize(id: indexPath.item)
        let lastIndexPath = IndexPath(row: lastId, section: 0)
        setupHorizontalBar(itemNumber: indexPath.item)
        colectionView.cellForItem(at: indexPath)?.isSelected = true
        colectionView.cellForItem(at: lastIndexPath)?.isSelected = false
        lastId = indexPath.item
        goToScreenDelegate?.GoToScreen(screenNumber: indexPath.item)
    }
    
    
}


extension AuditWrappingViewController: swipePCDelegate {
    
    func didSwiped(id: Int) {
        
        let indexPath = IndexPath(row: id, section: 0)
        let lastIndexPath = IndexPath(row: lastId, section: 0)
        viewModel.calculateSize(id: id)
        
        setupHorizontalBar(itemNumber: id)
        colectionView.cellForItem(at: lastIndexPath)?.isSelected = false
        colectionView.cellForItem(at: indexPath)?.isSelected = true
        lastId = id
    }
}
