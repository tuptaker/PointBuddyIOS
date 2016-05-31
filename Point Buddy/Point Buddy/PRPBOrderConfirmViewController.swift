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
    @IBOutlet var tenderedLabel: UILabel!
    @IBOutlet var isCreditLabel: UILabel!
    @IBOutlet var cashOrCreditToggle: UISwitch!
    @IBOutlet var isCashLabel: UILabel!
    @IBOutlet var changeLabel: UILabel!
    @IBOutlet var confirmOrderButton: UIButton!
    
    
    //MARK: PRPBOrderConfirmViewController
    var orderSummaryStr: String?
    var tax: USD?
    var subtotal: USD?
    var total: USD?
    var tendered: USD?
    var isCash: Bool?
    var change: USD?
    
    
    //MARK: UIViewController overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: IBAction
    @IBAction func orderConfirmed(sender: UIButton) {
    }

}
