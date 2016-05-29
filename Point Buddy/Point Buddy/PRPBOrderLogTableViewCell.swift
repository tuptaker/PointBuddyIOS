//
//  PRPBOrderLogTableViewCell.swift
//  Point Buddy
//
//  Created by admin mac on 5/29/16.
//  Copyright © 2016 tuptake. All rights reserved.
//

import UIKit

class PRPBOrderLogTableViewCell: UITableViewCell {

    @IBOutlet var customerNameLabel: UILabel!
    @IBOutlet var dateTimeOfOrderLabel: UILabel!
    @IBOutlet var orderDetailsLabel: UILabel!
    @IBOutlet var totalCostLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
