//
//  PRPBOrderConfirmViewController.swift
//  Point Buddy
//
//  Created by admin mac on 5/30/16.
//  Copyright © 2016 tuptake. All rights reserved.
//

import UIKit
import Money

class PRPBOrderConfirmViewController: UIViewController {
    
    
    //MARK: IBOutlets
    @IBOutlet var customerNameField: UITextField!
    @IBOutlet var customerOrderTextView: UITextView!
    @IBOutlet var taxLabel: UILabel!
    @IBOutlet var subtotalLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var tenderedButton: UIButton!
    @IBOutlet var isCreditLabel: UILabel!
    @IBOutlet var cashOrCreditToggle: UISwitch!
    @IBOutlet var isCashLabel: UILabel!
    @IBOutlet var changeLabel: UILabel!
    @IBOutlet var confirmOrderButton: UIButton!
    
    
    //MARK: PRPBOrderConfirmViewController properties
    var finalCost = PRPBCost(tax: 0, subtotal: 0)
    var orderList: [PRPBOrderItem] = []
    var orderSummaryStr: String?
    var tendered: USD = 0
    var change: USD = 0
    var customerName = ""
    var tableVC: PRPBOrderTableViewController?
    var orderDetailVC: PRPBOrderDetailViewController?
    
    //MARK: UIViewController overrides
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let nameField = self.customerNameField, nameStr = nameField.text where nameStr == "" {
            self.customerNameField.text = self.customerName
        }
        self.updateOrderConfirmLabels()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: PRPBOrderConfirmViewController
    func updateOrderConfirmLabels() {
        self.taxLabel.text = "\(self.finalCost.tax)"
        self.subtotalLabel.text = "\(self.finalCost.subtotal)"
        self.totalLabel.text = "\(self.finalCost.totalCost())"
        self.tenderedButton.setTitle("Tendered: \(self.tendered)", forState: .Normal)
        self.changeLabel.text = "\(self.change)"
        let orderItems: [String] = self.orderList.map {return $0.itemName!}
        let orderListStr = orderItems.joinWithSeparator(", ")
        self.customerOrderTextView.text = orderListStr
    }
    
    
    func dismissConfirmScreenAndFinishOrder() {
        self.tableVC?.clearCurrentOrder()
        self.dismissViewControllerAnimated(true) {
            let order = PRPBOrder(customerName: self.customerNameField.text, timeOfOrder: NSDate(), totalCostOfOrder:self.finalCost.totalCost(), tax:self.finalCost.tax, amountTendered:self.tendered, isCash:self.cashOrCreditToggle.on, isCredit:!self.cashOrCreditToggle.on, orderList: (self.orderList))
            PRPBOrderLog.sharedInstance.orders.append(order)
        }
    }
    
    
    //MARK: IBActions
    @IBAction func orderConfirmed(sender: UIButton) {
        
        if self.tendered < self.finalCost.totalCost() {
            let promptForPayment = UIAlertController(title: "Need Payment from Customer",
                                                          message: "You are still \(self.finalCost.totalCost() - tendered) short of the final bill - please return to confirmation screen, collect the payment from customer, tap 'tendered' button and enter amount.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Back to Confirmation Screen", style: UIAlertActionStyle.Default, handler: {
                alert -> Void in
            })
            
            promptForPayment.addAction(okAction)
            self.presentViewController(promptForPayment, animated: true) {
            }
        }
        else if self.customerNameField.text == "" {
            
            let promptForCustomerName = UIAlertController(title: "Need Customer Name",
                                                          message: "You forgot to enter the customer name - please enter it here:", preferredStyle: .Alert)
            promptForCustomerName.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            }
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {
                alert -> Void in
                let customerNameStr = (promptForCustomerName.textFields![0] as UITextField).text
                if customerNameStr == "" {
                    self.customerNameField.text = "Unknown"
                }
                self.dismissConfirmScreenAndFinishOrder()
            })
            
            promptForCustomerName.addAction(okAction)
            self.presentViewController(promptForCustomerName, animated: true) {
            }
            
        } else {
            self.dismissConfirmScreenAndFinishOrder()
        }
    }

    
    @IBAction func orderCanceled(sender: UIButton) {
        self.dismissViewControllerAnimated(true) {
        }
    }
    
    
    @IBAction func paymentTendered(sender: UIButton) {
        let tenderedInputController = UIAlertController(title: "Amount Tendered", message: "Enter Amount Tendered Here:", preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: {
            alert -> Void in
            let tenderedAmtField = tenderedInputController.textFields![0] as UITextField
            tenderedAmtField.keyboardType = UIKeyboardType.NumbersAndPunctuation
            let amtStrWithoutCurrencyChars = tenderedAmtField.text?.stringByReplacingOccurrencesOfString("US$", withString: "")
            self.tendered = USD(Float(amtStrWithoutCurrencyChars!)!)
            self.change = self.tendered - self.finalCost.totalCost()
            self.updateOrderConfirmLabels()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        
        tenderedInputController.addTextFieldWithConfigurationHandler { (textField : UITextField!) -> Void in
            textField.placeholder = "\(self.tendered)"
        }
        
        tenderedInputController.addAction(okAction)
        tenderedInputController.addAction(cancelAction)
        self.presentViewController(tenderedInputController, animated: true) { 
        }
    }
    
    
    @IBAction func toggleIsCash(sender: UISwitch) {
        if sender.on {
            self.isCashLabel.textColor = UIColor.blackColor()
            self.isCreditLabel.textColor = UIColor.lightGrayColor()
        } else {
            self.isCashLabel.textColor = UIColor.lightGrayColor()
            self.isCreditLabel.textColor = UIColor.blackColor()
        }
    }

}
