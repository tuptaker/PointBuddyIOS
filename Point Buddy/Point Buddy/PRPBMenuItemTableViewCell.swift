//
//  PRPBMenuItemTableViewCell.swift
//  Point Buddy
//
//  Created by admin mac on 5/26/16.
//  Copyright © 2016 tuptake. All rights reserved.
//

import UIKit

class PRPBMenuItemTableViewCell: UITableViewCell {
    @IBOutlet var menuItemLabel: UILabel!
    @IBOutlet var menuItemPriceLabel: UILabel!
    @IBOutlet var removeItemButton: UIButton!
    @IBOutlet var addItemButton: UIButton!

    weak var menuDelegate: MenuSelectionDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    @IBAction func removeItemFromOrder(sender: UIButton) {
        self.menuDelegate?.menuItemRemoved(self.menuItemLabel.text!, menuPrice: self.menuItemPriceLabel.text!)
        print("Remove \(menuItemLabel.text)")
    }
    
    
    @IBAction func addItemToOrder(sender: UIButton) {
        self.menuDelegate?.menuItemAdded(self.menuItemLabel.text!, menuPrice: self.menuItemPriceLabel.text!)
        print("Add \(menuItemLabel.text)")
    }
}
