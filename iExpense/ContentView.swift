//
//  ContentView.swift
//  iExpense
//
//  Created by Deepak Kumar Behera on 03/06/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @State private var types = [
        "Personal", "Business", "All"
    ]
    @State private var type = "All"
    @Query(sort: \ExpenseItem.name, animation: .easeInOut) var expenseItems: [ExpenseItem]
    
    @State private var sortOrder = [
        SortDescriptor(\ExpenseItem.name),
        SortDescriptor(\ExpenseItem.cost),
    ]
    @State private var showAddExpenseView = false
    @State private var showMinimum = false
    @State private var minimumCost = 0.0
    
    var filteredItems: [ExpenseItem] {
        expenseItems.filter { item in
            (type == "All" || item.type == type) && item.cost >= minimumCost
        }
        .sorted(using: sortOrder)
    }
    var body: some View {
        NavigationStack {
            VStack {
                ListView(items: filteredItems)
            }
            .navigationTitle("iExpense")
            .sheet(isPresented: $showAddExpenseView, content: {
                AddExpense()
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add expense", systemImage: "plus") {
                        showAddExpenseView = true
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Sort by name")
                                .tag([
                                    SortDescriptor(\ExpenseItem.name),
                                    SortDescriptor(\ExpenseItem.cost),
                                ])
                            Text("Sort by amount")
                                .tag([
                                    SortDescriptor(\ExpenseItem.cost),
                                    SortDescriptor(\ExpenseItem.name),
                                ])
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Picker("sort by type", selection: $type) {
                        ForEach(types, id: \.self) {
                            Text("\($0)")
                        }
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("filter", systemImage: "camera.filters") {
                        showMinimum = true
                    }
                }
            }
            .alert("Add minimum amount", isPresented: $showMinimum) {
                TextField("minimum amount", value: $minimumCost, format: .number)
                Button("ok") {
                    showMinimum = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
