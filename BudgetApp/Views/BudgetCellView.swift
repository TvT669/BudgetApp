//
//  BudgetCellView.swift
//  BudgetApp
//
//  Created by 珠穆朗玛小蜜蜂 on 2025/3/23.
//

import SwiftUI


struct BudgetCellView: View {
    
    let budget: Budget
    
    var body: some View {
        HStack {
            Text(budget.title ?? "")
            Spacer()
            Text(budget.limit, format: .currency(code: Locale.current.currency?.identifier ?? "CNA"))
        }
    }
}
