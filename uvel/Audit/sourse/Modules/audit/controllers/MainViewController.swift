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
    
    var horizontalBarLeftAncorConstraint: NSLayoutConstraint?
    let selectedIndexPath = NSIndexPath(item: 0, section: 0)
    let horizontalBarView = UIView()
    var coordX: Int = 15
    var lastId = Int()
    var goToScreenDelegate: GoToScreenDelegate?
    
    var cellWidth = [Int]() {
        didSet {
            initColectionView()
            colectionView.delegate = self
            setupHorizontalBar(itemNumber: 0)
        }
    }
    
    var response: Response! {
        didSet {
            initNavController()
            initCellWidth()
        }
    }
    
    let searchData = ["New York, NY", "Los Angeles, CA", "Chicago, IL", "Houston, TX",
                "Philadelphia, PA", "Phoenix, AZ", "San Diego, CA", "San Antonio, TX",
                "Dallas, TX", "Detroit, MI", "San Jose, CA", "Indianapolis, IN",
                "Jacksonville, FL", "San Francisco, CA", "Columbus, OH", "Austin, TX",
                "Memphis, TN", "Baltimore, MD", "Charlotte, ND", "Fort Worth, TX"]
    
    var filteredSearchData: [String]!
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
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
    
    @IBOutlet weak var searchTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        filteredSearchData = searchData
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "ViewControllerId") as! ViewController
        let searchController = UISearchController(searchResultsController: controller)
        searchController.definesPresentationContext = true
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    
    }
    
    
    func initCellWidth() {
        for i in 0 ... response.data.schema.count - 1 {
            cellWidth.append(response.data.schema[i].categoryName!.count * 8 + 40)
        }
    }
    
    func initNavController() {
        self.navigationController?.navigationBar.backgroundColor = AuditColors.navBarColor
    }
    
    func getData() {
        ProductsInteractor().getSchema { (response) in
            self.response = response
        }
    }
    
    func setupHorizontalBar(itemNumber: Int) {
        colectionView.addSubview(horizontalBarView)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        horizontalBarView.backgroundColor = AuditColors.selectedColor
        horizontalBarView.frame = CGRect(x: coordX + 9 * itemNumber, y: 45, width: cellWidth[itemNumber], height: 2)
    }
    
    
    func scrollToNextCell(id: Int){
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
        colectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: [])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: cellWidth[indexPath.row], height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return response.data.schema.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoriesCollectionViewCell
        cell.categoryNameLabel.text = response.data.schema[indexPath.row].categoryName
        
        updateLabelFrame(label: cell.categoryNameLabel)
        
        
        return cell
    }
    
    func updateLabelFrame(label: UILabel) {
        let maxSize = CGSize(width: 300, height: 40)
        let size = label.sizeThatFits(maxSize)
        label.frame = CGRect(origin: CGPoint(x: 0, y: 20), size: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        calculateSize(id: indexPath.item)
        let lastIndexPath = IndexPath(row: lastId, section: 0)
        setupHorizontalBar(itemNumber: indexPath.item)
        colectionView.cellForItem(at: indexPath)?.isSelected = true
        colectionView.cellForItem(at: lastIndexPath)?.isSelected = false
        lastId = indexPath.item
        goToScreenDelegate?.GoToScreen(screenNumber: indexPath.item)
    }
    
    func calculateSize(id: Int) {
        var x = 15
        if id != 0 {
            for i in 0 ... id - 1 {
                x += cellWidth[i]
            }
            coordX = x
        } else {
            coordX = 15
        }
        scrollToNextCell(id: id)
    }
}

extension AuditWrappingViewController: UISearchBarDelegate  {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filteredSearchData = searchText.isEmpty ? self.searchData : self.searchData.filter { (item: String) -> Bool in
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
    }
}

extension AuditWrappingViewController: swipePCDelegate {
    
    func didSwiped(id: Int) {
        let indexPath = IndexPath(row: id, section: 0)
        let lastIndexPath = IndexPath(row: lastId, section: 0)
        calculateSize(id: id)
        
        setupHorizontalBar(itemNumber: id)
        colectionView.cellForItem(at: lastIndexPath)?.isSelected = false
        colectionView.cellForItem(at: indexPath)?.isSelected = true
        lastId = id
    }
}
