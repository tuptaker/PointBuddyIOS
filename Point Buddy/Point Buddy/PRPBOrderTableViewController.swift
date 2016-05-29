//
//  PRPBOrderTableViewController.swift
//  Point Buddy
//
//  Created by admin mac on 5/28/16.
//  Copyright © 2016 tuptake. All rights reserved.
//

import UIKit
import Money

struct PRPBOrderItem {
    var itemName: String?
    var itemPrice: USD?
}

class PRPBOrderTableViewController: UITableViewController, OrderEditDelegate {

    // MARK: PRPBOrderDetailViewController properties
    var currentOrderList: [PRPBOrderItem] = []
    
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
    
    
//    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        let orderItemForIdx = self.currentOrderList[indexPath.row]
//        
//        if let orderItemCell = cell as? PRPBOrderItemTableViewCell {
//            orderItemCell.orderItemKindLabel.text = orderItemForIdx.itemName
//            orderItemCell.orderItemPriceLabel.text = "\(orderItemForIdx.itemPrice!)"
//            orderItemCell.currentIdxPath = indexPath
//        }
//    }
    
    
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        self.currentOrderList.removeAtIndex(indexPath.row)
//        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .None)
//    }
//
//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return true
//    }
}

extension PRPBOrderTableViewController {
    // MARK: OrderEditDelegate
    func addedOrderItem(orderItem: String, orderItemPrice: String) {
        let item = PRPBOrderItem(itemName: orderItem, itemPrice: USD(Float(String(orderItemPrice.characters.dropFirst()))!))
        self.currentOrderList.append(item)
        let idxPath = NSIndexPath(forRow: self.currentOrderList.count - 1, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([idxPath], withRowAnimation: UITableViewRowAnimation.None)
    }
    
    
    func removedOrderItem(orderItem: String, orderItemPrice: String, indexPath: NSIndexPath) {
        //self.tableView.beginUpdates()
        self.currentOrderList.removeAtIndex(indexPath.row)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        //self.tableView.endUpdates()
        //self.tableView.reloadData()
        //self.view.setNeedsLayout()
        //self.view.setNeedsDisplay()
    }
}
