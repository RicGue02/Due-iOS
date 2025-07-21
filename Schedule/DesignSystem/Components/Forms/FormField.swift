//
//  FormField.swift
//  Fisioflow - Design System Components
//
//  Created by Ricardo Guerrero Godínez on 14/7/25.
//

import SwiftUI

// MARK: - Text Form Field
struct FormField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let isRequired: Bool
    let errorMessage: String?
    let keyboardType: UIKeyboardType
    let autocapitalization: TextInputAutocapitalization
    let isSecure: Bool
    
    init(
        title: String,
        placeholder: String,
        text: Binding<String>,
        isRequired: Bool = false,
        errorMessage: String? = nil,
        keyboardType: UIKeyboardType = .default,
        autocapitalization: TextInputAutocapitalization = .sentences,
        isSecure: Bool = false
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.isRequired = isRequired
        self.errorMessage = errorMessage
        self.keyboardType = keyboardType
        self.autocapitalization = autocapitalization
        self.isSecure = isSecure
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            // Label
            HStack(spacing: Spacing.xs) {
                Text(title)
                    .textStyle(.formLabel)
                
                if isRequired {
                    Text("*")
                        .textStyle(.formLabel)
                        .foregroundColor(.error)
                }
            }
            
            // Input Field
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                        .textInputAutocapitalization(autocapitalization)
                }
            }
            .font(.body)
            .padding(.horizontal, Spacing.md)
            .frame(height: Spacing.inputHeight)
            .background(Color.surfaceSecondary)
            .cornerRadius(Spacing.radiusSmall)
            .overlay(
                RoundedRectangle(cornerRadius: Spacing.radiusSmall)
                    .stroke(
                        errorMessage != nil ? Color.error : Color.border,
                        lineWidth: errorMessage != nil ? 2 : 1
                    )
            )
            
            // iOS 17 Error Message with Icon
            if let errorMessage = errorMessage {
                HStack(spacing: Spacing.xs) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.error)
                    
                    Text(errorMessage)
                        .textStyle(.formError)
                }
            }
        }
    }
}

