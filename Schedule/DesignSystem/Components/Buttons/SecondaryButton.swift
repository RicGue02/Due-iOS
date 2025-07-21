//
//  SecondaryButton.swift
//  Fisioflow - Design System Components
//
//  Created by Ricardo Guerrero Godínez on 15/7/25.
//

import SwiftUI

// MARK: - Secondary Button
struct SecondaryButton: View {
    let title: String
    let icon: String?
    let isLoading: Bool
    let isEnabled: Bool
    let action: () -> Void
    
    init(
        title: String,
        icon: String? = nil,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.sm) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .progressViewStyle(CircularProgressViewStyle(tint: .brandBlue))
                } else if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: Spacing.iconSmall, weight: .medium))
                }
                
                Text(title)
                    .textStyle(.buttonSecondary)
            }
            .foregroundColor(isEnabled ? .brandBlue : .labelTertiary)
            .frame(maxWidth: .infinity)
            .frame(height: Spacing.buttonHeight)
            .background(
                RoundedRectangle(cornerRadius: Spacing.radiusMedium)
                    .stroke(isEnabled ? Color.brandBlue : Color.border, lineWidth: 1.5)
                    .background(
                        RoundedRectangle(cornerRadius: Spacing.radiusMedium)
                            .fill(Color.surfacePrimary)
                    )
            )
        }
        .disabled(!isEnabled || isLoading)
        .animation(.easeInOut(duration: 0.2), value: isLoading)
    }
}

// MARK: - Preview
struct SecondaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: Spacing.lg) {
            SecondaryButton(title: "Secondary Action", icon: "arrow.clockwise") {
                print("Secondary button tapped")
            }
            
            SecondaryButton(title: "Loading...", icon: "arrow.clockwise", isLoading: true) {
                // Action
            }
            
            SecondaryButton(title: "Disabled", icon: "xmark", isEnabled: false) {
                // Action
            }
            
            SecondaryButton(title: "No Icon") {
                // Action
            }
        }
        .padding()
        .background(Color.surfaceGrouped)
    }
}