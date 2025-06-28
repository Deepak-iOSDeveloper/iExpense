//
//  AddExpense.swift
//  iExpense
//
//  Created by Deepak Kumar Behera on 04/06/25.
//

import SwiftUI
import SwiftData

// MARK: - AddExpense View
struct AddExpense: View {
    // ───────────────────────── State
    @State private var name = ""
    @State private var type: ExpenseType = .personal
    @State private var amount: Double?
    @State private var icon: Icon = .bag
    @State private var color: AppColor = .accent
    @State private var selectedCategory: IconCategory = .travel

    @FocusState private var nameFieldFocused: Bool
    @Environment(\.dismiss)      private var dismiss
    @Environment(\.modelContext) private var modelContext

    // ───────────────────────── UI
    var body: some View {
        NavigationStack {
            Form {
                detailsSection
                colorSection
                iconSection
            }
            .navigationTitle("New Expense")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                        .disabled(name.isEmpty || (amount ?? 0) <= 0)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear {
                // Auto‑focus the name field shortly after the sheet appears
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    nameFieldFocused = true
                }
            }
        }
    }

    // ───────────────────────── Sections
    private var detailsSection: some View {
        Section("Details") {
            TextField("Expense name", text: $name)
                .focused($nameFieldFocused)
                .submitLabel(.next)

            VStack {
                TextField("Amount",
                          value: $amount,
                          format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
                    .submitLabel(.done)

                Picker("Type", selection: $type) {
                    ForEach(ExpenseType.allCases) { Text($0.rawValue) }
                }
                .pickerStyle(.segmented)
            }
        }
    }

    private var colorSection: some View {
        Section("Color") {
            let columns = [GridItem(.adaptive(minimum: 44))]
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(AppColor.allCases) { colorOption in
                    Button {
                        color = colorOption
                    } label: {
                        Circle()
                            .fill(colorOption.color)
                            .frame(width: 36, height: 36)
                            .overlay(
                                Circle()
                                    .stroke(color == colorOption ? Color.primary : .clear, lineWidth: 3)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 4)
        }
    }

    private var iconSection: some View {
        Section("Emoji / Icon") {
            // Segmented category menu
            Picker("Category", selection: $selectedCategory) {
                ForEach(IconCategory.allCases) { Text($0.rawValue) }
            }
            .pickerStyle(.segmented)
            .padding(.vertical, 4)

            // Icons grid
            let columns = [GridItem(.adaptive(minimum: 60))]
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(Icon.allCases.filter { $0.category == selectedCategory }) { iconOption in
                    Button {
                        icon = iconOption
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: iconOption.systemName)
                                .font(.title2)
                                .frame(width: 44, height: 44)
                            Text(iconOption.rawValue.capitalized)
                                .font(.caption2)
                                .lineLimit(1)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(6)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(icon == iconOption ? Color.accentColor.opacity(0.25) : .clear)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(minHeight: 160)   // Keeps the form height steady
            .padding(.vertical, 4)
        }
    }

    // ───────────────────────── Actions
    private func save() {
        guard let amt = amount, !name.isEmpty, amt > 0 else { return }

        let expense = ExpenseItem(name: name,
                                  type: type.rawValue,
                                  cost: amt,
                                  createdAt: .now,
                                  lastModified: .now,
                                  icon: icon.systemName,
                                  color: color.rawValue)
        modelContext.insert(expense)
        dismiss()
    }
}

// MARK: - Supporting Types

/// Expense categories
enum ExpenseType: String, CaseIterable, Identifiable {
    case personal  = "Personal"
    case business  = "Business"
    case other     = "Other"

    var id: Self { self }
}

/// Palette of colors shown in the grid
enum AppColor: String, CaseIterable, Identifiable {
    // System colors + extras
    case accent, red, green, blue, yellow, purple, teal, gray, orange, pink,
         indigo, mint, cyan, brown, magenta,
         lavender, peach, skyBlue, lemon, coral,
         darkRed, darkGreen, darkBlue, lightPink, lightGreen, lightBlue,
         olive, maroon, gold, slate, salmon

    var id: Self { self }

    /// Actual SwiftUI Color used in UI
    var color: Color {
        switch self {
            // System Colors
        case .accent:   return .accentColor
        case .red:      return .red
        case .green:    return .green
        case .blue:     return .blue
        case .yellow:   return .yellow
        case .purple:   return .purple
        case .teal:     return .teal
        case .gray:     return .gray
        case .orange:   return .orange
        case .pink:     return .pink
        case .indigo:   return .indigo
        case .mint:     return .mint
        case .cyan:     return .cyan
        case .brown:    return .brown

            // Extra (approximated) colors
        case .magenta:      return Color(red: 1.0, green: 0.0, blue: 1.0)
        case .lavender:     return Color(red: 0.8, green: 0.6, blue: 1.0)
        case .peach:        return Color(red: 1.0, green: 0.8, blue: 0.6)
        case .skyBlue:      return Color(red: 0.5, green: 0.8, blue: 1.0)
        case .lemon:        return Color(red: 1.0, green: 1.0, blue: 0.6)
        case .coral:        return Color(red: 1.0, green: 0.5, blue: 0.5)
        case .darkRed:      return Color(red: 0.6, green: 0.0, blue: 0.0)
        case .darkGreen:    return Color(red: 0.0, green: 0.5, blue: 0.0)
        case .darkBlue:     return Color(red: 0.0, green: 0.0, blue: 0.6)
        case .lightPink:    return Color(red: 1.0, green: 0.8, blue: 0.9)
        case .lightGreen:   return Color(red: 0.7, green: 1.0, blue: 0.7)
        case .lightBlue:    return Color(red: 0.7, green: 0.9, blue: 1.0)
        case .olive:        return Color(red: 0.5, green: 0.5, blue: 0.0)
        case .maroon:       return Color(red: 0.5, green: 0.0, blue: 0.0)
        case .gold:         return Color(red: 1.0, green: 0.84, blue: 0.0)
        case .slate:        return Color(red: 0.44, green: 0.5, blue: 0.56)
        case .salmon:       return Color(red: 0.98, green: 0.5, blue: 0.45)
        }
    }

    /// Title shown in the picker
    var displayName: String {
        switch self {
        case .skyBlue:     return "Sky Blue"
        case .lightPink:   return "Light Pink"
        case .lightGreen:  return "Light Green"
        case .lightBlue:   return "Light Blue"
        case .darkRed:     return "Dark Red"
        case .darkGreen:   return "Dark Green"
        case .darkBlue:    return "Dark Blue"
        default:           return rawValue.capitalized
        }
    }
}

/// Categories used for the segmented icon picker
enum IconCategory: String, CaseIterable, Identifiable {
    case travel = "Travel ✈️"
    case food   = "Food 🍔"
    case work   = "Work 💼"
    case fun    = "Fun 🎮"
    case misc   = "Symbols ⭐️"

    var id: Self { self }
}

/// Icon choices (paired with SF Symbols)
enum Icon: String, CaseIterable, Identifiable {
    // Basic
    case wallet, creditcard, dollarsign, bag, cart
    // Business / Work
    case briefcase, building, printer, scanner, deskclock
    // Food
    case fork, wineglass, takeoutbag, cup, popcorn
    // Transportation
    case car, bus, tram, airplane, bicycle
    // Home
    case house, lightbulb, washingmachine, sofa, shower
    // Education
    case book, studentdesk, graduationcap, pencil, backpack
    // Health
    case heart, cross, pills, stethoscope, bandage
    // Entertainment / Fun
    case gamecontroller, ticket, tv, headphones, sportscourt
    // Shopping
    case tag, gift, tshirt, sunglasses, cosmetics
    // Utilities / Misc
    case wifi, phone, envelope, cloud, battery

    var id: Self { self }

    // SF Symbol mapping
    var systemName: String {
        switch self {
            // Basic
        case .wallet:        return "wallet.pass.fill"
        case .creditcard:    return "creditcard.fill"
        case .dollarsign:    return "dollarsign.circle.fill"
        case .bag:           return "bag.fill"
        case .cart:          return "cart.fill"
            // Business
        case .briefcase:     return "briefcase.fill"
        case .building:      return "building.2.fill"
        case .printer:       return "printer.fill"
        case .scanner:       return "scanner.fill"
        case .deskclock:     return "deskclock.fill"
            // Food
        case .fork:          return "fork.knife"
        case .wineglass:     return "wineglass.fill"
        case .takeoutbag:    return "takeoutbag.and.cup.and.straw.fill"
        case .cup:           return "cup.and.saucer.fill"
        case .popcorn:       return "popcorn.fill"
            // Transportation
        case .car:           return "car.fill"
        case .bus:           return "bus.fill"
        case .tram:          return "tram.fill"
        case .airplane:      return "airplane"
        case .bicycle:       return "bicycle"
            // Home
        case .house:         return "house.fill"
        case .lightbulb:     return "lightbulb.fill"
        case .washingmachine:return "washer.fill"
        case .sofa:          return "sofa.fill"
        case .shower:        return "shower.fill"
            // Education
        case .book:          return "book.closed.fill"
        case .studentdesk:   return "studentdesk"
        case .graduationcap: return "graduationcap.fill"
        case .pencil:        return "pencil.circle.fill"
        case .backpack:      return "backpack.fill"
            // Health
        case .heart:         return "heart.fill"
        case .cross:         return "cross.case.fill"
        case .pills:         return "pills.fill"
        case .stethoscope:   return "stethoscope"
        case .bandage:       return "bandage.fill"
            // Entertainment
        case .gamecontroller:return "gamecontroller.fill"
        case .ticket:        return "ticket.fill"
        case .tv:            return "tv.fill"
        case .headphones:    return "headphones"
        case .sportscourt:   return "sportscourt.fill"
            // Shopping
        case .tag:           return "tag.fill"
        case .gift:          return "gift.fill"
        case .tshirt:        return "tshirt.fill"
        case .sunglasses:    return "sunglasses.fill"
        case .cosmetics:     return "sparkles"
            // Utilities / Misc
        case .wifi:          return "wifi"
        case .phone:         return "phone.fill"
        case .envelope:      return "envelope.fill"
        case .cloud:         return "cloud.fill"
        case .battery:       return "battery.100"
        }
    }

    /// Category mapping for the segmented menu
    var category: IconCategory {
        switch self {
        case .car, .bus, .tram, .airplane, .bicycle,
             .wallet, .creditcard, .dollarsign, .bag, .cart:
            return .travel
        case .fork, .wineglass, .takeoutbag, .cup, .popcorn:
            return .food
        case .briefcase, .building, .printer, .scanner, .deskclock,
             .book, .studentdesk, .graduationcap, .pencil, .backpack:
            return .work
        case .gamecontroller, .ticket, .tv, .headphones, .sportscourt:
            return .fun
        default:
            return .misc
        }
    }
}
