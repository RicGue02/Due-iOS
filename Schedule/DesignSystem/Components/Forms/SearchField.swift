//
//  SearchField.swift
//  Fisioflow - Design System Components
//
//  Created by Ricardo Guerrero Godínez on 14/7/25.
//

import SwiftUI

// MARK: - Search Field Component
struct SearchField: View {
    let placeholder: String
    @Binding var text: String
    let onSearchTapped: (() -> Void)?
    let showsCancelButton: Bool
    
    @FocusState private var isFocused: Bool
    
    init(
        placeholder: String = "Buscar...",
        text: Binding<String>,
        onSearchTapped: (() -> Void)? = nil,
        showsCancelButton: Bool = false
    ) {
        self.placeholder = placeholder
        self._text = text
        self.onSearchTapped = onSearchTapped
        self.showsCancelButton = showsCancelButton
    }
    
    var body: some View {
        HStack(spacing: Spacing.sm) {
            // Search Field
            HStack(spacing: Spacing.sm) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.labelSecondary)
                    .font(.system(size: 16, weight: .medium))
                
                TextField(placeholder, text: $text)
                    .textStyle(.listTitle)
                    .focused($isFocused)
                    .submitLabel(.search)
                    .onSubmit {
                        onSearchTapped?()
                    }
                
                if !text.isEmpty {
                    Button(action: { text = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.labelSecondary)
                            .font(.system(size: 16, weight: .medium))
                    }
                }
            }
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.sm)
            .background(Color.surfaceSecondary)
            .cornerRadius(Spacing.radiusSmall)
            
            // Cancel Button
            if showsCancelButton && isFocused {
                Button("Cancelar") {
                    text = ""
                    isFocused = false
                }
                .textStyle(.listTitle)
                .foregroundColor(.brandBlue)
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

// MARK: - Preview
#if DEBUG
struct SearchField_Previews: PreviewProvider {
    @State static var searchText = ""
    @State static var searchTextWithContent = "Elena Pérez"
    
    static var previews: some View {
        VStack(spacing: Spacing.lg) {
            SearchField(
                placeholder: "Buscar pacientes...",
                text: $searchText
            )
            
            SearchField(
                placeholder: "Buscar citas...",
                text: $searchTextWithContent,
                showsCancelButton: true
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Search Field")
    }
}
#endif