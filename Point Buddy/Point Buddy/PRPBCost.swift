//
//  PRPBCost.swift
//  Point Buddy
//
//  Created by admin mac on 6/4/16.
//  Copyright © 2016 tuptake. All rights reserved.
//

import Foundation
import Money

struct PRPBCost {
    var tax: USD
    var subtotal: USD
    func totalCost() -> USD {
        return (tax + subtotal)
    }
}
