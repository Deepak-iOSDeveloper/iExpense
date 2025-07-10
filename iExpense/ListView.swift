//
//  ListView.swift
//  iExpense
//
//  Created by DEEPAK BEHERA on 26/06/25.
//
import SwiftUI
import SwiftData

struct ListView: View {
    var items: [ExpenseItem]
    
    var body: some View {
        List(items, id: \.self) { item in
            NavigationLink {
                EditExpenseView(expenseItem: item)
            } label: {
                ExpenseRow(item: item)
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init())
                    .accessibilityLabel("\(item.name) \(item.cost)")
                    .accessibilityHint(item.type)
            }
        }
        .listStyle(.plain)
    }
}

