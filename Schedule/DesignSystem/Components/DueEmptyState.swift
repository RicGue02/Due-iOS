import SwiftUI

// MARK: - Empty State View
public struct DueEmptyState: View {
    let icon: String
    let title: String
    let description: String
    let actionTitle: String?
    let action: (() -> Void)?
    let illustration: EmptyStateIllustration
    
    public enum EmptyStateIllustration {
        case noTasks
        case noSubjects
        case noNotifications
        case noSchedule
        case noResults
        case error
        case success
        case custom(String)
        
        var systemIcon: String {
            switch self {
            case .noTasks:
                return "checklist"
            case .noSubjects:
                return "books.vertical"
            case .noNotifications:
                return "bell.slash"
            case .noSchedule:
                return "calendar.badge.exclamationmark"
            case .noResults:
                return "magnifyingglass"
            case .error:
                return "exclamationmark.triangle"
            case .success:
                return "checkmark.circle"
            case .custom(let icon):
                return icon
            }
        }
        
        var color: Color {
            switch self {
            case .error:
                return DueColors.Semantic.error
            case .success:
                return DueColors.Semantic.success
            default:
                return DueColors.UI.tertiaryText
            }
        }
    }
    
    public init(
        icon: String? = nil,
        title: String,
        description: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil,
        illustration: EmptyStateIllustration = .noResults
    ) {
        self.icon = icon ?? illustration.systemIcon
        self.title = title
        self.description = description
        self.actionTitle = actionTitle
        self.action = action
        self.illustration = illustration
    }
    
    public var body: some View {
        VStack(spacing: DueSpacing.Gap.comfortable) {
            // Illustration
            ZStack {
                Circle()
                    .fill(illustration.color.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: icon)
                    .font(.system(size: 48, weight: .medium))
                    .foregroundColor(illustration.color.opacity(0.8))
            }
            .padding(.bottom, DueSpacing.Gap.standard)
            
            // Text content
            VStack(spacing: DueSpacing.Gap.standard) {
                Text(title)
                    .dueTitle3()
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .dueBody(color: DueColors.UI.secondaryText)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            // Action button
            if let actionTitle = actionTitle, let action = action {
                DuePrimaryButton(actionTitle, action: action)
                    .padding(.top, DueSpacing.Gap.standard)
            }
        }
        .padding(.horizontal, DueSpacing.Padding.comfortable)
        .frame(maxWidth: DueSpacing.Layout.compactContentWidth)
    }
}

// MARK: - Loading State View
public struct DueLoadingState: View {
    let message: String
    let showProgress: Bool
    
    public init(
        message: String = "Loading...",
        showProgress: Bool = true
    ) {
        self.message = message
        self.showProgress = showProgress
    }
    
    public var body: some View {
        VStack(spacing: DueSpacing.Gap.comfortable) {
            if showProgress {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: DueColors.primaryBlue))
                    .scaleEffect(1.5)
            }
            
            Text(message)
                .dueBody(color: DueColors.UI.secondaryText)
        }
        .padding(DueSpacing.Padding.comfortable)
    }
}

// MARK: - Error State View
public struct DueErrorState: View {
    let title: String
    let description: String
    let retryAction: (() -> Void)?
    
    public init(
        title: String = "Something went wrong",
        description: String,
        retryAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.description = description
        self.retryAction = retryAction
    }
    
    public var body: some View {
        DueEmptyState(
            title: title,
            description: description,
            actionTitle: retryAction != nil ? "Try Again" : nil,
            action: retryAction,
            illustration: .error
        )
    }
}

// MARK: - Success State View
public struct DueSuccessState: View {
    let title: String
    let description: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    public init(
        title: String,
        description: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.description = description
        self.actionTitle = actionTitle
        self.action = action
    }
    
    public var body: some View {
        VStack(spacing: DueSpacing.Gap.comfortable) {
            // Success animation
            ZStack {
                Circle()
                    .fill(DueColors.Semantic.success.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(DueColors.Semantic.success)
            }
            .transition(.scale.combined(with: .opacity))
            
            // Text content
            VStack(spacing: DueSpacing.Gap.standard) {
                Text(title)
                    .dueTitle2()
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .dueBody(color: DueColors.UI.secondaryText)
                    .multilineTextAlignment(.center)
            }
            
            // Action button
            if let actionTitle = actionTitle, let action = action {
                DuePrimaryButton(actionTitle, action: action)
                    .padding(.top, DueSpacing.Gap.standard)
            }
        }
        .padding(.horizontal, DueSpacing.Padding.comfortable)
        .frame(maxWidth: DueSpacing.Layout.compactContentWidth)
    }
}

// MARK: - Study Tip View
public struct DueStudyTip: View {
    let tip: String
    let icon: String
    let color: Color
    
    public init(
        tip: String,
        icon: String = "lightbulb.fill",
        color: Color = DueColors.Semantic.info
    ) {
        self.tip = tip
        self.icon = icon
        self.color = color
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: DueSpacing.Gap.standard) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            
            Text(tip)
                .dueBody()
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer(minLength: 0)
        }
        .padding(DueSpacing.Padding.standard)
        .background(
            RoundedRectangle(cornerRadius: DueSpacing.Component.cardCornerRadius)
                .fill(color.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: DueSpacing.Component.cardCornerRadius)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}