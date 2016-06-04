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
        let appDlg = UIApplication.sharedApplication().delegate as! PRPBAppDelegate
        appDlg.masterVC?.orderEditDelegate = self
        let orderItemCellXib = UINib(nibName: "PRPBOrderItemTableViewCell", bundle: nil)
        self.tableView.registerNib(orderItemCellXib, forCellReuseIdentifier: "orderItemTableViewCell")
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentOrderList.count
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let orderItemForIdx = self.currentOrderList[indexPath.row]
        
        var cell = UITableViewCell()
        if let orderItemCell = tableView.dequeueReusableCellWithIdentifier("orderItemTableViewCell", forIndexPath: indexPath) as? PRPBOrderItemTableViewCell {
            orderItemCell.orderItemKindLabel.text = orderItemForIdx.itemName
            orderItemCell.orderItemPriceLabel.text = "\(orderItemForIdx.itemPrice!)"
            orderItemCell.currentIdxPath = indexPath
            orderItemCell.orderDelegate = self
            cell = orderItemCell
        }
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 84.0
    }
    
    
    // MARK: PRPBOrderTableViewController
    func refreshTotalCost() {
        let allItemPrices = self.currentOrderList.map { return $0.itemPrice}
        let subTotal = allItemPrices.reduce(USD(0)) { return $0 + $1!}
        self.currCost.subtotal = subTotal
        self.currCost.tax = USD(subTotal * 0.0625)
        self.orderParentVC?.currOrderCost = self.currCost
        self.orderParentVC?.updateCostLabels()
    }
    
    
    func clearCurrentOrder() {
        self.currentOrderList.removeAll()
        self.refreshTotalCost()
        self.tableView.reloadData()
    }

}


extension PRPBOrderTableViewController {
    // MARK: OrderEditDelegate
    func addedOrderItem(orderItem: String, orderItemPrice: String) {
        let item = PRPBOrderItem(itemName: orderItem, itemPrice: USD(Float(String(orderItemPrice.characters.dropFirst()))!))
        self.currentOrderList.append(item)
        let idxPath = NSIndexPath(forRow: self.currentOrderList.count - 1, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([idxPath], withRowAnimation: UITableViewRowAnimation.Bottom)
        self.refreshTotalCost()
    }
    
    
    func removedOrderItem(orderItem: String, orderItemPrice: String, indexPath: NSIndexPath) {
        self.tableView.beginUpdates()
        self.currentOrderList.removeAtIndex(indexPath.row)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
        let idxSet = NSIndexSet(index: 0)
        self.tableView.reloadSections(idxSet, withRowAnimation: UITableViewRowAnimation.None)
        self.tableView.endUpdates()
        self.refreshTotalCost()
    }
}
