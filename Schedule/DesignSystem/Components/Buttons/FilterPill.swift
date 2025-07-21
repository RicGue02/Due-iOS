//
//  FilterPill.swift
//  Fisioflow - Design System Components
//
//  Created by Ricardo Guerrero Godínez on 14/7/25.
//

import SwiftUI

// MARK: - Filter Pill Component
struct FilterPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    init(
        title: String,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isSelected = isSelected
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .foregroundColor(isSelected ? .white : .labelPrimary)
                .padding(.horizontal, Spacing.lg)
                .padding(.vertical, Spacing.sm)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.brandBlue : Color.surfaceSecondary)
                        .shadow(
                            color: isSelected ? Color.brandBlue.opacity(0.3) : Color.clear,
                            radius: isSelected ? 4 : 0,
                            x: 0,
                            y: isSelected ? 2 : 0
                        )
                )
                .overlay(
                    Capsule()
                        .stroke(
                            isSelected ? Color.clear : Color.border.opacity(0.3),
                            lineWidth: isSelected ? 0 : 0.5
                        )
                )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Filter Pills Container
struct FilterPills<T: RawRepresentable & CaseIterable & Hashable>: View where T.RawValue == String {
    let options: [T]
    @Binding var selectedOption: T
    
    init(options: [T], selectedOption: Binding<T>) {
        self.options = options
        self._selectedOption = selectedOption
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.sm) {
                ForEach(options, id: \.self) { option in
                    FilterPill(
                        title: option.rawValue,
                        isSelected: selectedOption == option
                    ) {
                        selectedOption = option
                    }
                }
            }
            .padding(.horizontal, Spacing.screenPadding)
        }
    }
}

// MARK: - Preview
#if DEBUG
enum SampleFilter: String, CaseIterable {
    case all = "Todos"
    case upcoming = "Próximas"
    case today = "Hoy"
    case week = "Semana"
}

struct FilterPill_Previews: PreviewProvider {
    @State static var selectedFilter: SampleFilter = .upcoming
    
    static var previews: some View {
        VStack(spacing: Spacing.lg) {
            // Individual Pills
            HStack(spacing: Spacing.sm) {
                FilterPill(title: "Próximas", isSelected: true) {}
                FilterPill(title: "Hoy", isSelected: false) {}
                FilterPill(title: "Semana", isSelected: false) {}
            }
            
            // Pills Container
            FilterPills(
                options: SampleFilter.allCases,
                selectedOption: $selectedFilter
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Filter Pills")
    }
}
#endif