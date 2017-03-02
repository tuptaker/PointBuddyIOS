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
    var orderTime: Date?
    var currOrderCost = PRPBCost(tax: 0, subtotal: 0)
    var customerName = ""
    var mustClear = false
    
    
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
        
        self.confirmOrderClearAlert = UIAlertController(title: "Clear Current Order?", message: "This action will remove all items from the current order. Are you sure you want to clear this order?", preferredStyle: .alert)
        self.confirmOrderClearAlert?.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.confirmOrderClearAlert?.addAction(UIAlertAction(title: "Clear", style: .default, handler: { (action) in
            if let tableVC = self.tableVC {
                tableVC.clearCurrentOrder()
                self.customerName = ""
                self.customerNameField.text = self.customerName
            }
        }))
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.mustClear {
            self.mustClear = false
            self.customerNameField.text = self.customerName
        }
        self.updateCostLabels()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let confirmVC = segue.destination as? PRPBOrderConfirmViewController {
            
            var customerNameStr = "Unknown Customer"
            if let name = self.customerNameField.text {
                customerNameStr = name
            }
            
            confirmVC.finalCost = self.currOrderCost
            confirmVC.orderList = (self.tableVC?.currentOrderList)!
            confirmVC.customerName = customerNameStr
            confirmVC.tableVC = self.tableVC
        }
    }
    
    
    //MARK: PRPBOrderTableViewController
    func updateCostLabels() {
        self.taxLabel.text = "\(self.currOrderCost.tax)"
        self.subtotalLabel.text = "\(self.currOrderCost.subtotal)"
        self.totalCostLabel.text = "\(self.currOrderCost.totalCost())"
    }
    
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    //MARK: IBActions
    @IBAction func clearOrder(_ sender: UIButton) {
        if let confirmClear = self.confirmOrderClearAlert {
            self.present(confirmClear, animated: true, completion: nil)
        }
    }

}
