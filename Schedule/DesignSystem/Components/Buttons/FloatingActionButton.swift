//
//  FloatingActionButton.swift
//  Fisioflow - Design System Components
//
//  Created by Ricardo Guerrero Godínez on 15/7/25.
//

import SwiftUI

// MARK: - Floating Action Button
struct FloatingActionButton: View {
    let icon: String
    let action: () -> Void
    
    init(icon: String = "plus", action: @escaping () -> Void) {
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(
                    Circle()
                        .fill(Color.brandBlue)
                        .shadow(color: Color.brandBlue.opacity(0.3), radius: 8, x: 0, y: 4)
                )
        }
        .accessibilityLabel(icon == "plus" ? "Agregar nueva entrada" : "Botón de acción")
        .accessibilityHint("Toca para agregar un nuevo elemento")
        .scaleEffect(1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.6), value: icon)
    }
}

// MARK: - Preview
struct FloatingActionButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: Spacing.xl) {
            FloatingActionButton(icon: "plus") {
                print("FAB tapped")
            }
            
            FloatingActionButton(icon: "xmark") {
                print("Close tapped")
            }
        }
        .padding()
        .background(Color.surfacePrimary)
    }
}