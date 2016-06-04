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
    var isCash: Bool = true
    var change: USD = 0
    
    
    //MARK: UIViewController overrides
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
    }
    
    
    //MARK: IBAction
    @IBAction func orderConfirmed(sender: UIButton) {
        self.dismissViewControllerAnimated(true) { 
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
