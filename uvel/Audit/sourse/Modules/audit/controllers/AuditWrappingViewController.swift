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
    
    var cellWidthArr = [CGFloat](){
        didSet{
            setupHorizontalBar(itemNumber: 0)
        }
    }
    let horizontalBarView = UIView()
    var coordX: Int = 20
    var lastId: Int = 0
    var goToScreenDelegate: GoToScreenDelegate?
    
    var filteredSearchData: [String]!

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var viewForTable: UIView! {
        didSet {
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
            
        }
        
        viewModel.calculateSizeHandler = { (id, coord) in
            self.coordX = coord
            self.scrollToNextCell(id: id)
        }
        
        
    }
    
    func setupHorizontalBar(itemNumber: Int) {
        calculateSize(id: itemNumber)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        horizontalBarView.backgroundColor = AuditColors.selectedColor
        let width = cellWidthArr[itemNumber]
        horizontalBarView.frame = CGRect(x: coordX, y: 45, width: Int(width) + 10, height: 2)
        colectionView.addSubview(horizontalBarView)
    }
    
    func calculateSize(id: Int) {
        var x = 20
        if id != 0 {
            for i in 0 ... id - 1 {
                x += Int(cellWidthArr[i]) + 15
            }
            coordX = x
        } else {
            coordX = 20
        }
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
        if let categoryName = viewModel.response.data.schema[indexPath.row].categoryName {
            let width = categoryName.width(withConstrainedHeight: 60.0, font: UIFont.systemFont(ofSize: 17))
            self.cellWidthArr.append(width)
            return CGSize(width: width, height: 60)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.response.data.schema.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoriesCollectionViewCell
        cell.categoryNameLabel.text = viewModel.response.data.schema[indexPath.row].categoryName
        
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lastIndexPath = IndexPath(row: lastId, section: 0)
        setupHorizontalBar(itemNumber: indexPath.item)
        colectionView.cellForItem(at: indexPath)?.isSelected = true
        colectionView.cellForItem(at: lastIndexPath)?.isSelected = false
        lastId = indexPath.item
        goToScreenDelegate?.GoToScreen(screenNumber: indexPath.item)
        scrollToNextCell(id: indexPath.item)
    }
}


extension AuditWrappingViewController: swipePCDelegate {
    
    func didSwiped(id: Int) {
        
        let indexPath = IndexPath(row: id, section: 0)
        let lastIndexPath = IndexPath(row: lastId, section: 0)
        
        setupHorizontalBar(itemNumber: id)
        colectionView.cellForItem(at: lastIndexPath)?.isSelected = false
        colectionView.cellForItem(at: indexPath)?.isSelected = true
        lastId = id
        scrollToNextCell(id: id)
    }
    
}
