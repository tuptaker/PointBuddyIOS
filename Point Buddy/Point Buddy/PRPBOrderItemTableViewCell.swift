//
//  PRPBOrderItemTableViewCell.swift
//  Point Buddy
//
//  Created by admin mac on 5/26/16.
//  Copyright © 2016 tuptake. All rights reserved.
//

import UIKit

class PRPBOrderItemTableViewCell: UITableViewCell {
    
    // MARK: PRPBOrderItemTableViewCell outlets
    @IBOutlet var removeOrderItemButton: UIButton!
    @IBOutlet var addOrderItemButton: UIButton!
    @IBOutlet var orderItemKindLabel: UILabel!
    @IBOutlet var orderItemPriceLabel: UILabel!

    
    // MARK: PRPBOrderItemTableViewCell properties
    weak var orderDelegate: OrderEditDelegate?
    var currentIdxPath: NSIndexPath?
    
    
    // MARK: UIView overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    // MARK: UITableView overrides
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // MARK: IBActions
    @IBAction func removeOrderItem(sender: UIButton) {
        self.orderDelegate?.removedOrderItem(self.orderItemKindLabel.text!, orderItemPrice: self.orderItemPriceLabel.text!, indexPath: self.currentIdxPath!)
    }
    
    
    @IBAction func addOrderItem(sender: UIButton) {
        self.orderDelegate?.addedOrderItem(self.orderItemKindLabel.text!, orderItemPrice: self.orderItemPriceLabel.text!)
    }
}
