//
//  CategoriesCollectionView.swift
//  uvel
//
//  Created by Роберт Райсих on 29/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//


import Foundation
import UIKit

class CategoryCollectionView: UICollectionView {
    
    var viewModel = AuditViewModel()
    let horizontalBarView = UIView()
    
    var categoryNames: [String] = [] {
        didSet {
            self.cellWidthArr = setWidthForCells()
        }
    }
    var cellWidthArr = [CGFloat](){
        didSet {
            setupHorizontalBar(itemNumber: 0)
        }
    }
    

    func setWidthForCells() -> [CGFloat] {
        var arrOfWidth: [CGFloat] = []
        for i in 0 ... categoryNames.count - 1 {
            let width = categoryNames[i].width(withConstrainedHeight: AuditConstraints.collectionCellHeight, font: UIFont.systemFont(ofSize: 17))
            arrOfWidth.append(width)
        }
        return arrOfWidth
    }
    
    func createCollectionCell(atIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoriesCollectionViewCell
        cell.categoryNameLabel.text = categoryNames[indexPath.row]
        return cell
    }
    
    func newItemSelected(atIndexPath indexPath: IndexPath) {
        let lastIndexPath = IndexPath(row: viewModel.lastId, section: 0)
        self.setupHorizontalBar(itemNumber: indexPath.item)
        self.cellForItem(at: indexPath)?.isSelected = true
        self.cellForItem(at: lastIndexPath)?.isSelected = false
        viewModel.lastId = indexPath.item
        self.scrollToNextCell(withId: indexPath.item)
    }
    
    func scrollToNextCell(withId id: Int) {
        let indexPath = IndexPath(row: id, section: 0)
        self.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func getSizeForItem(atIndexPath indexPath: IndexPath) -> CGSize {
        let width = categoryNames[indexPath.row].width(withConstrainedHeight: AuditConstraints.collectionCellHeight, font: UIFont.systemFont(ofSize: 17))
        return CGSize(width: width, height: AuditConstraints.collectionCellHeight)
    }
    
    func didSwiped(id: Int) {
        let indexPath = IndexPath(row: id, section: 0)
        let lastIndexPath = IndexPath(row: viewModel.lastId, section: 0)
        self.setupHorizontalBar(itemNumber: id)
        self.cellForItem(at: lastIndexPath)?.isSelected = false
        self.cellForItem(at: indexPath)?.isSelected = true
        viewModel.lastId = id
        self.scrollToNextCell(withId: id)
    }
    
    func setupHorizontalBar(itemNumber: Int) {
        viewModel.calculateSize(id: itemNumber, cellWidthArr: cellWidthArr)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        horizontalBarView.backgroundColor = AuditColors.selectedColor
        let width = cellWidthArr[itemNumber]
        horizontalBarView.frame = CGRect(x: viewModel.coordX, y: 45, width: Int(width) + AuditConstraints.horizontalBarIndent, height: AuditConstraints.horizontalBarHeight)
        self.addSubview(horizontalBarView)
    }
}
