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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let nameField = self.customerNameField, let nameStr = nameField.text, nameStr == "" {
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
        self.tenderedButton.setTitle("Tendered: \(self.tendered)", for: .normal)
        self.changeLabel.text = "\(self.change)"
        let orderItems: [String] = self.orderList.map {return $0.itemName!}
        let orderListStr = orderItems.joined(separator: ", ")
        self.customerOrderTextView.text = orderListStr
    }
    
    
    func dismissConfirmScreenAndFinishOrder() {
        self.tableVC?.clearCurrentOrder()
        self.dismiss(animated: true) {
            let order = PRPBOrder(customerName: self.customerNameField.text, timeOfOrder: Date(), totalCostOfOrder:self.finalCost.totalCost(), tax:self.finalCost.tax, amountTendered:self.tendered, isCash:self.cashOrCreditToggle.isOn, isCredit:!self.cashOrCreditToggle.isOn, orderList: (self.orderList))
            PRPBOrderLog.sharedInstance.orders.append(order)
        }
    }
    
    
    //MARK: IBActions
    @IBAction func orderConfirmed(_ sender: UIButton) {
        
        if self.tendered < self.finalCost.totalCost() {
            let promptForPayment = UIAlertController(title: "Need Payment from Customer",
                                                          message: "You are still \(self.finalCost.totalCost() - tendered) short of the final bill - please return to confirmation screen, collect the payment from customer, tap 'tendered' button and enter amount.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Back to Confirmation Screen", style: UIAlertActionStyle.default, handler: {
                alert -> Void in
            })
            
            promptForPayment.addAction(okAction)
            self.present(promptForPayment, animated: true) {
            }
        }
        else if self.customerNameField.text == "" {
            
            let promptForCustomerName = UIAlertController(title: "Need Customer Name",
                                                          message: "You forgot to enter the customer name - please enter it here:", preferredStyle: .alert)
            promptForCustomerName.addTextField { (textField : UITextField!) -> Void in
            }
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {
                alert -> Void in
                let customerNameStr = (promptForCustomerName.textFields![0] as UITextField).text
                if customerNameStr == "" {
                    self.customerNameField.text = "Unknown"
                }
                self.dismissConfirmScreenAndFinishOrder()
            })
            
            promptForCustomerName.addAction(okAction)
            self.present(promptForCustomerName, animated: true) {
            }
            
        } else {
            self.dismissConfirmScreenAndFinishOrder()
        }
    }

    
    @IBAction func orderCanceled(_ sender: UIButton) {
        self.dismiss(animated: true) {
        }
    }
    
    
    @IBAction func paymentTendered(_ sender: UIButton) {
        let tenderedInputController = UIAlertController(title: "Amount Tendered", message: "Enter Amount Tendered Here:", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            let tenderedAmtField = tenderedInputController.textFields![0] as UITextField
            tenderedAmtField.keyboardType = UIKeyboardType.numbersAndPunctuation
            let amtStrWithoutCurrencyChars = tenderedAmtField.text?.replacingOccurrences(of: "US$", with: "")
            self.tendered = USD(Float(amtStrWithoutCurrencyChars!)!)
            self.change = self.tendered - self.finalCost.totalCost()
            self.updateOrderConfirmLabels()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        
        tenderedInputController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "\(self.tendered)"
        }
        
        tenderedInputController.addAction(okAction)
        tenderedInputController.addAction(cancelAction)
        self.present(tenderedInputController, animated: true) { 
        }
    }
    
    
    @IBAction func toggleIsCash(_ sender: UISwitch) {
        if sender.isOn {
            self.isCashLabel.textColor = UIColor.black
            self.isCreditLabel.textColor = UIColor.lightGray
        } else {
            self.isCashLabel.textColor = UIColor.lightGray
            self.isCreditLabel.textColor = UIColor.black
        }
    }

}
