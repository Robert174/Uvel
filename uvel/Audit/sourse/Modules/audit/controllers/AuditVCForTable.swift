//
//  AuditVCForTable.swift
//  uvel
//
//  Created by Роберт Райсих on 17/07/2019.
//  Copyright © 2019 Роберт Райсих. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AuditVCForTable: UIViewController, UIGestureRecognizerDelegate {
    
    var viewModel: AuditViewModel?
    var categoryIndex: Int = 0
    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.register(UINib(nibName: "AuditTableViewCell", bundle: nil), forCellReuseIdentifier: "AuditTableViewCellID")
            tableView.register(UINib(nibName: "AuditSectionTableView", bundle: nil), forHeaderFooterViewReuseIdentifier: "AuditSectionTableViewID")
            tableView.tableFooterView = UIView(frame: .zero)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}


extension AuditVCForTable: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return AuditConstraints.heightForRow
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AuditConstraints.heightForSection
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel!.getCountOfTradeMarksInCategory(with: categoryIndex)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tradeMark = viewModel!.getTradeMark(InCategory: categoryIndex, InSection: section)
        if (tradeMark.opened) {
            return (tradeMark.products.count)
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AuditSectionTableViewID") as! AuditSectionTableView
        let tradeMarkModel = viewModel?.getTradeMark(InCategory: categoryIndex, InSection: section)
        sectionView.delegate = self
        sectionView.label.text = tradeMarkModel!.tradeMarkName
        sectionView.tag = section
        sectionView.separatedLine.isHidden = !(viewModel?.getTradeMark(InCategory: categoryIndex, InSection: sectionView.tag).opened)!
        if (viewModel?.getTradeMark(InCategory: categoryIndex, InSection: sectionView.tag).opened)! {
            sectionView.disclosureButton.setImage(UIImage(named: "collapse.png"), for: .normal)
        } else {
            sectionView.disclosureButton.setImage(UIImage(named: "expand.png"), for: .normal)
        }
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AuditTableViewCellID", for: indexPath) as! AuditTableViewCell
        
        let cellModel = viewModel?.getProduct(inCategory: categoryIndex, inSection: indexPath.section, inRow: indexPath.row)
        
        cell.label.text = cellModel?.productName
        if !(cellModel?.opened)! {
            cellModel!.switchOn = false
        }
        
        cell.stackView.isHidden = !cellModel!.opened
        cell.saleStack.isHidden = !cellModel!.switchOn
        cell.switchForSale.setOn(!cell.saleStack.isHidden, animated: true)
        cell.delegate = self
        cell.delegate2 = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension AuditVCForTable: myTableDelegate {
    
    func myTableDelegate(section: AuditSectionTableView) {
        let sections = IndexSet.init(integer: section.tag)
        let tradeMarkModel = viewModel!.getTradeMark(InCategory: categoryIndex, InSection: section.tag)
        if (tradeMarkModel.opened) {
            section.disclosureButton.setImage(UIImage(named: "collapse.png"), for: .normal)
            tradeMarkModel.opened = false
            for elem in 0 ... (tradeMarkModel.products.count) - 1 {
                tradeMarkModel.products[elem].opened = false
                tradeMarkModel.products[elem].switchOn = false
            }
        } else {
            tradeMarkModel.opened = true
            section.disclosureButton.setImage(UIImage(named: "expand.png"), for: .normal)
        }
        tableView.reloadSections(sections, with: .fade)
    }
}



extension AuditVCForTable: resizeCellDelegate {
    
    func resizeCellDelegate(cell: AuditTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let productModel = viewModel?.getProduct(inCategory: categoryIndex, inSection: indexPath.section, inRow: indexPath.row)
        
        let value = productModel!.opened
        
        productModel!.opened = !value
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
}



extension AuditVCForTable: switchValueDidChangedDelegate {
    
    
    func switchValueDidChangedDelegate(cell: AuditTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let productModel = viewModel?.getProduct(inCategory: categoryIndex, inSection: indexPath.section, inRow: indexPath.row)
        
        let value = productModel!.switchOn
        
        productModel!.switchOn = !value
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
}
