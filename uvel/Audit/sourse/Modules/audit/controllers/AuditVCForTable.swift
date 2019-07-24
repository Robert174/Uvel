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
    
    var categoryIndex = 0
    var categoryNameArr = [String]()
    var jsonObj = JSON()
    var myCustomView = UIView()
    var response: Response!
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
    }
    
    func configure() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "AuditTableViewCell", bundle: nil), forCellReuseIdentifier: "AuditTableViewCellID")
        tableView.register(UINib(nibName: "AuditSectionTableView", bundle: nil), forHeaderFooterViewReuseIdentifier: "AuditSectionTableViewID")
        tableView.tableFooterView = UIView(frame: .zero)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}



extension AuditVCForTable: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.response?.data.schema[categoryIndex].tradeMarks!.count ?? 10)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (response?.data.schema[categoryIndex].tradeMarks![section].opened)! {
            return (response?.data.schema[categoryIndex].tradeMarks![section].products.count)!
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AuditSectionTableViewID") as! AuditSectionTableView
        sectionView.delegate = self
        sectionView.label.text = self.response?.data.schema[categoryIndex].tradeMarks![section].tradeMarkName
        sectionView.tag = section
        sectionView.separatedLine.isHidden = !(response?.data.schema[categoryIndex].tradeMarks![sectionView.tag].opened)!
        if (response?.data.schema[categoryIndex].tradeMarks![sectionView.tag].opened)! {
            sectionView.disclosureButton.setImage(UIImage(named: "collapse.png"), for: .normal)
        } else {
            sectionView.disclosureButton.setImage(UIImage(named: "expand.png"), for: .normal)
        }
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AuditTableViewCellID", for: indexPath) as! AuditTableViewCell
        
        let cellModel = self.response?.data.schema[categoryIndex].tradeMarks![indexPath.section].products[indexPath.row]
        cell.label.text = cellModel?.productName
        if !(response?.data.schema[categoryIndex].tradeMarks![indexPath.section].products[indexPath.row].opened)! {
            response?.data.schema[categoryIndex].tradeMarks![indexPath.section].products[indexPath.row].switchOn = false
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
        if (response?.data.schema[categoryIndex].tradeMarks![section.tag].opened)! {
            section.disclosureButton.setImage(UIImage(named: "collapse.png"), for: .normal)
            response?.data.schema[categoryIndex].tradeMarks![section.tag].opened = false
            for elem in 0 ... (response?.data.schema[categoryIndex].tradeMarks![section.tag].products.count)! - 1 {
                response?.data.schema[categoryIndex].tradeMarks![section.tag].products[elem].opened = false
                response?.data.schema[categoryIndex].tradeMarks![section.tag].products[elem].switchOn = false
            }
        } else {
            response?.data.schema[categoryIndex].tradeMarks![section.tag].opened = true
            section.disclosureButton.setImage(UIImage(named: "expand.png"), for: .normal)
        }
        tableView.reloadSections(sections, with: .fade)
    }
}



extension AuditVCForTable: resizeCellDelegate {
    
    func resizeCellDelegate(cell: AuditTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let value = response?.data.schema[categoryIndex].tradeMarks![indexPath.section].products[indexPath.row].opened
        
        response?.data.schema[categoryIndex].tradeMarks![indexPath.section].products[indexPath.row].opened = !value!
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
}



extension AuditVCForTable: switchValueDidChangedDelegate {
    
    
    func switchValueDidChangedDelegate(cell: AuditTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let value = response?.data.schema[categoryIndex].tradeMarks![indexPath.section].products[indexPath.row].switchOn
        
        response?.data.schema[categoryIndex].tradeMarks![indexPath.section].products[indexPath.row].switchOn = !value!
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
}
