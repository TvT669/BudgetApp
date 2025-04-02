//
//  TagSeeder.swift
//  BudgetApp
//
//  Created by 珠穆朗玛小蜜蜂 on 2025/3/23.
//

import Foundation
import CoreData

class TagSeeder {
    
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func seed(_ commonTags: [String]) throws {
        
        for commonTag in commonTags {
            let tag = Tag(context: context)
            tag.name = commonTag
                try context.save()
            
        }
    }
}


