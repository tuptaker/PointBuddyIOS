//
//  PRPBOrderLogViewController.swift
//  Point Buddy
//
//  Created by admin mac on 5/29/16.
//  Copyright © 2016 tuptake. All rights reserved.
//

import UIKit
import MessageUI

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
        for currOrder in orders {
            let lineStr = "\(currOrder.customerName!);\(currOrder.timeOfOrder!);\(currOrder.totalCostOfOrder!)\n"
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
            mailComposeViewController.addAttachmentData(attachment, mimeType: "text/plain", fileName: "prpborder\(i).txt")
            i+=1
        }
        
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        mailComposerVC.setToRecipients(["expense.phoenix@gmail.com"])
        mailComposerVC.setSubject("PRPB Order Log")
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
