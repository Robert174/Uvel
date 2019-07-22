//
//  firstLevelTableViewCell.swift
//  uvel
//
//  Created by Роберт Райсих on 09/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//

import UIKit

protocol myTableDelegate {
    func myTableDelegate(section: firstLevelTableViewCell)
}

class firstLevelTableViewCell: UITableViewHeaderFooterView {
    var delegate: myTableDelegate?
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var disclosureButton: UIButton!
    @IBOutlet weak var separatedLine: UIView!
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(tap))
        addGestureRecognizer(tapGesture)
    }
    
    @objc func tap(_ sender: AnyObject) {
        delegate?.myTableDelegate(section: self)
    }
    
}
