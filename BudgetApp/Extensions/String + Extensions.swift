//
//  String + Extensions.swift
//  BudgetApp
//
//  Created by 珠穆朗玛小蜜蜂 on 2025/3/18.
//

import Foundation

extension String {
    
    var isEmptyOrWhitespace: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
