//
//  Typography.swift
//  Fisioflow - Design System
//
//  Created by Ricardo Guerrero Godínez on 14/7/25.
//

import SwiftUI

// MARK: - Typography Scale
extension Font {
    // Display Fonts (Large titles)
    static let displayLarge = Font.system(size: 32, weight: .semibold, design: .default)
    static let displayMedium = Font.system(size: 28, weight: .semibold, design: .default)
    static let displaySmall = Font.system(size: 24, weight: .semibold, design: .default)
    
    // Heading Fonts
    static let headingLarge = Font.system(size: 20, weight: .semibold, design: .default)
    static let headingMedium = Font.system(size: 18, weight: .semibold, design: .default)
    static let headingSmall = Font.system(size: 16, weight: .semibold, design: .default)
    
    // Body Fonts
    static let bodyLarge = Font.system(size: 17, weight: .regular, design: .default)
    static let bodyMedium = Font.system(size: 15, weight: .regular, design: .default)
    static let bodySmall = Font.system(size: 14, weight: .regular, design: .default)
    
    // Label Fonts
    static let labelLarge = Font.system(size: 13, weight: .medium, design: .default)
    static let labelMedium = Font.system(size: 12, weight: .medium, design: .default)
    static let labelSmall = Font.system(size: 11, weight: .medium, design: .default)
    
    // Caption Fonts
    static let captionLarge = Font.system(size: 12, weight: .regular, design: .default)
    static let captionSmall = Font.system(size: 10, weight: .regular, design: .default)
}

// MARK: - iOS 17 Text Styles
struct TextStyle {
    let font: Font
    let color: Color
    let lineSpacing: CGFloat
    let kerning: CGFloat
    
    init(font: Font, color: Color = .labelPrimary, lineSpacing: CGFloat = 0, kerning: CGFloat = 0) {
        self.font = font
        self.color = color
        self.lineSpacing = lineSpacing
        self.kerning = kerning
    }
}

// MARK: - iOS 17 Semantic Text Styles
extension TextStyle {
    // iOS 17 Navigation & Page Titles
    static let navigationTitle = TextStyle(
        font: .largeTitle,
        color: .labelPrimary,
        lineSpacing: 1.2,
        kerning: -0.5
    )
    
    static let screenTitle = TextStyle(
        font: Font.title.weight(.semibold),
        color: .labelPrimary,
        lineSpacing: 1.0
    )
    
    static let sectionTitle = TextStyle(
        font: Font.title3.weight(.semibold),
        color: .labelPrimary
    )
    
    // iOS 17 Form Styles
    static let formLabel = TextStyle(
        font: .headline,
        color: .labelPrimary
    )
    
    static let formValue = TextStyle(
        font: .body,
        color: .labelPrimary
    )
    
    static let formCaption = TextStyle(
        font: .caption,
        color: .labelSecondary
    )
    
    static let formError = TextStyle(
        font: .caption,
        color: .error
    )
    
    // iOS 17 List Styles
    static let listTitle = TextStyle(
        font: .body,
        color: .labelPrimary
    )
    
    static let listSubtitle = TextStyle(
        font: .subheadline,
        color: .labelSecondary
    )
    
    static let listCaption = TextStyle(
        font: .caption,
        color: .labelTertiary
    )
    
    // iOS 17 Status & Badge Styles
    static let statusLabel = TextStyle(
        font: Font.caption.weight(.medium),
        color: .white,
        kerning: 0.3
    )
    
    static let badge = TextStyle(
        font: Font.caption2.weight(.semibold),
        color: .white,
        kerning: 0.2
    )
    
    // iOS 17 Button Styles
    static let buttonPrimary = TextStyle(
        font: Font.body.weight(.semibold),
        color: .white
    )
    
    static let buttonSecondary = TextStyle(
        font: Font.body.weight(.medium),
        color: .brandBlue
    )
    
    static let buttonTertiary = TextStyle(
        font: .body,
        color: .labelPrimary
    )
    
    // iOS 17 Accessibility
    static let accessibilityLabel = TextStyle(
        font: .body,
        color: .labelPrimary
    )
}

// MARK: - iOS 17 Text View Modifier
struct StyledText: ViewModifier {
    let style: TextStyle
    
    func body(content: Content) -> some View {
        content
            .font(style.font)
            .foregroundColor(style.color)
            .lineSpacing(style.lineSpacing)
            .tracking(style.kerning)
    }
}

// MARK: - iOS 17 Text Extensions
extension View {
    func textStyle(_ style: TextStyle) -> some View {
        self.modifier(StyledText(style: style))
    }
    
    // iOS 17 Quick Style Modifiers
    func navigationTitleStyle() -> some View {
        self.textStyle(.navigationTitle)
    }
    
    func screenTitleStyle() -> some View {
        self.textStyle(.screenTitle)
    }
    
    func sectionTitleStyle() -> some View {
        self.textStyle(.sectionTitle)
    }
    
    func listTitleStyle() -> some View {
        self.textStyle(.listTitle)
    }
    
    func listSubtitleStyle() -> some View {
        self.textStyle(.listSubtitle)
    }
    
    func listCaptionStyle() -> some View {
        self.textStyle(.listCaption)
    }
    
    func formLabelStyle() -> some View {
        self.textStyle(.formLabel)
    }
}

// MARK: - iOS 17 Dynamic Type Support
extension Font {
    /// Returns font that scales with Dynamic Type
    static func scaledSystem(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> Font {
        Font.system(size: size, weight: weight, design: design)
    }
    
    /// Returns font optimized for accessibility
    static func accessible(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        Font.system(size: max(size, 17), weight: weight)  // Minimum 17pt for accessibility
    }
}