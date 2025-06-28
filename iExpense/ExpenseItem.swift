//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Deepak Kumar Behera on 04/06/25.
//

import SwiftUI
import SwiftData

@Model
class ExpenseItem {
    var name: String
    var type: String
    var cost: Double
    var createdAt: Date
    var lastModified: Date
    var icon: String
    var color: String
    
    init(name: String, type: String, cost: Double, createdAt: Date, lastModified: Date, icon: String, color: String) {
        self.name = name
        self.type = type
        self.cost = cost
        self.createdAt = createdAt
        self.lastModified = lastModified
        self.icon = icon
        self.color = color
    }
}
