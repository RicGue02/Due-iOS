//
//  PrimaryButton.swift
//  Fisioflow - Design System Components
//  iOS 17+ Modern Button System
//
//  Created by Ricardo Guerrero Godínez on 14/7/25.
//

import SwiftUI

// MARK: - Primary Button
struct PrimaryButton: View {
    let title: String
    let icon: String?
    let isLoading: Bool
    let isDisabled: Bool
    let action: () -> Void
    
    init(
        title: String,
        icon: String? = nil,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: Spacing.iconSmall, weight: .semibold))
                        .symbolRenderingMode(.monochrome)  // iOS 17 symbol rendering
                }
                
                Text(title)
                    .textStyle(.buttonPrimary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: Spacing.buttonHeight)
            .background(
                isDisabled ? Color.fillQuaternary : Color.brandBlue
            )
            .cornerRadius(Spacing.radiusMedium)
            .shadow(color: Color.black.opacity(isDisabled ? 0 : 0.1), radius: 2, x: 0, y: 2)  // iOS 17 shadow
        }
        .disabled(isDisabled || isLoading)
        .buttonStyle(ModernButtonStyle())  // Custom iOS 17 button style
        .animation(.easeInOut(duration: 0.2), value: isDisabled)
    }
}

// MARK: - Destructive Button
struct DestructiveButton: View {
    let title: String
    let icon: String?
    let isLoading: Bool
    let isDisabled: Bool
    let action: () -> Void
    
    init(
        title: String,
        icon: String? = nil,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: Spacing.iconSmall, weight: .semibold))
                        .symbolRenderingMode(.monochrome)
                }
                
                Text(title)
                    .textStyle(.buttonPrimary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: Spacing.buttonHeight)
            .background(
                isDisabled ? Color.fillQuaternary : Color.error
            )
            .cornerRadius(Spacing.radiusMedium)
            .shadow(color: Color.error.opacity(isDisabled ? 0 : 0.2), radius: 2, x: 0, y: 2)
        }
        .disabled(isDisabled || isLoading)
        .buttonStyle(ModernButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isDisabled)
    }
}

// MARK: - iOS 17 Modern Button Style
struct ModernButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// Note: IconButton, FloatingActionButton, and TextButton moved to separate files for better organization

// MARK: - Preview
struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: Spacing.lg) {
            PrimaryButton(
                title: "Guardar Paciente",
                icon: "checkmark"
            ) {
                print("Primary button tapped")
            }
            
            SecondaryButton(
                title: "Cancelar",
                icon: "xmark"
            ) {
                print("Secondary button tapped")
            }
            
            DestructiveButton(
                title: "Eliminar",
                icon: "trash"
            ) {
                print("Destructive button tapped")
            }
            
            PrimaryButton(
                title: "Cargando...",
                isLoading: true
            ) {
                print("Loading button tapped")
            }
            
            HStack(spacing: Spacing.md) {
                IconButton(icon: "pencil") {
                    print("Edit tapped")
                }
                
                IconButton(
                    icon: "trash",
                    color: .error,
                    backgroundColor: .error.opacity(0.1)
                ) {
                    print("Delete tapped")
                }
                
                Spacer()
                
                FloatingActionButton {
                    print("FAB tapped")
                }
            }
            
            TextButton(title: "¿Olvidaste tu contraseña?") {
                print("Text button tapped")
            }
        }
        .screenPadding()
        .background(Color.surfacePrimary)
        .previewLayout(.sizeThatFits)
    }
}