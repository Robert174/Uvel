//
//  MainViewController.swift
//  uvel
//
//  Created by Роберт Райсих on 16/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//

import UIKit

protocol GoToScreenDelegate {
    func GoToScreen(screenNumber: Int)
}

class MainViewController: UIViewController, UISearchBarDelegate {
    
    var horizontalBarLeftAncorConstraint: NSLayoutConstraint?
    let selectedIndexPath = NSIndexPath(item: 0, section: 0)
    let horizontalBarView = UIView()
    var coordX: Int = 15
    var previousId = 0
    var goToScreenDelegate: GoToScreenDelegate?
    
    var cellWidth = [Int]() {
        didSet {
            initColectionView()
            colectionView.delegate = self
            searchBar.delegate = self
            setupHorizontalBar(itemNumber: 0)
        }
    }
    
    var response: Response! {
        didSet {
            initNavController()
            initCellWidth()
        }
    }
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var viewForTable: UIView! {
        didSet {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let pageViewController = sb.instantiateViewController(withIdentifier: "PageViewControllerID") as! PageViewController
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
        getData()
    }
    
    
    func initCellWidth() {
        for i in 0 ... response.data.schema.count - 1 {
            cellWidth.append(response.data.schema[i].categoryName!.count * 8 + 40)
        }
    }
    
    func initNavController() {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9733332992, green: 0.9685285687, blue: 0.9598152041, alpha: 1)
        //        navigationController?.hidesBarsOnSwipe = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationItem.title = "Отчет"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func getData() {
        RequestManager().getSchema { (response) in
            self.response = response
        }
    }
    
    func setupHorizontalBar(itemNumber: Int) {
        colectionView.addSubview(horizontalBarView)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        horizontalBarView.backgroundColor = UIColor.red
        horizontalBarView.frame = CGRect(x: coordX + 9 * itemNumber, y: 45, width: cellWidth[itemNumber], height: 2)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func initColectionView() {
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
        var x = 15
        if indexPath.item != 0 {
            for i in 0 ... indexPath.item - 1 {
                x += cellWidth[i]
            }
            coordX = x
        } else {
            coordX = 15
        }
        setupHorizontalBar(itemNumber: indexPath.item)
        colectionView.cellForItem(at: indexPath)?.isSelected = true
        goToScreenDelegate?.GoToScreen(screenNumber: indexPath.item)
    }
}

extension ViewController: UISearchBarDelegate  {
    
}

extension MainViewController: swipePCDelegate {
    
    func didSwiped(id: Int) {
        
        var x = 15
        if id != 0 {
            for i in 0 ... id - 1 {
                x += cellWidth[i]
            }
            coordX = x
        } else {
            coordX = 15
        }
        setupHorizontalBar(itemNumber: id)
        
    }
}
