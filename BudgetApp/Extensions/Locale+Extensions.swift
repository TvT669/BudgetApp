//
//  Locale+Extensions.swift
//  BudgetApp
//
//  Created by 珠穆朗玛小蜜蜂 on 2025/3/20.
//

import Foundation

extension Locale {
    
    static var currencyCode: String {
        Locale.current.currency?.identifier ?? "CNY"
    }
}
