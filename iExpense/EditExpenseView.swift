//
//  EditExpenseView.swift
//  iExpense
//
//  Created by DEEPAK BEHERA on 26/06/25.
//
//
import SwiftUI
import SwiftData

struct EditExpenseView: View {
    @Bindable var expenseItem: ExpenseItem
    
    // Editable state properties
    @State private var name: String
    @State private var type: ExpenseType
    @State private var cost: Double
    @State private var color: AppColor
    @State private var icon: Icon

    @FocusState private var nameFieldFocused: Bool
    @Environment(\.dismiss) private var dismiss

    // MARK: – Init
    init(expenseItem: ExpenseItem) {
        _expenseItem = Bindable(expenseItem)
        _name  = State(initialValue: expenseItem.name)
        _type  = State(initialValue: ExpenseType(rawValue: expenseItem.type) ?? .personal)
        _cost  = State(initialValue: expenseItem.cost)
        _color = State(initialValue: AppColor(rawValue: expenseItem.color) ?? .accent)
        _icon  = State(initialValue: Icon.allCases.first { $0.systemName == expenseItem.icon } ?? .bag)
    }

    // MARK: – Body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: Name & Amount
                    Group {
                        TextField("Expense name", text: $name)
                            .focused($nameFieldFocused)
                            .submitLabel(.next)
                            .textFieldStyle(.roundedBorder)
                        
                        TextField("Amount",
                                  value: $cost,
                                  format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .keyboardType(.decimalPad)
                            .submitLabel(.done)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    // MARK: Type Picker
                    Picker("Type", selection: $type) {
                        ForEach(ExpenseType.allCases) {
                            Text($0.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    // MARK: Color Grid
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Choose a color").font(.headline)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                            ForEach(AppColor.allCases) { colorOption in
                                Button {
                                    color = colorOption
                                } label: {
                                    Circle()
                                        .fill(colorOption.color)
                                        .frame(width: 30, height: 30)
                                        .overlay(
                                            Circle()
                                                .stroke(color == colorOption ? Color.primary : .clear, lineWidth: 2)
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    
                    // MARK: Icon Grid
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Choose an icon").font(.headline)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 15) {
                            ForEach(Icon.allCases) { iconOption in
                                Button {
                                    icon = iconOption
                                } label: {
                                    VStack {
                                        Image(systemName: iconOption.systemName)
                                            .font(.title2)
                                        Text(iconOption.rawValue)
                                            .font(.caption2)
                                            .lineLimit(1)
                                    }
                                    .padding(8)
                                    .frame(maxWidth: .infinity)
                                    .background(icon == iconOption ? Color.accentColor.opacity(0.2) : Color.clear)
                                    .cornerRadius(10)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Edit item: \(expenseItem.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                    }
                    .disabled(name.isEmpty || cost <= 0)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    nameFieldFocused = true
                }
            }
        }
    }

    // MARK: – Save Changes
    private func saveChanges() {
        guard !name.isEmpty, cost > 0 else { return }

        expenseItem.name         = name
        expenseItem.type         = type.rawValue
        expenseItem.cost         = cost
        expenseItem.color        = color.rawValue
        expenseItem.icon         = icon.systemName
        expenseItem.lastModified = .now

        dismiss()
    }
}
