//
//  Colors.swift
//  Fisioflow - Design System
//  iOS 17+ Modern Color System
//
//  Created by Ricardo Guerrero Godínez on 14/7/25.
//

import SwiftUI

// MARK: - Modern iOS 17 Brand Colors
extension Color {
    // Primary Brand Colors (iOS 17 Dynamic)
    static let brandBlue = Color(red: 0.27, green: 0.52, blue: 0.96)
    static let brandBlueLight = Color(red: 0.40, green: 0.65, blue: 0.98)  // Better contrast for dark mode
    static let brandBlueDark = Color(red: 0.15, green: 0.35, blue: 0.75)   // Deeper for light mode
    
    // iOS 17 Semantic Colors (Adaptive)
    static let success = Color(.systemGreen)
    static let warning = Color(.systemOrange)
    static let error = Color(.systemRed)
    static let info = Color(.systemBlue)
    
    // iOS 17 Enhanced Accent Colors
    static let accent = Color(.systemBlue)
    static let accentSecondary = Color(.systemIndigo)
    static let accentTertiary = Color(.systemTeal)
    
    // iOS 17 Status Colors (Dynamic & Accessible)
    static let statusScheduled = Color(.systemOrange)
    static let statusConfirmed = Color(.systemBlue)
    static let statusArrived = Color(.systemIndigo)
    static let statusCompleted = Color(.systemGreen)
    static let statusCancelled = Color(.systemGray)
    
    // iOS 17 Materials & Surfaces (Enhanced)
    static let surfacePrimary = Color(.systemBackground)
    static let surfaceSecondary = Color(.secondarySystemBackground)
    static let surfaceTertiary = Color(.tertiarySystemBackground)
    static let surfaceGrouped = Color(.systemGroupedBackground)
    
    // iOS 17 Fill Colors for Depth
    static let fillPrimary = Color(.systemFill)
    static let fillSecondary = Color(.secondarySystemFill)
    static let fillTertiary = Color(.tertiarySystemFill)
    static let fillQuaternary = Color(.quaternarySystemFill)
    
    // Legacy Compatibility (Deprecated - Use surface* instead)
    @available(*, deprecated, message: "Use surfacePrimary instead")
    static let primaryBackground = Color(.systemBackground)
    @available(*, deprecated, message: "Use surfaceSecondary instead")
    static let secondaryBackground = Color(.secondarySystemBackground)
    @available(*, deprecated, message: "Use surfaceTertiary instead")
    static let tertiaryBackground = Color(.tertiarySystemBackground)
    @available(*, deprecated, message: "Use surfaceGrouped instead")
    static let groupedBackground = Color(.systemGroupedBackground)
    
    // iOS 17 Label Colors (Perfect Contrast)
    static let labelPrimary = Color(.label)
    static let labelSecondary = Color(.secondaryLabel)
    static let labelTertiary = Color(.tertiaryLabel)
    static let labelQuaternary = Color(.quaternaryLabel)
    
    // iOS 17 Separator Colors (Adaptive)
    static let separator = Color(.separator)
    static let separatorOpaque = Color(.opaqueSeparator)
    
    // iOS 17 Border System
    static let border = Color(.separator)
    static let lightBorder = Color(.quaternarySystemFill)
    static let mediumBorder = Color(.tertiarySystemFill)
    static let darkBorder = Color(.secondarySystemFill)
    
    // iOS 17 Interactive States
    static let disabled = Color(.quaternaryLabel)
    static let placeholder = Color(.placeholderText)
    
    // Legacy Compatibility
    static let primaryText = Color(.label)
    static let secondaryText = Color(.secondaryLabel)
    static let tertiaryText = Color(.tertiaryLabel)
}

// MARK: - iOS 17 Materials & Effects
extension Color {
    // iOS 17 Vibrancy Effects
    static let vibrancyPrimary = Color(.systemBackground).opacity(0.8)
    static let vibrancySecondary = Color(.secondarySystemBackground).opacity(0.6)
    
    // iOS 17 Overlay Colors
    static let overlayLight = Color.black.opacity(0.3)
    static let overlayDark = Color.white.opacity(0.1)
}

// MARK: - iOS 17 Color Utilities
extension Color {
    /// iOS 17 style contrasting text color with proper accessibility
    func contrastingTextColor() -> Color {
        return self == .brandBlue ? .white : .labelPrimary
    }
    
    /// Creates properly adapted lighter color for iOS 17
    func lighter(by percentage: Double = 0.15) -> Color {
        return self.opacity(1.0 - percentage)
    }
    
    /// Creates properly adapted darker color for iOS 17
    func darker(by percentage: Double = 0.15) -> Color {
        return Color.black.opacity(percentage)
    }
    
    /// iOS 17 style opacity variations
    func prominent() -> Color { self.opacity(1.0) }
    func secondary() -> Color { self.opacity(0.6) }
    func tertiary() -> Color { self.opacity(0.3) }
    func subtle() -> Color { self.opacity(0.1) }
}