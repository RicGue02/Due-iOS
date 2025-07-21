//
//  IconButton.swift
//  Fisioflow - Design System Components
//
//  Created by Ricardo Guerrero Godínez on 14/7/25.
//

import SwiftUI

// MARK: - Icon Button
struct IconButton: View {
    let icon: String
    let size: CGFloat
    let color: Color
    let backgroundColor: Color?
    let isEnabled: Bool
    let action: () -> Void
    
    init(
        icon: String,
        size: CGFloat = Spacing.iconMedium,
        color: Color = .primaryText,
        backgroundColor: Color? = nil,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.size = size
        self.color = color
        self.backgroundColor = backgroundColor
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size, weight: .medium))
                .foregroundColor(isEnabled ? color : .disabled)
                .frame(width: Spacing.buttonHeight, height: Spacing.buttonHeight)
                .background(
                    backgroundColor?.opacity(isEnabled ? 1.0 : 0.5) ?? Color.clear
                )
                .cornerRadius(Spacing.radiusSmall)
        }
        .disabled(!isEnabled)
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Close Button (for modals)
struct CloseButton: View {
    let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        IconButton(
            icon: "xmark",
            size: 18,
            color: .labelSecondary,
            backgroundColor: Color.surfaceSecondary,
            action: action
        )
    }
}

// MARK: - Preview
#if DEBUG
struct IconButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: Spacing.lg) {
            HStack(spacing: Spacing.md) {
                IconButton(icon: "heart") {}
                IconButton(icon: "star.fill", color: .warning) {}
                IconButton(icon: "trash", color: .error, isEnabled: false) {}
            }
            
            HStack(spacing: Spacing.md) {
                IconButton(
                    icon: "gear",
                    backgroundColor: Color.surfaceSecondary
                ) {}
                
                CloseButton {}
                
                FloatingActionButton {}
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Icon Buttons")
    }
}
#endif