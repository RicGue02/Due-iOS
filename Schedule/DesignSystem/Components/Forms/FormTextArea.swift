//
//  FormTextArea.swift
//  Fisioflow - Design System
//
//  Created by Ricardo Guerrero Godínez on 15/7/25.
//

import SwiftUI

// MARK: - Form Text Area Component

struct FormTextArea: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let minHeight: CGFloat
    let isRequired: Bool
    
    init(title: String, placeholder: String, text: Binding<String>, minHeight: CGFloat = 100, isRequired: Bool = false) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.minHeight = minHeight
        self.isRequired = isRequired
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            
            HStack(spacing: Spacing.xs) {
                Text(title)
                    .textStyle(.formLabel)
                if isRequired {
                    Text("*")
                        .foregroundColor(.error)
                }
            }
            
            ZStack(alignment: .topLeading) {
                
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.labelTertiary)
                        .padding(Spacing.md)
                }
                
                TextEditor(text: $text)
                    .padding(Spacing.md)
                    .frame(minHeight: minHeight)
                    .background(Color.surfaceSecondary)
                    .cornerRadius(Spacing.radiusSmall)
            }
        }
    }
}

// MARK: - Preview
struct FormTextArea_Previews: PreviewProvider {
    @State static var notes = ""
    
    static var previews: some View {
        VStack(spacing: Spacing.lg) {
            FormTextArea(
                title: "Notas",
                placeholder: "Información adicional...",
                text: $notes
            )
            
            FormTextArea(
                title: "Notas (Requerido)",
                placeholder: "Información adicional...",
                text: $notes,
                minHeight: 120,
                isRequired: true
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}