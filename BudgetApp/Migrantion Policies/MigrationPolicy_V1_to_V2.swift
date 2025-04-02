//
//  MigrationPolicy_V1_to_V2.swift
//  BudgetApp
//
//  Created by 珠穆朗玛小蜜蜂 on 2025/3/26.
//

import Foundation
import CoreData

class  MigrationPolicy_V1_to_V2: NSEntityMigrationPolicy {
    
    override func begin(_ mapping: NSEntityMapping, with manager: NSMigrationManager) throws {
        
        var titles: [String] = []
        var index: Int = 1
        
        let context = manager.sourceContext
        let expenseRequest = Expense.fetchRequest()
        
        let results: [NSManagedObject] = try context.fetch(expenseRequest)
        
        for result in results {
            
            guard let title = result.value(forKey: "title") as? String else { continue}
            if !titles.contains(title) {
                titles.append(title)
            } else {
                let uniqueTitle = title + "\(index)"
                index += 1
                result.setValue(uniqueTitle, forKey: "title")
            }
        }
    }
}

/*override func begin(_ mapping: NSEntityMapping, with manager: NSMigrationManager) throws {
 // 1. 准备去重工具
 var titles: [String] = [] // 记录已存在的标题
 var index: Int = 1         // 用于生成唯一编号
 
 // 2. 获取旧数据库中的 Expense 数据
 let context = manager.sourceContext // 旧数据库的上下文
 let expenseRequest = Expense.fetchRequest() // 查询请求
 let results: [NSManagedObject] = try context.fetch(expenseRequest) // 执行查询
 
 // 3. 遍历每条记录
 for result in results {
     guard let title = result.value(forKey: "title") as? String else { continue }
     
     // 4. 检查标题是否重复
     if !titles.contains(title) {
         titles.append(title) // 记录非重复标题
     } else {
         // 5. 生成唯一标题（例如 "Food1"）
         let uniqueTitle = title + "\(index)"
         index += 1
         // 6. 更新记录的标题
         result.setValue(uniqueTitle, forKey: "title")
     }
 }
}*/
