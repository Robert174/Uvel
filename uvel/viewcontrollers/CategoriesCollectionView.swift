//
//  CategoriesCollectionView.swift
//  uvel
//
//  Created by Роберт Райсих on 18/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//

import UIKit

class CategoriesCollectionView: UICollectionView {

    override func reloadInputViews() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing =  0
        layout.minimumLineSpacing = 10
        
    }

}
