//
//  PRPBOrderTableViewController.swift
//  Point Buddy
//
//  Created by admin mac on 5/28/16.
//  Copyright © 2016 tuptake. All rights reserved.
//

import UIKit
import Money

// MARK: Data Model
struct PRPBOrderItem {
    var itemName: String?
    var itemPrice: USD?
}

class PRPBOrderTableViewController: UITableViewController, OrderEditDelegate {

    // MARK: PRPBOrderDetailViewController properties
    var currentOrderList: [PRPBOrderItem] = []
    var orderParentVC: PRPBOrderDetailViewController?
    var currCost: PRPBCost = PRPBCost(tax: 0, subtotal: 0)
    
    // MARK: UIViewController overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDlg = UIApplication.shared.delegate as! PRPBAppDelegate
        appDlg.masterVC?.orderEditDelegate = self
        let orderItemCellXib = UINib(nibName: "PRPBOrderItemTableViewCell", bundle: nil)
        self.tableView.register(orderItemCellXib, forCellReuseIdentifier: "orderItemTableViewCell")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentOrderList.count
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let orderItemForIdx = self.currentOrderList[indexPath.row]
        
        var cell = UITableViewCell()
        if let orderItemCell = tableView.dequeueReusableCell(withIdentifier: "orderItemTableViewCell", for: indexPath) as? PRPBOrderItemTableViewCell {
            orderItemCell.orderItemKindLabel.text = orderItemForIdx.itemName
            orderItemCell.orderItemPriceLabel.text = "\(orderItemForIdx.itemPrice!)"
            orderItemCell.currentIdxPath = indexPath
            orderItemCell.orderDelegate = self
            cell = orderItemCell
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84.0
    }
    
    
    // MARK: PRPBOrderTableViewController
    func refreshTotalCost() {
        let allItemPrices = self.currentOrderList.map {return $0.itemPrice}
        let subTotal = allItemPrices.reduce(USD(0)) {return $0 + $1!}
        self.currCost.subtotal = subTotal
        let taxRateStr = PRPBConfigManager.sharedInstance.valueForConfigSetting("taxRate") as! String
        let taxRate = Double(taxRateStr)! / 100
        let subTotalAmtRaw = taxRate *   subTotal.floatValue
        let taxAmt = USD(subTotalAmtRaw)
        self.currCost.tax = taxAmt
        self.orderParentVC?.currOrderCost = self.currCost
        self.orderParentVC?.updateCostLabels()
    }
    
    
    func clearCurrentOrder() {
        self.currentOrderList.removeAll()
        self.orderParentVC?.customerName = ""
        self.orderParentVC?.mustClear = true
        self.refreshTotalCost()
        self.tableView.reloadData()
    }

}


extension PRPBOrderTableViewController {
    // MARK: OrderEditDelegate
    func addedOrderItem(_ orderItem: String, orderItemPrice: String) {
        let item = PRPBOrderItem(itemName: orderItem, itemPrice: USD(Float(String(orderItemPrice.characters))!))
        self.currentOrderList.append(item)
        let idxPath = IndexPath(row: self.currentOrderList.count - 1, section: 0)
        self.tableView.insertRows(at: [idxPath], with: UITableViewRowAnimation.bottom)
        self.refreshTotalCost()
    }
    
    
    func removedOrderItem(_ orderItem: String, orderItemPrice: String, indexPath: IndexPath) {
        self.tableView.beginUpdates()
        self.currentOrderList.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.bottom)
        let idxSet = IndexSet(integer: 0)
        self.tableView.reloadSections(idxSet, with: UITableViewRowAnimation.none)
        self.tableView.endUpdates()
        self.refreshTotalCost()
    }
}
