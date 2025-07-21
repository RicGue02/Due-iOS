//
//  StatusBadge.swift
//  Fisioflow - Design System Components
//
//  Created by Ricardo Guerrero Godínez on 15/7/25.
//

import SwiftUI

// MARK: - Generic Status Badge
struct StatusBadge<T>: View where T: RawRepresentable, T.RawValue == String {
    let status: T
    let displayName: (T) -> String
    let color: (T) -> Color
    let size: BadgeSize
    
    init(
        status: T,
        displayName: @escaping (T) -> String,
        color: @escaping (T) -> Color,
        size: BadgeSize = .medium
    ) {
        self.status = status
        self.displayName = displayName
        self.color = color
        self.size = size
    }
    
    var body: some View {
        Text(displayName(status))
            .font(size.font)
            .fontWeight(.medium)
            .foregroundColor(color(status))
            .padding(.horizontal, size.horizontalPadding)
            .padding(.vertical, size.verticalPadding)
            .background(color(status).opacity(0.15))
            .cornerRadius(size.cornerRadius)
    }
}

// MARK: - Appointment Status Badge
extension StatusBadge where T == AppointmentStatus {
    init(status: AppointmentStatus, size: BadgeSize = .medium) {
        self.init(
            status: status,
            displayName: { $0.displayName },
            color: { $0.color },
            size: size
        )
    }
}

// MARK: - Invoice Status Badge
extension StatusBadge where T == InvoiceStatus {
    init(status: InvoiceStatus, size: BadgeSize = .medium) {
        self.init(
            status: status,
            displayName: { $0.displayName },
            color: { $0.color },
            size: size
        )
    }
}

// MARK: - Badge Size
enum BadgeSize {
    case small
    case medium
    case large
    
    var font: Font {
        switch self {
        case .small: return .caption2
        case .medium: return .caption
        case .large: return .footnote
        }
    }
    
    var horizontalPadding: CGFloat {
        switch self {
        case .small: return 6
        case .medium: return 8
        case .large: return 12
        }
    }
    
    var verticalPadding: CGFloat {
        switch self {
        case .small: return 2
        case .medium: return 4
        case .large: return 6
        }
    }
    
    var cornerRadius: CGFloat {
        switch self {
        case .small: return 4
        case .medium: return 6
        case .large: return 8
        }
    }
}

// MARK: - Preview
struct StatusBadge_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: Spacing.md) {
            // Appointment Status Badges
            HStack(spacing: Spacing.sm) {
                StatusBadge(status: .scheduled, size: .small)
                StatusBadge(status: .confirmed, size: .medium)
                StatusBadge(status: .completed, size: .large)
            }
            
            // Invoice Status Badges
            HStack(spacing: Spacing.sm) {
                StatusBadge(status: InvoiceStatus.pending, size: .small)
                StatusBadge(status: InvoiceStatus.paid, size: .medium)
                StatusBadge(status: InvoiceStatus.overdue, size: .large)
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}