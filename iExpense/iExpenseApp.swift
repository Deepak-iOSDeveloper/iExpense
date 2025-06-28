//
//  iExpenseApp.swift
//  iExpense
//
//  Created by Deepak Kumar Behera on 03/06/25.
//

import SwiftUI

@main
struct iExpenseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ExpenseItem.self, isAutosaveEnabled: true)
    }
}
