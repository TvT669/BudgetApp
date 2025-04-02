//
//  BudgetDetailScreen.swift
//  BudgetApp
//
//  Created by 珠穆朗玛小蜜蜂 on 2025/3/18.
//

import SwiftUI
import CoreData

struct EditExpenseConfig: Identifiable {
    let id = UUID()
    let expense: Expense
    let childContext: NSManagedObjectContext
    
    init?(expenseObjectID: NSManagedObjectID, context: NSManagedObjectContext) {
        self.childContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.childContext.parent = context
        guard let existingExpense = self.childContext.object(with: expenseObjectID) as? Expense else {return nil}
        self.expense = existingExpense
    }
}
/*​初始化子上下文：
 创建临时编辑环境（childContext），其父上下文是传入的 context。
 ​根据 ID 获取对象：
 在子上下文中查找 expenseObjectID 对应的对象。
 ​类型检查和转换：
 确认对象是 Expense 类型。
 ​错误处理：
 任一环节失败 → 返回 nil，初始化失败。*/
struct BudgetDetailScreen: View {
    
    @Environment(\.managedObjectContext) private var context
    let budget: Budget
    
    @State private var title: String = ""
    @State private var amount: Double?
    @State private var quantity: Int?
    @State private var selectedTags: Set<Tag> = []
    @State private var expenseToEdit: Expense?
    
    @FetchRequest(sortDescriptors: []) private var expenses: FetchedResults<Expense>
    
    @State private var editExpenseConfig: EditExpenseConfig?
    
    init(budget: Budget) {
        
        self.budget = budget
        _expenses = FetchRequest(sortDescriptors: [],predicate: NSPredicate(format: "budget == %@", budget))
        //从 Core Data 中筛选出与当前预算关联的所有开支记录
    }
    
    private var isFormValid: Bool {
        !title.isEmptyOrWhitespace && amount != nil && Double(amount!) > 0 && !selectedTags.isEmpty && quantity != nil && Int(quantity!) > 0
    }
    
 
    private func addExpense() {
        
        let expense = Expense(context: context)
        expense.title = title
        expense.amount = amount ?? 0
        expense.quantity = Int16(quantity ?? 0)
        expense.dateCreated = Date()
        expense.tags = NSSet(array: Array(selectedTags))
        
        budget.addToExpenses(expense)
        do{
            try context.save()
            title = ""
            amount = nil
            quantity = nil
            selectedTags = []
        } catch {
            context.rollback()
            print(error.localizedDescription)
            //为错误对象提供一个本地化的描述字符串，方便开发者或用户理解发生了什么错误。
        }
    }
    
    private func deleteExpense(_ indextSet: IndexSet) {
        indextSet.forEach { index in
            let expense = expenses[index]
            context.delete(expense)
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    var body: some View {
        
        VStack {
            Text(budget.limit, format: .currency(code: Locale.currencyCode))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
        }
        Form{
            Section("New expense") {
                TextField("Title", text: $title)
                TextField("Amount", value: $amount, format: .number)
                    .keyboardType(.numberPad)
                TextField("Quantity", value: $quantity, format: .number)
                TagsView(selectedTags: $selectedTags)
                
                Button(action: {
                    addExpense()
                }, label: {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                }).buttonStyle(.borderedProminent)
                    .disabled(!isFormValid)
            }
            Section("Expense") {
                
                List{
                    VStack{
                        HStack {
                            Spacer()
                            Text("Total")
                            Text(budget.spent, format: .currency(code: Locale.currencyCode))
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Text("Remaining")
                            Text(budget.remaining, format: .currency(code: Locale.currencyCode))
                                .foregroundStyle(budget.remaining < 0 ? .red: .green)
                            Spacer()
                        }
                    }
                    ForEach(expenses) { expense in
                        ExpenseCellView(expense: expense)
                            .onLongPressGesture{
                               // expenseToEdit = expense
                                editExpenseConfig = EditExpenseConfig(expenseObjectID: expense.objectID, context: context)
                            }
                    }.onDelete(perform: deleteExpense)
                }
            }
        }.navigationTitle(budget.title ?? "")
            .sheet(item: $editExpenseConfig) { editExpenseConfig in
                NavigationStack{
                    EditExpenseScreen(expense: editExpenseConfig.expense) {
                        
                        do {
                            try context.save()
                            self.editExpenseConfig = nil
                        } catch {
                            print(error)
                        }
                    }
                    .environment(\.managedObjectContext, editExpenseConfig.childContext)
                }
            }
           /* .sheet(item: $expenseToEdit) { expenseToEdit in
                NavigationStack{
                    EditExpenseScreen(expense: expenseToEdit)
                }
            }*/
    }
}

struct BudgetDetailScreenContainer: View {
    
    @FetchRequest(sortDescriptors: []) private var budgets: FetchedResults<Budget>
    
    var body: some View {
        BudgetDetailScreen(budget: budgets.first(where: { $0.title == "Groceries"})!)
    }
}
#Preview {
    NavigationStack{
        BudgetDetailScreenContainer()
            .environment(\.managedObjectContext, CoreDataProvider.preview.context)
    }
}

