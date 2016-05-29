//
//  PRPBProtocols.swift
//  Point Buddy
//
//  Created by admin mac on 5/26/16.
//  Copyright © 2016 tuptake. All rights reserved.
//

import Foundation


// MARK: Protocols
protocol MenuSelectionDelegate: class {
    func menuItemSelected(menuItem: String)
    func menuItemAdded(menuItem: String, menuPrice: String)
    func menuItemRemoved(menuItem: String, menuPrice: String)
}

protocol OrderEditDelegate: class {
    func addedOrderItem(orderItem: String, orderItemPrice: String)
    func removedOrderItem(orderItem: String, orderItemPrice: String, indexPath: NSIndexPath)
}