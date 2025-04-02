//
//  Expense+Extensions.swift
//  BudgetApp
//
//  Created by 珠穆朗玛小蜜蜂 on 2025/3/26.
//

import Foundation
import CoreData

extension Expense {
    
    var total: Double {
        amount * Double(quantity)
    }
}
