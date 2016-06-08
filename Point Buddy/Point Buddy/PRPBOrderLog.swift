//
//  PRPBOrderLog.swift
//  Point Buddy
//
//  Created by admin mac on 5/29/16.
//  Copyright © 2016 tuptake. All rights reserved.
//

import Foundation
import Money

struct PRPBOrder {
    var customerName: String?
    var timeOfOrder: NSDate?
    var totalCostOfOrder: USD?
    var tax: USD?
    var amountTendered: USD?
    var isCash: Bool?
    var isCredit: Bool?
    var orderList: [PRPBOrderItem] = []
}

class PRPBOrderLog {
    static let sharedInstance = PRPBOrderLog()
    var orders: [PRPBOrder]
    private init(){
        orders = []
    }
}