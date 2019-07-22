//
//  CustomHeader.swift
//  uvel
//
//  Created by Роберт Райсих on 11/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//

import UIKit

protocol CustomHeaderDelegate: class {
    func customHeader(_ customHeader: CustomHeader, didTapButtonInSection section: Int)
}

class CustomHeader: UITableViewHeaderFooterView {

    static let reuseIdentifier = "CustomHeader"
    
    weak var delegate: CustomHeaderDelegate?
    
    @IBOutlet weak var customLabel: UILabel!
    
    var sectionNumber: Int!  // you don't have to do this, but it can be useful to have reference back to the section number so that when you tap on a button, you know which section you came from; obviously this is problematic if you insert/delete sections after the table is loaded; always reload in that case
    
    @IBAction func didTapButton(_ sender: AnyObject) {
        delegate?.customHeader(self, didTapButtonInSection: sectionNumber)
    }

}
