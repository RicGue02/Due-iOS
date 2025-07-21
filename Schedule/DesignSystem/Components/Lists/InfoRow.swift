//
//  InfoRow.swift
//  Fisioflow - Design System Components
//
//  Created by Ricardo Guerrero Godínez on 14/7/25.
//

import SwiftUI

// MARK: - Info Row Component
struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    let iconColor: Color
    
    init(
        icon: String,
        title: String,
        value: String,
        iconColor: Color = .brandBlue
    ) {
        self.icon = icon
        self.title = title
        self.value = value
        self.iconColor = iconColor
    }
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: Spacing.iconMedium, weight: .semibold))
                .foregroundColor(iconColor)
                .frame(width: Spacing.iconLarge, height: Spacing.iconLarge)
            
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(title)
                    .textStyle(.formLabel)
                    .foregroundColor(.primaryText)
                
                Text(value)
                    .textStyle(.listTitle)
                    .foregroundColor(.labelSecondary)
            }
            
            Spacer()
        }
        .padding(.vertical, Spacing.xs)
    }
}

// MARK: - Preview
#if DEBUG
struct InfoRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: Spacing.sm) {
            InfoRow(
                icon: "person.fill",
                title: "Paciente",
                value: "Elena Pérez"
            )
            
            InfoRow(
                icon: "calendar",
                title: "Fecha",
                value: "15 Jul 2025, 10:00 AM",
                iconColor: .success
            )
            
            InfoRow(
                icon: "clock",
                title: "Duración",
                value: "45 minutos",
                iconColor: .warning
            )
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Info Row")
    }
}
#endif