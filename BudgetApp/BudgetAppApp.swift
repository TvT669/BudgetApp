//
//  BudgetAppApp.swift
//  BudgetApp
//
//  Created by 珠穆朗玛小蜜蜂 on 2025/3/17.
//

import SwiftUI

@main
struct BudgetAppApp: App {
    
    let provider: CoreDataProvider
    let tagsSeeder: TagSeeder
    
    init(){
        provider = CoreDataProvider()
        tagsSeeder = TagSeeder(context: provider.context)
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                BudgetListScreen()
                    .onAppear(){
                        let hasSeededData = UserDefaults.standard.bool(forKey: "hasSeedData")
                        //检查应用是否已经执行过预设标签（tags）的数据初始化
                        if !hasSeededData {
                            
                            let commonTags = ["Food", "Dining", "Travel", "Entertainment", "Shopping", "Transportation", "Utilities", "Groceries", "Health", "Education"]
                            do {
                                try tagsSeeder.seed(commonTags)
                                UserDefaults.standard.setValue(true,forKey: "hasSeedData")
                            } catch {
                                print(error)
                            }
                        }
                    }
            }
            .environment(\.managedObjectContext, provider.context)
            }
        }
    }

