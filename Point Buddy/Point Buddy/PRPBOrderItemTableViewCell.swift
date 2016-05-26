//
//  PRPBOrderItemTableViewCell.swift
//  Point Buddy
//
//  Created by admin mac on 5/26/16.
//  Copyright © 2016 tuptake. All rights reserved.
//

import UIKit

class PRPBOrderItemTableViewCell: UITableViewCell {
    @IBOutlet var removeOrderItemButton: UIButton!
    @IBOutlet var addOrderItemButton: UIButton!
    @IBOutlet var orderItemKindLabel: UILabel!
    @IBOutlet var orderItemPriceLabel: UILabel!

    weak var orderDelegate: OrderEditDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func removeOrderItem(sender: UIButton) {
        self.orderDelegate?.removedOrderItem(self.orderItemKindLabel.text!, orderItemPrice: self.orderItemPriceLabel.text!)
    }
    
    
    @IBAction func addOrderItem(sender: UIButton) {
        self.orderDelegate?.addedOrderItem(self.orderItemKindLabel.text!, orderItemPrice: self.orderItemPriceLabel.text!)
    }
}
