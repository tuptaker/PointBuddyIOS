//
//  PRPBOrderLogViewController.swift
//  Point Buddy
//
//  Created by admin mac on 5/29/16.
//  Copyright © 2016 tuptake. All rights reserved.
//

import UIKit
import MessageUI
import Money
class PRPBOrderLogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {

    // IBOutlets
    @IBOutlet var orderLogTableView: UITableView!
    
    
    //MARK: UIViewController overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        let orderLogCellXib = UINib(nibName: "PRPBOrderLogTableViewCell", bundle: nil)
        self.orderLogTableView.registerNib(orderLogCellXib, forCellReuseIdentifier: "orderLogTableViewCell")
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PRPBOrderLog.sharedInstance.orders.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let orderForIdx = PRPBOrderLog.sharedInstance.orders[indexPath.row]
        
        var cell = UITableViewCell()
        if let orderLogCell = tableView.dequeueReusableCellWithIdentifier("orderLogTableViewCell") as? PRPBOrderLogTableViewCell {
            orderLogCell.customerNameLabel.text = orderForIdx.customerName
            orderLogCell.totalCostLabel.text = "\(orderForIdx.totalCostOfOrder!)"
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy, h:mm a"
            let dateStr = dateFormatter.stringFromDate(NSDate())
            orderLogCell.dateTimeOfOrderLabel.text = dateStr

            let orderItems: [String] = orderForIdx.orderList.map {return $0.itemName!}
            let orderListStr = orderItems.joinWithSeparator(",")
            
            orderLogCell.orderDetailsLabel.text = orderListStr
            cell = orderLogCell
        }

        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 114
    }
    
    
    //MARK: IBActions
    @IBAction func dismissOrderLog(sender: UIButton) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: { 
            print("Dismissed PRPBOrderLogViewController")
        })
    }

    
    @IBAction func syncOrderLog(sender: UIButton) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MMM-yyyy-h:mm-a"
        let dateStr = dateFormatter.stringFromDate(NSDate())
        let orderLogFileName = "PRPBOrderLog-\(dateStr).prpb"
        var orderLogRawText = ""
        
        let orders = PRPBOrderLog.sharedInstance.orders

        // Column headers
        orderLogRawText = orderLogRawText.stringByAppendingString("Customer Name,Time,Pizza,Pepperoni,Prosciutto,Black Olive,Bell Peppers,Broccoli,Spinach,Mushrooms,Banana Peppers,Ham,Red Onions,Pineapple,Jalapenos,Coke,Sprite,Water,Juice,Subtotal,Tax,Cash or Credit,Tendered,Change\n")
        
        for currOrder in orders {
            let costOfPizzas = currOrder.orderList.filter({ (currItem) -> Bool in
                var isPizza = false
                if (currItem.itemName == "Regular") || (currItem.itemName == "Chili-Infused") {
                    isPizza = true
                }
                return isPizza
            }).reduce(USD(0)) {return $0 + $1.itemPrice!}
            
            let costOfPepperonis = currOrder.orderList.filter({ (currItem) -> Bool in
                var isPepperoni = false
                if (currItem.itemName == "Pepperoni") {
                    isPepperoni = true
                }
                return isPepperoni
            }).reduce(USD(0)) {return $0 + $1.itemPrice!}
            
            let costOfProsciutto = currOrder.orderList.filter({ (currItem) -> Bool in
                var isProsciutto = false
                if (currItem.itemName == "Prosciutto") {
                    isProsciutto = true
                }
                return isProsciutto
            }).reduce(USD(0)) {return $0 + $1.itemPrice!}
            
            let costOfBlackOlives = currOrder.orderList.filter({ (currItem) -> Bool in
                var isBlackOlives = false
                if (currItem.itemName == "Black Olive") {
                    isBlackOlives = true
                }
                return isBlackOlives
            }).reduce(USD(0)) {return $0 + $1.itemPrice!}
            
            let costOfBellPeppers = currOrder.orderList.filter({ (currItem) -> Bool in
                var isBellPeppers = false
                if (currItem.itemName == "Bell Peppers") {
                    isBellPeppers = true
                }
                return isBellPeppers
            }).reduce(USD(0)) {return $0 + $1.itemPrice!}
            
            let costOfBroccoli = currOrder.orderList.filter({ (currItem) -> Bool in
                var isBroccoli = false
                if (currItem.itemName == "Broccoli") {
                    isBroccoli = true
                }
                return isBroccoli
            }).reduce(USD(0)) {return $0 + $1.itemPrice!}

            let costOfSpinach = currOrder.orderList.filter({ (currItem) -> Bool in
                var isSpinach = false
                if (currItem.itemName == "Spinach") {
                    isSpinach = true
                }
                return isSpinach
            }).reduce(USD(0)) {return $0 + $1.itemPrice!}
            
            let costOfMushrooms = currOrder.orderList.filter({ (currItem) -> Bool in
                var isMushrooms = false
                if (currItem.itemName == "Mushrooms") {
                    isMushrooms = true
                }
                return isMushrooms
            }).reduce(USD(0)) {return $0 + $1.itemPrice!}
            
            let costOfBananaPeppers = currOrder.orderList.filter({ (currItem) -> Bool in
                var isBananaPeppers = false
                if (currItem.itemName == "Banana Peppers") {
                    isBananaPeppers = true
                }
                return isBananaPeppers
            }).reduce(USD(0)) {return $0 + $1.itemPrice!}
            
            let costOfHam = currOrder.orderList.filter({ (currItem) -> Bool in
                var isHam = false
                if (currItem.itemName == "Ham") {
                    isHam = true
                }
                return isHam
            }).reduce(USD(0)) {return $0 + $1.itemPrice!}
        
            let costOfRedOnions = currOrder.orderList.filter({ (currItem) -> Bool in
                var isRedOnions = false
                if (currItem.itemName == "Red Onions") {
                    isRedOnions = true
                }
                return isRedOnions
            }).reduce(USD(0)) {return $0 + $1.itemPrice!}
            
            let costOfPineapple = currOrder.orderList.filter({ (currItem) -> Bool in
                var isPineapple = false
                if (currItem.itemName == "Pineapple") {
                    isPineapple = true
                }
                return isPineapple
            }).reduce(USD(0)) {return $0 + $1.itemPrice!}
            
            let costOfJalapenos = currOrder.orderList.filter({ (currItem) -> Bool in
                var isJalapenos = false
                if (currItem.itemName == "Jalapenos") {
                    isJalapenos = true
                }
                return isJalapenos
            }).reduce(USD(0)) {return $0 + $1.itemPrice!}
            
            let costOfCokes = currOrder.orderList.filter({ (currItem) -> Bool in
                var isCoke = false
                if (currItem.itemName == "Coke") {
                    isCoke = true
                }
                return isCoke
            }).reduce(USD(0)) {return $0 + $1.itemPrice!}
            
            let costOfSprites = currOrder.orderList.filter({ (currItem) -> Bool in
                var isSprite = false
                if (currItem.itemName == "Sprite") {
                    isSprite = true
                }
                return isSprite
            }).reduce(USD(0)) {return $0 + $1.itemPrice!}
            
            let costOfWaters = currOrder.orderList.filter({ (currItem) -> Bool in
                var isWater = false
                if (currItem.itemName == "Water") {
                    isWater = true
                }
                return isWater
            }).reduce(USD(0)) {return $0 + $1.itemPrice!}
            
            let costOfJuice = currOrder.orderList.filter({ (currItem) -> Bool in
                var isJuice = false
                if (currItem.itemName == "Juice") {
                    isJuice = true
                }
                return isJuice
            }).reduce(USD(0)) {return $0 + $1.itemPrice!}
            
            let cashOrCredit = ((currOrder.isCash) != nil && currOrder.isCash == true) ? "cash":"credit"
 

            let lineStr = "\(currOrder.customerName!),\(currOrder.timeOfOrder!),\(costOfPizzas),\(costOfPepperonis),\(costOfProsciutto),\(costOfBlackOlives),\(costOfBellPeppers),\(costOfBroccoli),\(costOfSpinach),\(costOfMushrooms),\(costOfBananaPeppers),\(costOfHam),\(costOfRedOnions),\(costOfPineapple),\(costOfJalapenos),\(costOfCokes),\(costOfSprites),\(costOfWaters),\(costOfJuice),\(currOrder.totalCostOfOrder! - currOrder.tax!),\(currOrder.tax!),\(cashOrCredit),\(currOrder.amountTendered!),\(currOrder.amountTendered! - currOrder.totalCostOfOrder!)\n"

            orderLogRawText = orderLogRawText.stringByAppendingString(lineStr)
        }
    
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(orderLogFileName)
            
            //writing
            do {
                try orderLogRawText.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
            }
            catch {/* error handling here */}
        }
    }
    
    
    @IBAction func emailAllOrderLogs(sender: UIButton) {
        let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        var attachments: [NSData] = []
        
        do {
            let directoryUrls = try  NSFileManager.defaultManager().contentsOfDirectoryAtURL(documentsUrl, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions())
            print(directoryUrls)
            let orderLogs = directoryUrls.filter{ $0.pathExtension == "prpb" }//.map{ $0.lastPathComponent }
            for log in orderLogs {
                //TODO fix this warning!!!
                attachments.append(NSData(contentsOfURL: log)!)
                //attachments.append(NSData.dataWithContentsOfMappedFile("test")! as! NSData)
            }
            print("TEXT FILES:\n" + orderLogs.description)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        let mailComposeViewController = configuredMailComposeViewController()
        
        var i = 0
        for attachment in attachments {
            mailComposeViewController.addAttachmentData(attachment, mimeType: "text/plain", fileName: "prpborder\(i).csv")
            i+=1
        }
        
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    
    //MARK: PRPBOrderLogViewController
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setToRecipients(["expense.phoenix@gmail.com"])
        mailComposerVC.setSubject("PRPB Order Log\(NSDate())")
        mailComposerVC.setMessageBody("See attched logs", isHTML: false)
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alertCtrlr = UIAlertController(title: "Error", message: "Unable to send email. Have you configured your inbox?", preferredStyle: .Alert)
       alertCtrlr.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
       self.presentViewController(alertCtrlr, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}


extension Array {
    func isPizza(menuItem: String) -> Bool {
        return (menuItem == "Regular") || (menuItem == "Chili-Infused")
    }
}