//
//  ExpenseCellView.swift
//  BudgetApp
//
//  Created by 珠穆朗玛小蜜蜂 on 2025/3/23.
//

import SwiftUI

struct ExpenseCellView: View {
    
    @ObservedObject var expense: Expense
    
    var body: some View {
        VStack {
            HStack {
                Text("\(expense.title ?? "") (\(expense.quantity))")
               
                Spacer()
                Text(expense.total, format: .currency(code: Locale.currencyCode))
            }.contentShape(Rectangle())//整个HStack都可以点击
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Array(expense.tags as? Set<Tag> ?? [])) { tag in
                        Text(tag.name ?? "")
                            .font(.caption)
                            .padding(6)
                            .foregroundStyle(.white)
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
                    }
                }
            }
        }
    }
}

struct ExpenseCellViewContainer: View {
    
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    
    var body: some View {
        ExpenseCellView(expense: expenses[0])
    }
}

#Preview {
    ExpenseCellViewContainer()
        .environment(\.managedObjectContext, CoreDataProvider.preview.context)
}
