//
//  Budget+Extensions.swift
//  BudgetApp
//
//  Created by 珠穆朗玛小蜜蜂 on 2025/3/18.
//

import Foundation
import CoreData

extension Budget {
    
    static func exists(context: NSManagedObjectContext, title: String) -> Bool {
        
        let request = Budget.fetchRequest() //生成针对 Budget 实体的查询请求。
        request.predicate = NSPredicate(format: "title == %@", title) /*通过 NSPredicate 指定过滤条件：title 属性等于传入的 title 参数。
        ​等价于 SQL 的 WHERE title = 'xxx'。*/
        
        do {
            let results = try context.fetch(request)
            return !results.isEmpty
        } catch {
            return false
        }
    }
    
    var spent: Double {
        
        guard let expenses = expenses as? Set<Expense> else { return 0}
        return expenses.reduce(0) { total, expense in
            return total + (expense.amount * Double(expense.quantity))
        }
    }
    
    var remaining: Double {
        limit - spent
    }
}

