//
//  PRPBOrderDetailViewController.swift
//  Point Buddy
//
//  Created by admin mac on 5/24/16.
//  Copyright © 2016 tuptake. All rights reserved.
//

import UIKit
import Money

class PRPBOrderDetailViewController: UIViewController, UITextFieldDelegate {
    //MARK: PRPBOrderDetailViewController properties
    var tableVC: PRPBOrderTableViewController?
    var confirmOrderClearAlert: UIAlertController?
    var confirmOrderAlert: UIAlertController?
    var orderTime: NSDate?
    var currOrderCost = PRPBCost(tax: 0, subtotal: 0)
    
    
    //MARK: IBOutlets
    @IBOutlet var subtotalLabel: UILabel!
    @IBOutlet var taxLabel: UILabel!
    @IBOutlet var totalCostLabel: UILabel!
    @IBOutlet var customerNameField: UITextField!
    
    
    // MARK: UIViewController overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customerNameField.delegate = self
        self.tableVC = self.childViewControllers[0] as? PRPBOrderTableViewController
        tableVC?.orderParentVC = self
        
        self.confirmOrderClearAlert = UIAlertController(title: "Clear Current Order?", message: "This action will remove all items from the current order. Are you sure you want to clear this order?", preferredStyle: .Alert)
        self.confirmOrderClearAlert?.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.confirmOrderClearAlert?.addAction(UIAlertAction(title: "Clear", style: .Default, handler: { (action) in
            if let tableVC = self.tableVC {
                tableVC.clearCurrentOrder()
            }
        }))
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.updateCostLabels()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let confirmVC = segue.destinationViewController as? PRPBOrderConfirmViewController {
            
            var customerNameStr = "Unknown Customer"
            if let name = self.customerNameField.text {
                customerNameStr = name
            }
            
            confirmVC.finalCost = self.currOrderCost
            confirmVC.orderList = (self.tableVC?.currentOrderList)!
            let order = PRPBOrder(customerName: customerNameStr, timeOfOrder: NSDate(), totalCostOfOrder:self.currOrderCost.totalCost(), orderList: (self.tableVC?.currentOrderList)!)
            PRPBOrderLog.sharedInstance.orders.append(order)
            
            //self.tableVC?.clearCurrentOrder()
            //self.customerNameField.text = ""
        }
    }
    
    
    //MARK: PRPBOrderTableViewController
    func updateCostLabels() {
        self.taxLabel.text = "\(self.currOrderCost.tax)"
        self.subtotalLabel.text = "\(self.currOrderCost.subtotal)"
        self.totalCostLabel.text = "\(self.currOrderCost.totalCost())"
    }
    
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    //MARK: IBActions
    @IBAction func clearOrder(sender: UIButton) {
        if let confirmClear = self.confirmOrderClearAlert {
            self.presentViewController(confirmClear, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func confirmOrder(sender: UIButton) {
        var customerNameStr = "Unknown Customer"
        if let name = self.customerNameField.text {
            customerNameStr = name
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "d-MMM-yyy, h:mm a"
        let dateStr = dateFormatter.stringFromDate(NSDate())
        self.confirmOrderAlert = UIAlertController(title: "Confirm Order: \(self.totalCostLabel.text!)", message: "Order for \(customerNameStr)\n added to order list on\n \(dateStr)", preferredStyle: .Alert)
        self.confirmOrderAlert?.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.confirmOrderAlert?.addAction(UIAlertAction(title: "Confirmed", style: .Default, handler: { (action) in
            let order = PRPBOrder(customerName: customerNameStr, timeOfOrder: NSDate(), totalCostOfOrder:self.currOrderCost.totalCost(), orderList: (self.tableVC?.currentOrderList)!)
            PRPBOrderLog.sharedInstance.orders.append(order)
            self.tableVC?.clearCurrentOrder()
            self.customerNameField.text = ""
        }))
        
        self.presentViewController(self.confirmOrderAlert!, animated: true, completion: nil)
    }
}