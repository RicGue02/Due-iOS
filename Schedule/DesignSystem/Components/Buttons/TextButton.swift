//
//  TextButton.swift
//  Fisioflow - Design System Components
//
//  Created by Ricardo Guerrero Godínez on 14/7/25.
//

import SwiftUI

// MARK: - Text Button
struct TextButton: View {
    let title: String
    let color: Color
    let isEnabled: Bool
    let action: () -> Void
    
    init(
        title: String,
        color: Color = .brandBlue,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.color = color
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .textStyle(.buttonSecondary)
                .foregroundColor(isEnabled ? color : .disabled)
        }
        .disabled(!isEnabled)
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
#if DEBUG
struct TextButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: Spacing.lg) {
            TextButton(title: "¿Olvidaste tu contraseña?") {
                print("Text button tapped")
            }
            
            TextButton(
                title: "Texto deshabilitado",
                isEnabled: false
            ) {
                print("Disabled button tapped")
            }
            
            TextButton(
                title: "Texto de error",
                color: .error
            ) {
                print("Error button tapped")
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Text Button")
    }
}
#endif