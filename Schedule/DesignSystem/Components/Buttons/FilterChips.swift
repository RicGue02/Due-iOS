//
//  FilterChips.swift
//  Fisioflow - Design System Components
//  Universal Filter Component for consistent filtering across all screens
//
//  Created by Ricardo Guerrero Godínez on 16/7/25.
//

import SwiftUI

// MARK: - Filter Option Protocol
protocol FilterOption: Identifiable, Hashable, CaseIterable {
    var displayName: String { get }
    var icon: String? { get }
    var color: Color? { get }
}

// MARK: - Filter Style
enum FilterStyle {
    case pills      // Horizontal scrolling pills (default)
    case segmented  // iOS segmented control
    case toggle     // Binary toggle button
}

// MARK: - Universal Filter Chips Component
struct FilterChips<T: FilterOption>: View {
    let options: [T]
    @Binding var selectedOption: T
    let style: FilterStyle
    let includeHaptics: Bool
    
    init(
        options: [T],
        selectedOption: Binding<T>,
        style: FilterStyle = .pills,
        includeHaptics: Bool = true
    ) {
        self.options = options
        self._selectedOption = selectedOption
        self.style = style
        self.includeHaptics = includeHaptics
    }
    
    var body: some View {
        switch style {
        case .pills:
            pillsStyle
        case .segmented:
            segmentedStyle
        case .toggle:
            toggleStyle
        }
    }
    
    // MARK: - Pills Style (Default)
    private var pillsStyle: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.sm) {
                ForEach(options) { option in
                    FilterPill(
                        title: option.displayName,
                        isSelected: selectedOption.id == option.id
                    ) {
                        selectedOption = option
                        if includeHaptics {
                            HapticFeedback.selection()
                        }
                    }
                }
            }
            .padding(.horizontal, Spacing.screenPadding)
        }
    }
    
    // MARK: - Segmented Style
    private var segmentedStyle: some View {
        Picker("Filter", selection: $selectedOption) {
            ForEach(options) { option in
                Text(option.displayName)
                    .tag(option)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .onChange(of: selectedOption) { _ in
            if includeHaptics {
                HapticFeedback.selection()
            }
        }
    }
    
    // MARK: - Toggle Style (Binary)
    private var toggleStyle: some View {
        Button(action: {
            // For binary toggle, switch to the other option
            if let currentIndex = options.firstIndex(where: { $0.id == selectedOption.id }) {
                let nextIndex = (currentIndex + 1) % options.count
                selectedOption = options[nextIndex]
            }
            
            if includeHaptics {
                HapticFeedback.selection()
            }
        }) {
            HStack(spacing: Spacing.xs) {
                if let icon = selectedOption.icon {
                    Image(systemName: icon)
                        .font(.system(size: Spacing.iconSmall, weight: .medium))
                }
                
                Text(selectedOption.displayName)
                    .font(.subheadline.weight(.medium))
            }
            .foregroundColor(selectedOption.color ?? .brandBlue)
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, Spacing.xs)
            .background(
                RoundedRectangle(cornerRadius: Spacing.radiusSmall)
                    .fill((selectedOption.color ?? .brandBlue).opacity(0.1))
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: selectedOption.id)
    }
}

// MARK: - String-based Filter Option (Backward Compatibility)
struct StringFilterOption: FilterOption {
    let id: String
    let displayName: String
    let icon: String?
    let color: Color?
    
    init(id: String, displayName: String, icon: String? = nil, color: Color? = nil) {
        self.id = id
        self.displayName = displayName
        self.icon = icon
        self.color = color
    }
    
    static var allCases: [StringFilterOption] { [] } // To be overridden
}

// MARK: - Convenience Extensions
extension FilterChips where T: RawRepresentable, T.RawValue == String {
    init(
        selectedOption: Binding<T>,
        style: FilterStyle = .pills,
        includeHaptics: Bool = true
    ) where T: CaseIterable {
        self.init(
            options: Array(T.allCases),
            selectedOption: selectedOption,
            style: style,
            includeHaptics: includeHaptics
        )
    }
}

// MARK: - Preview
#if DEBUG
enum SampleFilterOption: String, CaseIterable, FilterOption {
    case all = "Todos"
    case upcoming = "Próximas"
    case today = "Hoy"
    case week = "Semana"
    
    var id: String { rawValue }
    var displayName: String { rawValue }
    var icon: String? { 
        switch self {
        case .all: return "doc.text"
        case .upcoming: return "clock"
        case .today: return "calendar"
        case .week: return "calendar.badge.clock"
        }
    }
    var color: Color? { .brandBlue }
}

enum BinaryFilterOption: String, CaseIterable, FilterOption {
    case all = "Todos los pacientes"
    case followUp = "Necesitan seguimiento"
    
    var id: String { rawValue }
    var displayName: String { rawValue }
    var icon: String? {
        switch self {
        case .all: return "person.2"
        case .followUp: return "person.badge.clock"
        }
    }
    var color: Color? {
        switch self {
        case .all: return .brandBlue
        case .followUp: return .warning
        }
    }
}

struct FilterChips_Previews: PreviewProvider {
    @State static var pillsFilter: SampleFilterOption = .upcoming
    @State static var segmentedFilter: SampleFilterOption = .today
    @State static var toggleFilter: BinaryFilterOption = .all
    
    static var previews: some View {
        VStack(spacing: Spacing.xl) {
            VStack(spacing: Spacing.md) {
                Text("Pills Style")
                    .font(.headline)
                
                FilterChips(
                    selectedOption: $pillsFilter,
                    style: .pills
                )
            }
            
            VStack(spacing: Spacing.md) {
                Text("Segmented Style")
                    .font(.headline)
                
                FilterChips(
                    selectedOption: $segmentedFilter,
                    style: .segmented
                )
                .padding(.horizontal)
            }
            
            VStack(spacing: Spacing.md) {
                Text("Toggle Style")
                    .font(.headline)
                
                FilterChips(
                    selectedOption: $toggleFilter,
                    style: .toggle
                )
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Filter Chips Styles")
    }
}
#endif