//
//  CategoriesCollectionViewCell.swift
//  uvel
//
//  Created by Роберт Райсих on 18/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryNameLabel: UILabel!{
        didSet {
            
        }
    }
    
    
    override var isHighlighted: Bool {
        didSet { 
            categoryNameLabel.textColor = isHighlighted ? UIColor.red : UIColor.gray
        }
    }
    
    override var isSelected: Bool {
        didSet {
            categoryNameLabel.textColor = isSelected ? UIColor.red : UIColor.gray
        }
    }
}
