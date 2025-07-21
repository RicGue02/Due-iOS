//
//  UniversalEmptyState.swift
//  Fisioflow - Design System Components
//  Universal Empty State Component for consistent empty states across all screens
//
//  Created by Ricardo Guerrero Godínez on 16/7/25.
//

import SwiftUI

// MARK: - Empty State Variant
enum EmptyStateVariant {
    case noContent    // No data at all (default)
    case noResults    // Filtered/search results
    case error        // Error state
    
    var iconBackgroundStyle: IconBackgroundStyle {
        switch self {
        case .noContent: return .circle
        case .noResults: return .circle
        case .error: return .none
        }
    }
    
    var defaultActionStyle: EmptyStateActionStyle {
        switch self {
        case .noContent: return .primary
        case .noResults: return .secondary
        case .error: return .primary
        }
    }
}

// MARK: - Icon Background Style
enum IconBackgroundStyle {
    case none       // Plain icon
    case circle     // Icon with circle background
    case colored    // Icon with colored circle background
}

// MARK: - Action Style
enum EmptyStateActionStyle {
    case primary    // PrimaryButton
    case secondary  // SecondaryButton
    case text       // TextButton
}

// MARK: - Universal Empty State Component
struct UniversalEmptyState: View {
    let icon: String
    let title: String
    let description: String
    let actionTitle: String?
    let actionIcon: String?
    let onAction: (() -> Void)?
    let variant: EmptyStateVariant
    let iconBackgroundStyle: IconBackgroundStyle
    let actionStyle: EmptyStateActionStyle
    
    init(
        icon: String,
        title: String,
        description: String,
        actionTitle: String? = nil,
        actionIcon: String? = nil,
        onAction: (() -> Void)? = nil,
        variant: EmptyStateVariant = .noContent,
        iconBackgroundStyle: IconBackgroundStyle? = nil,
        actionStyle: EmptyStateActionStyle? = nil
    ) {
        self.icon = icon
        self.title = title
        self.description = description
        self.actionTitle = actionTitle
        self.actionIcon = actionIcon
        self.onAction = onAction
        self.variant = variant
        self.iconBackgroundStyle = iconBackgroundStyle ?? variant.iconBackgroundStyle
        self.actionStyle = actionStyle ?? variant.defaultActionStyle
    }
    
