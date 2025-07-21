//
//  PatientRow.swift
//  Fisioflow - Design System Components
//
//  Created by Ricardo Guerrero Godínez on 14/7/25.
//

import SwiftUI

// MARK: - Patient Row
struct PatientRow: View {
    let patient: Patient
    let showStatus: Bool
    let showChevron: Bool
    let onTap: () -> Void
    
    init(
        patient: Patient,
        showStatus: Bool = true,
        showChevron: Bool = true,
        onTap: @escaping () -> Void
    ) {
        self.patient = patient
        self.showStatus = showStatus
        self.showChevron = showChevron
        self.onTap = onTap
    }
    
    var body: some View {
        HStack(spacing: Spacing.md) {
            // Avatar
            PatientAvatar(patient: patient, size: .medium)
            
            // Content
            VStack(alignment: .leading, spacing: Spacing.xs) {
                // Name
                Text(patient.fullName)
                    .textStyle(.listTitle)
                    .foregroundColor(.primaryText)
                
                // Info Row
                HStack(spacing: Spacing.md) {
                    // Age
                    Text(patient.displayAge)
                        .textStyle(.listSubtitle)
                        .foregroundColor(.labelSecondary)
                    
                    if let phone = patient.phone {
                        Text("•")
                            .textStyle(.listSubtitle)
                            .foregroundColor(.tertiaryText)
                        
                        Text(ValidationHelper.formatCostaRicanPhone(phone))
                            .textStyle(.listSubtitle)
                            .foregroundColor(.labelSecondary)
                    }
                    
                    if patient.isMinor {
                        Text("•")
                            .textStyle(.listSubtitle)
                            .foregroundColor(.tertiaryText)
                        
                        Text("Menor")
                            .font(.labelSmall)
                            .foregroundColor(.warning)
                            .padding(.horizontal, Spacing.sm)
                            .padding(.vertical, Spacing.xs)
                            .background(Color.warning.opacity(0.15))
                            .cornerRadius(Spacing.radiusSmall)
                    }
                }
            }
            
            Spacer()
            
            // Status Indicators and Chevron
            VStack(alignment: .trailing, spacing: Spacing.xs) {
                if showStatus {
                    if patient.isArchived {
                        StatusPill(text: "Archivado", color: .labelSecondary)
                    } else if !patient.hasContactInfo {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: Spacing.iconSmall, weight: .medium))
                            .foregroundColor(.warning)
                    }
                }
                
                // Chevron (only show if not inside NavigationLink)
                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: Spacing.iconSmall, weight: .medium))
                        .foregroundColor(.tertiaryText)
                }
            }
        }
        .padding(Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: Spacing.radiusLarge)
                .fill(Color.surfacePrimary)
                .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Spacing.radiusLarge)
                .stroke(Color.border.opacity(0.1), lineWidth: 0.5)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}

// MARK: - Patient Avatar
struct PatientAvatar: View {
    let patient: Patient
    let size: AvatarSize
    
    enum AvatarSize {
        case small, medium, large, extraLarge
        
        var dimension: CGFloat {
            switch self {
            case .small: return Spacing.avatarSmall
            case .medium: return Spacing.avatarMedium
            case .large: return Spacing.avatarLarge
            case .extraLarge: return Spacing.avatarXL
            }
        }
        
        var fontSize: CGFloat {
            return dimension * 0.4
        }
    }
    
    init(patient: Patient, size: AvatarSize = .medium) {
        self.patient = patient
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(avatarBackgroundColor)
                .frame(width: size.dimension, height: size.dimension)
            
            Text(patient.initials)
                .font(.system(size: size.fontSize, weight: .semibold))
                .foregroundColor(.white)
        }
    }
    
    private var avatarBackgroundColor: Color {
        // Generate consistent color based on patient name
        let hash = patient.fullName.hash
        let colors: [Color] = [
            .brandBlue, .success, .warning, .purple, .pink, .teal, .indigo
        ]
        return colors[abs(hash) % colors.count]
    }
}

// MARK: - Status Pill
struct StatusPill: View {
    let text: String
    let color: Color
    
    init(text: String, color: Color) {
        self.text = text
        self.color = color
    }
    
    var body: some View {
        Text(text)
            .font(.labelSmall)
            .foregroundColor(color)
            .padding(.horizontal, Spacing.sm)
            .padding(.vertical, Spacing.xs)
            .background(color.opacity(0.15))
            .cornerRadius(Spacing.radiusSmall)
    }
}


// MARK: - Search Empty State
struct SearchEmptyState: View {
    let query: String
    
    init(query: String) {
        self.query = query
    }
    
    var body: some View {
        VStack(spacing: Spacing.lg) {
            // Icon
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40, weight: .light))
                .foregroundColor(.tertiaryText)
            
            // Text
            VStack(spacing: Spacing.sm) {
                Text("Sin resultados")
                    .textStyle(.sectionTitle)
                    .foregroundColor(.primaryText)
                
                Text("No se encontraron pacientes para \"\(query)\"")
                    .textStyle(.listSubtitle)
                    .foregroundColor(.labelSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, Spacing.xxl)
    }
}

// MARK: - Preview
struct PatientRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            ForEach(Patient.samplePatients.prefix(3), id: \.id) { patient in
                PatientRow(patient: patient) {
                    print("Patient tapped: \(patient.fullName)")
                }
                
                Divider()
                    .padding(.leading, Spacing.avatarMedium + Spacing.md + Spacing.lg)
            }
            
            UniversalEmptyState.noContent(
                icon: "person.2",
                title: "No hay pacientes",
                description: "Agrega tu primer paciente para comenzar",
                createActionTitle: "Agregar Paciente"
            ) {
                print("Add patient tapped")
            }
            .padding(.top, Spacing.xxxl)
            
            SearchEmptyState(query: "Roberto")
                .padding(.top, Spacing.xxxl)
        }
        .screenPadding()
        .background(Color.surfacePrimary)
        .previewLayout(.sizeThatFits)
    }
}