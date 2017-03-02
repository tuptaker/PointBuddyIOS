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
    func menuItemSelected(_ menuItem: String)
    func menuItemAdded(_ menuItem: String, menuPrice: String)
    func menuItemRemoved(_ menuItem: String, menuPrice: String)
}

protocol OrderEditDelegate: class {
    func addedOrderItem(_ orderItem: String, orderItemPrice: String)
    func removedOrderItem(_ orderItem: String, orderItemPrice: String, indexPath: IndexPath)
}
