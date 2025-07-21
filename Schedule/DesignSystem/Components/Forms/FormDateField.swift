//
//  FormDateField.swift
//  Fisioflow - Design System
//
//  Created by Ricardo Guerrero Godínez on 15/7/25.
//

import SwiftUI

// MARK: - Form Date Field Component

struct FormDateField: View {
    let title: String
    @Binding var date: Date
    let isRequired: Bool
    let errorMessage: String?
    let displayedComponents: DatePickerComponents
    
    init(title: String, date: Binding<Date>, isRequired: Bool = false, errorMessage: String? = nil, displayedComponents: DatePickerComponents = [.date]) {
        self.title = title
        self._date = date
        self.isRequired = isRequired
        self.errorMessage = errorMessage
        self.displayedComponents = displayedComponents
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
            
            DatePicker("", selection: $date, displayedComponents: displayedComponents)
                .datePickerStyle(.compact)
                .padding(Spacing.md)
                .background(Color.surfaceSecondary)
                .cornerRadius(Spacing.radiusSmall)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .textStyle(.formCaption)
                    .foregroundColor(.error)
            }
        }
    }
}

// MARK: - Preview
struct FormDateField_Previews: PreviewProvider {
    @State static var date = Date()
    
    static var previews: some View {
        VStack(spacing: Spacing.lg) {
            FormDateField(
                title: "Fecha de Nacimiento",
                date: $date,
                isRequired: true
            )
            
            FormDateField(
                title: "Fecha y Hora",
                date: $date,
                displayedComponents: [.date, .hourAndMinute]
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}