//
//  ExpenseRow.swift
//  iExpense
//
//  Created by DEEPAK BEHERA on 26/06/25.
//
import SwiftUI


struct ExpenseRow: View {
    let item: ExpenseItem
    
    /// Convert stored string back to a Color
    private var tint: Color {
        AppColor(rawValue: item.color)?.color ?? .accentColor
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: item.icon)
                .font(.title3)
                .symbolVariant(.fill)
                .foregroundStyle(.white)
                .padding(8)
                .background(tint)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline.weight(.semibold))
                    .lineLimit(1)
                
                Text(item.type)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer(minLength: 8)
            
            Text(item.cost,
                 format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .font(.subheadline.monospacedDigit())
                .bold()
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}

