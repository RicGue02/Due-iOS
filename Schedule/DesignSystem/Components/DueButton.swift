import SwiftUI

// MARK: - Primary Button
public struct DuePrimaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    let isLoading: Bool
    let isEnabled: Bool
    
    public init(
        _ title: String,
        icon: String? = nil,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            if isEnabled && !isLoading {
                HapticManager.impact(.light)
                action()
            }
        }) {
            HStack(spacing: DueSpacing.Gap.inline) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                }
                
                Text(title)
                    .dueButton()
            }
            .frame(maxWidth: .infinity)
            .frame(height: DueSpacing.Component.buttonHeight)
            .background(
                Group {
                    if isEnabled && !isLoading {
                        DueColors.Effects.primaryGradient
                    } else {
                        Color(DueColors.UI.disabled)
                    }
                }
            )
            .cornerRadius(DueSpacing.Component.buttonCornerRadius)
            .shadow(
                color: isEnabled ? DueColors.Effects.shadow : .clear,
                radius: 8,
                x: 0,
                y: 4
            )
            .scaleEffect(isEnabled && !isLoading ? 1 : 0.98)
            .animation(.spring(response: 0.3), value: isEnabled)
        }
        .disabled(!isEnabled || isLoading)
    }
}

// MARK: - Secondary Button
public struct DueSecondaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    
    public init(
        _ title: String,
        icon: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            HapticManager.impact(.light)
            action()
        }) {
            HStack(spacing: DueSpacing.Gap.inline) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                }
                
                Text(title)
                    .font(DueTypography.Special.button)
            }
            .foregroundColor(DueColors.primaryBlue)
            .frame(maxWidth: .infinity)
            .frame(height: DueSpacing.Component.buttonHeight)
            .background(
                RoundedRectangle(cornerRadius: DueSpacing.Component.buttonCornerRadius)
                    .stroke(DueColors.primaryBlue, lineWidth: 2)
            )
            .background(
                DueColors.primaryBlue.opacity(0.05)
                    .cornerRadius(DueSpacing.Component.buttonCornerRadius)
            )
        }
    }
}

// MARK: - Ghost Button
public struct DueGhostButton: View {
    let title: String
    let icon: String?
    let action: () -> Void
    
    public init(
        _ title: String,
        icon: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            HapticManager.impact(.light)
            action()
        }) {
            HStack(spacing: DueSpacing.Gap.inline) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                }
                
                Text(title)
                    .font(DueTypography.Special.button)
            }
            .foregroundColor(DueColors.primaryBlue)
            .padding(.horizontal, DueSpacing.Padding.standard)
            .padding(.vertical, DueSpacing.Padding.compact)
        }
    }
}

// MARK: - Floating Action Button
public struct DueFloatingActionButton: View {
    let icon: String
    let action: () -> Void
    let size: CGFloat
    
    public init(
        icon: String,
        size: CGFloat = 56,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.size = size
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            HapticManager.impact(.medium)
            action()
        }) {
            ZStack {
                Circle()
                    .fill(DueColors.Effects.primaryGradient)
                
                Image(systemName: icon)
                    .font(.system(size: size * 0.4, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(width: size, height: size)
            .shadow(
                color: DueColors.Effects.shadow,
                radius: 12,
                x: 0,
                y: 6
            )
        }
        .buttonStyle(FloatingButtonStyle())
    }
}

// MARK: - Icon Button
public struct DueIconButton: View {
    let icon: String
    let action: () -> Void
    let size: CGFloat
    let color: Color
    
    public init(
        icon: String,
        size: CGFloat = 44,
        color: Color = DueColors.UI.primaryText,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.size = size
        self.color = color
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            HapticManager.impact(.light)
            action()
        }) {
            Image(systemName: icon)
                .font(.system(size: size * 0.5, weight: .medium))
                .foregroundColor(color)
                .frame(width: size, height: size)
                .background(
                    Circle()
                        .fill(color.opacity(0.1))
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Quick Action Button
public struct DueQuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    public init(
        title: String,
        icon: String,
        color: Color,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.color = color
        self.action = action
    }
    
    public var body: some View {
        Button(action: {
            HapticManager.impact(.light)
            action()
        }) {
            VStack(spacing: DueSpacing.Gap.tight) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(color.opacity(0.15))
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: icon)
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(color)
                }
                
                Text(title)
                    .font(DueTypography.Text.caption)
                    .foregroundColor(DueColors.UI.primaryText)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 80)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Button Styles
struct FloatingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.3), value: configuration.isPressed)
    }
}

// MARK: - Haptic Manager
struct HapticManager {
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}