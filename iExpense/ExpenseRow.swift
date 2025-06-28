import SwiftUI

struct ExpenseRow: View {
    let item: ExpenseItem
    
    // Pick an icon + tint based on type
    private var icon: (name: String, color: Color) {
        switch item.type {
        case "Business":
            return ("briefcase.fill", .blue)
        case "Personal":
            return ("person.crop.circle.fill", .green)
        default:
            return ("tray.fill", .gray)
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Leading icon in a colored circle
            Image(systemName: icon.name)
                .font(.title3)                 // size
                .symbolVariant(.fill)          // ensures filled style
                .foregroundStyle(.white)
                .padding(8)
                .background(icon.color)
                .clipShape(Circle())
            
            // Title & subtitle
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline.weight(.semibold))
                    .lineLimit(1)
                
                Text(item.type)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer(minLength: 8)
            
            // Amount, right-aligned
            Text(item.cost,
                 format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .font(.subheadline.monospacedDigit())
                .bold()
                .alignmentGuide(.firstTextBaseline) { d in d[.firstTextBaseline] }
        }
        .padding()
        .background(
            // Soft card background & shadow
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(uiColor: .systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
        .accessibilityElement(children: .combine) // nicer VoiceOver read-out
    }
}
