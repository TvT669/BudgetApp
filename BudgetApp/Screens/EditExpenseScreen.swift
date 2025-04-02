//
//  EditExpenseScreen.swift
//  BudgetApp
//
//  Created by 珠穆朗玛小蜜蜂 on 2025/3/27.
//

import SwiftUI

struct EditExpenseScreen: View {
    
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
  
    
    @ObservedObject var expense: Expense
    let onUpdate: () -> Void //回调闭包，用于在子上下文保存后触发父视图的保存和界面关闭逻辑
    
    @State private var expenseTitle: String = ""
    @State private var expenseAmount: Double?
    @State private var expenseQuantity: Int = 0
    @State private var expenseSelectedTags: Set<Tag> = []
    
    
    private func updateExpense() {
       /* expense.title = expenseTitle
        expense.amount = expenseAmount ?? 0.0
        expense.quantity = Int16(expenseQuantity)
        expense.tags = NSSet(array: Array(expenseSelectedTags))
        //NSSet 的初始化方法 NSSet(array:) 接受一个数组作为参数。虽然 Set 和 Array 都是集合，但 NSSet 的 API 设计更兼容 Objective-C，因此需要显式转换。*/
        
        do {
            try context.save()
           onUpdate()
        } catch {
            print(error)
        }
    }
    var body: some View {
        Form{
          /*  TextField("Title", text: $expenseTitle)
            TextField("Amount", value: $expenseAmount, format: .number)
            TextField("Quantity", value: $expenseQuantity, format: .number)
            TagsView(selectedTags: $expenseSelectedTags)*/
            TextField("Title", text: Binding(get: {
                expense.title ?? ""
            }, set: { newValue in
                expense.title = newValue
            }))
            TextField("Amount", value: $expense.amount, format: .number)
            TextField("Quantity", value: $expense.quantity, format: .number)
            TagsView(selectedTags: Binding(get:{
                Set(expense.tags?.compactMap{ $0 as? Tag} ?? [])
            }, set: { newValue in
                expense.tags = NSSet(array: Array(newValue))
            }))
        }
        /*.onAppear(perform: {
           /* expenseTitle = expense.title ?? ""
            expenseAmount = expense.amount
            expenseQuantity = Int(expense.quantity)
            if let tags = expense.tags {
                expenseSelectedTags = Set(tags.compactMap{$0 as? Tag})
            }
            //compactMap 会自动过滤掉 nil */
        })*/
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Update") {
                    updateExpense()
                }
            }
        })
            .navigationTitle(expense.title ?? "")
    }
}

struct EditExpenseContainerView: View {
    
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    
    var body: some View {
        NavigationStack {
            EditExpenseScreen(expense: expenses[0], onUpdate: {})
        }
    }
}

#Preview {
    EditExpenseContainerView()
        .environment(\.managedObjectContext, CoreDataProvider.preview.context)
}
