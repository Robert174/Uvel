//
//  AuditTableViewCell.swift
//  uvel
//
//  Created by Роберт Райсих on 09/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//

import UIKit

protocol resizeCellDelegate {
    func resizeCellDelegate(cell: AuditTableViewCell)
}

protocol switchValueDidChangedDelegate {
    func switchValueDidChangedDelegate(cell: AuditTableViewCell)
}

class AuditTableViewCell: UITableViewCell {
    
    var delegate: resizeCellDelegate?
    var delegate2: switchValueDidChangedDelegate?

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var switchForSale: UISwitch!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var saleStack: UIStackView!
    @IBOutlet weak var yellowPriceCheckMark: UIButton!
    @IBOutlet weak var onePlusOneCheckMark: UIButton!
    @IBOutlet weak var haederView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stackView.isHidden = true
        saleStack.isHidden = true
        
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(cellTapped))
        self.haederView.addGestureRecognizer(tapGesture)
        
        switchForSale.setOn(false, animated: true)
        switchForSale.addTarget(self, action: #selector(switchStateDidChange), for: .valueChanged)
    }
    

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
    
    @IBAction func YellowPriceTap(_ sender: Any) {
        if yellowPriceCheckMark.currentImage == UIImage(named: "ic_nocheck") {
            yellowPriceCheckMark.setImage(UIImage(named: "ic_true"), for: .normal)
        } else {
            yellowPriceCheckMark.setImage(UIImage(named: "ic_nocheck"), for: .normal)
            
        }
    }
    
    @IBAction func onePlusOneTap(_ sender: Any) {
        if onePlusOneCheckMark.currentImage == UIImage(named: "ic_nocheck") {
            onePlusOneCheckMark.setImage(UIImage(named: "ic_true"), for: .normal)
        } else {
            onePlusOneCheckMark.setImage(UIImage(named: "ic_nocheck"), for: .normal)
        }
    }
    
    
    @objc func cellTapped(sender: Any) {
        delegate?.resizeCellDelegate(cell: self)
    }
    
    
    @objc func switchStateDidChange(_ sender:UISwitch){
        delegate2?.switchValueDidChangedDelegate(cell: self)
    }
    
    
}