    var body: some View {
        VStack(spacing: Spacing.lg) {
            
            VStack(spacing: Spacing.lg) {
                // Icon with standardized styling
                iconView
                
                // Text content
                VStack(spacing: Spacing.sm) {
                    Text(title)
                        .textStyle(.sectionTitle)
                        .foregroundColor(.labelPrimary)
                    
                    Text(description)
                        .textStyle(.listSubtitle)
                        .foregroundColor(.labelSecondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            // Action button (if provided)
            if let actionTitle = actionTitle, let onAction = onAction {
                actionButton(title: actionTitle, onAction: onAction)
            }
        }
        .padding(.horizontal, Spacing.screenPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.surfaceGrouped)
    }
    
    // MARK: - Icon View
    @ViewBuilder
    private var iconView: some View {
        switch iconBackgroundStyle {
        case .none:
            Image(systemName: icon)
                .font(.system(size: 48, weight: .light))
                .foregroundColor(.labelTertiary)
                
        case .circle:
            Image(systemName: icon)
                .font(.system(size: 32, weight: .light))
                .foregroundColor(.labelTertiary)
                .frame(width: 64, height: 64)
                .background(Color.fillSecondary)
                .clipShape(Circle())
                
        case .colored:
            Image(systemName: icon)
                .font(.system(size: 32, weight: .light))
                .foregroundColor(.brandBlue)
                .frame(width: 64, height: 64)
                .background(Color.brandBlue.opacity(0.1))
                .clipShape(Circle())
        }
    }
    
    // MARK: - Action Button
    @ViewBuilder
    private func actionButton(title: String, onAction: @escaping () -> Void) -> some View {
        switch actionStyle {
        case .primary:
            PrimaryButton(
                title: title,
                icon: actionIcon
            ) {
                onAction()
                HapticFeedback.light()
            }
            
        case .secondary:
            SecondaryButton(
                title: title,
                icon: actionIcon
            ) {
                onAction()
                HapticFeedback.light()
            }
            
        case .text:
            Button(action: {
                onAction()
                HapticFeedback.light()
            }) {
                HStack(spacing: Spacing.xs) {
                    if let actionIcon = actionIcon {
                        Image(systemName: actionIcon)
                            .font(.system(size: Spacing.iconSmall, weight: .medium))
                    }
                    Text(title)
                        .font(.body.weight(.medium))
                }
                .foregroundColor(.brandBlue)
            }
        }
    }
}

// MARK: - Convenience Initializers
extension UniversalEmptyState {
    // No content state (create new item)
    static func noContent(
        icon: String,
        title: String,
        description: String,
        createActionTitle: String,
        createActionIcon: String = "plus",
        onCreateAction: @escaping () -> Void
    ) -> UniversalEmptyState {
        UniversalEmptyState(
            icon: icon,
            title: title,
            description: description,
            actionTitle: createActionTitle,
            actionIcon: createActionIcon,
            onAction: onCreateAction,
            variant: .noContent,
            iconBackgroundStyle: .circle,
            actionStyle: .primary
        )
    }
    
    // No results state (clear filters/search)
    static func noResults(
        title: String = "No se encontraron resultados",
        description: String,
        clearActionTitle: String,
        clearActionIcon: String = "arrow.counterclockwise",
        onClearAction: @escaping () -> Void
    ) -> UniversalEmptyState {
        UniversalEmptyState(
            icon: "magnifyingglass",
            title: title,
            description: description,
            actionTitle: clearActionTitle,
            actionIcon: clearActionIcon,
            onAction: onClearAction,
            variant: .noResults,
            iconBackgroundStyle: .circle,
            actionStyle: .secondary
        )
    }
    
    // Error state
    static func error(
        title: String = "Algo salió mal",
        description: String,
        retryActionTitle: String = "Intentar de nuevo",
        retryActionIcon: String = "arrow.clockwise",
        onRetryAction: @escaping () -> Void
    ) -> UniversalEmptyState {
        UniversalEmptyState(
            icon: "exclamationmark.triangle",
            title: title,
            description: description,
            actionTitle: retryActionTitle,
            actionIcon: retryActionIcon,
            onAction: onRetryAction,
            variant: .error,
            iconBackgroundStyle: .none,
            actionStyle: .primary
        )
    }
    
    // Info only state (no action)
    static func info(
        icon: String,
        title: String,
        description: String,
        variant: EmptyStateVariant = .noContent
    ) -> UniversalEmptyState {
        UniversalEmptyState(
            icon: icon,
            title: title,
            description: description,
            variant: variant,
            iconBackgroundStyle: variant.iconBackgroundStyle
        )
    }
}

// MARK: - Preview
#if DEBUG
struct UniversalEmptyState_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: Spacing.xxl) {
            
            // No Content Example
            UniversalEmptyState.noContent(
                icon: "person.3",
                title: "No hay pacientes",
                description: "Los pacientes aparecerán aquí cuando los agregues al sistema",
                createActionTitle: "Agregar Paciente"
            ) {
                print("Create patient")
            }
            .frame(height: 200)
            
            Divider()
            
            // No Results Example
            UniversalEmptyState.noResults(
                description: "No hay resultados para el filtro seleccionado",
                clearActionTitle: "Limpiar filtros"
            ) {
                print("Clear filters")
            }
            .frame(height: 200)
            
            Divider()
            
            // Error Example
            UniversalEmptyState.error(
                description: "No se pudieron cargar los datos. Verifica tu conexión a internet."
            ) {
                print("Retry")
            }
            .frame(height: 200)
        }
        .padding()
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Universal Empty States")
    }
}
#endif