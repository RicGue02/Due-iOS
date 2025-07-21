//
//  InfoCard.swift
//  Fisioflow - Design System Components
//
//  Created by Ricardo Guerrero Godínez on 14/7/25.
//

import SwiftUI

// MARK: - Info Card
struct InfoCard: View {
    let title: String
    let value: String
    let icon: String?
    let color: Color
    
    init(
        title: String,
        value: String,
        icon: String? = nil,
        color: Color = .brandBlue
    ) {
        self.title = title
        self.value = value
        self.icon = icon
        self.color = color
    }
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            // Icon
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: Spacing.iconMedium, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: Spacing.iconLarge, height: Spacing.iconLarge)
            }
            
            // Content
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text(title)
                    .textStyle(.formLabel)
                    .foregroundColor(.labelSecondary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(value)
                    .textStyle(.listTitle)
                    .foregroundColor(.primaryText)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            
            Spacer()
        }
        .cardPadding()
        .background(Color.surfaceSecondary)
        .cornerRadius(Spacing.radiusMedium)
    }
}

// MARK: - Action Card
struct ActionCard: View {
    let title: String
    let subtitle: String?
    let icon: String
    let color: Color
    let action: () -> Void
    
    init(
        title: String,
        subtitle: String? = nil,
        icon: String,
        color: Color = .brandBlue,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.md) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: Spacing.iconLarge, weight: .medium))
                    .foregroundColor(color)
                    .frame(width: Spacing.iconXL, height: Spacing.iconXL)
                
                // Content
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(title)
                        .textStyle(.listTitle)
                        .foregroundColor(.primaryText)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .textStyle(.listSubtitle)
                            .foregroundColor(.labelSecondary)
                    }
                }
                
                Spacer()
                
                // Chevron
                Image(systemName: "chevron.right")
                    .font(.system(size: Spacing.iconSmall, weight: .medium))
                    .foregroundColor(.tertiaryText)
            }
            .cardPadding()
            .background(Color.surfaceSecondary)
            .cornerRadius(Spacing.radiusMedium)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Status Card
struct StatusCard: View {
    let status: AppointmentStatus
    let count: Int
    let action: (() -> Void)?
    
    init(status: AppointmentStatus, count: Int, action: (() -> Void)? = nil) {
        self.status = status
        self.count = count
        self.action = action
    }
    
    var body: some View {
        let card = VStack(alignment: .leading, spacing: Spacing.md) {
            // Header
            HStack {
                Image(systemName: status.icon)
                    .font(.system(size: Spacing.iconMedium, weight: .medium))
                    .foregroundColor(status.color)
                
                Spacer()
                
                if action != nil {
                    Image(systemName: "chevron.right")
                        .font(.system(size: Spacing.iconSmall, weight: .medium))
                        .foregroundColor(.tertiaryText)
                }
            }
            
            // Content
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Text("\(count)")
                    .textStyle(.screenTitle)
                    .foregroundColor(.primaryText)
                
                Text(status.displayName)
                    .textStyle(.formLabel)
                    .foregroundColor(.labelSecondary)
            }
        }
        .cardPadding()
        .background(status.backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: Spacing.radiusMedium)
                .stroke(status.color.opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(Spacing.radiusMedium)
        
        if let action = action {
            Button(action: action) {
                card
            }
            .buttonStyle(PlainButtonStyle())
        } else {
            card
        }
    }
}

// MARK: - Preview
struct InfoCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: Spacing.lg) {
            InfoCard(
                title: "Edad",
                value: "35 años",
                icon: "person.circle",
                color: .brandBlue
            )
            
            ActionCard(
                title: "Nuevo Paciente",
                subtitle: "Agregar paciente al sistema",
                icon: "person.badge.plus",
                color: .brandBlue
            ) {
                print("Add patient tapped")
            }
            
            StatusCard(
                status: .confirmed,
                count: 5
            ) {
                print("Status card tapped")
            }
        }
        .screenPadding()
        .background(Color.surfacePrimary)
        .previewLayout(.sizeThatFits)
    }
}