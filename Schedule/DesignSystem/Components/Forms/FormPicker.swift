//
//  FormPicker.swift
//  Fisioflow - Design System
//
//  Created by Ricardo Guerrero Godínez on 15/7/25.
//

import SwiftUI

// MARK: - Form Picker Component

struct FormPicker<T: CaseIterable & Hashable>: View where T.AllCases: RandomAccessCollection {
    let title: String
    @Binding var selection: T?
    let displayName: (T) -> String
    let isRequired: Bool
    let errorMessage: String?
    
    init(title: String, selection: Binding<T?>, displayName: @escaping (T) -> String, isRequired: Bool = false, errorMessage: String? = nil) {
        self.title = title
        self._selection = selection
        self.displayName = displayName
        self.isRequired = isRequired
        self.errorMessage = errorMessage
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
            
            Menu {
                Button("Ninguno") {
                    selection = nil
                }
                
                ForEach(Array(T.allCases), id: \.self) { option in
                    Button(displayName(option)) {
                        selection = option
                    }
                }
            } label: {
                HStack {
                    Text(selection.map(displayName) ?? "Seleccionar...")
                        .foregroundColor(selection == nil ? .labelTertiary : .labelPrimary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.labelTertiary)
                }
                .padding(Spacing.md)
                .background(Color.surfaceSecondary)
                .cornerRadius(Spacing.radiusSmall)
            }
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .textStyle(.formCaption)
                    .foregroundColor(.error)
            }
        }
    }
}

// MARK: - Preview
struct FormPicker_Previews: PreviewProvider {
    @State static var selectedGender: Gender? = nil
    
    static var previews: some View {
        VStack(spacing: Spacing.lg) {
            FormPicker(
                title: "Género",
                selection: $selectedGender,
                displayName: { $0.displayName }
            )
            
            FormPicker(
                title: "Género (Requerido)",
                selection: $selectedGender,
                displayName: { $0.displayName },
                isRequired: true
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}