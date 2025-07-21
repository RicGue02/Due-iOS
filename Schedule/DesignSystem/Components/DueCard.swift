import SwiftUI

// MARK: - Base Card
public struct DueCard<Content: View>: View {
    let content: Content
    let padding: CGFloat
    let backgroundColor: Color
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    
    public init(
        padding: CGFloat = DueSpacing.Padding.card,
        backgroundColor: Color = DueColors.UI.secondaryBackground,
        cornerRadius: CGFloat = DueSpacing.Component.cardCornerRadius,
        shadowRadius: CGFloat = 8,
        @ViewBuilder content: () -> Content
    ) {
        self.padding = padding
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.content = content()
    }
    
    public var body: some View {
        content
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .shadow(
                color: DueColors.Effects.shadow,
                radius: shadowRadius,
                x: 0,
                y: 2
            )
    }
}

// MARK: - Subject Card
public struct DueSubjectCard: View {
    let subject: String
    let teacher: String
    let icon: String
    let color: Color
    let tasksCount: Int
    let nextClass: String?
    let action: () -> Void
    
    public init(
        subject: String,
        teacher: String,
        icon: String,
        color: Color,
        tasksCount: Int = 0,
        nextClass: String? = nil,
        action: @escaping () -> Void
    ) {
        self.subject = subject
        self.teacher = teacher
        self.icon = icon
        self.color = color
        self.tasksCount = tasksCount
        self.nextClass = nextClass
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            DueCard {
                VStack(alignment: .leading, spacing: DueSpacing.Gap.standard) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(color.opacity(0.2))
                                .frame(width: 48, height: 48)
                            
                            Image(systemName: icon)
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(color)
                        }
                        
                        Spacer()
                        
                        if tasksCount > 0 {
                            Text("\(tasksCount)")
                                .dueBadge(color: .white)
                                .padding(.horizontal, DueSpacing.Gap.inline)
                                .padding(.vertical, DueSpacing.Gap.minimal)
                                .background(
                                    Capsule()
                                        .fill(color)
                                )
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: DueSpacing.Gap.minimal) {
                        Text(subject)
                            .dueHeadline()
                            .lineLimit(1)
                        
                        Text(teacher)
                            .dueCaption()
                            .lineLimit(1)
                    }
                    
                    if let nextClass = nextClass {
                        HStack(spacing: DueSpacing.Gap.minimal) {
                            Image(systemName: "clock")
                                .font(.system(size: 12))
                            Text(nextClass)
                                .dueCaption()
                        }
                        .foregroundColor(DueColors.UI.secondaryText)
                    }
                }
            }
        }
        .buttonStyle(CardButtonStyle())
    }
}

// MARK: - Task Card
public struct DueTaskCard: View {
    let title: String
    let subject: String
    let dueDate: Date
    let priority: TaskPriority
    let isCompleted: Bool
    let onToggle: () -> Void
    let onTap: () -> Void
    
    public var body: some View {
        Button(action: onTap) {
            DueCard(padding: DueSpacing.Padding.cardCompact) {
                HStack(spacing: DueSpacing.Gap.standard) {
                    // Completion Toggle
                    Button(action: onToggle) {
                        ZStack {
                            Circle()
                                .stroke(priorityColor, lineWidth: 2)
                                .frame(width: 24, height: 24)
                            
                            if isCompleted {
                                Circle()
                                    .fill(priorityColor)
                                    .frame(width: 16, height: 16)
                            }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Content
                    VStack(alignment: .leading, spacing: DueSpacing.Gap.minimal) {
                        Text(title)
                            .dueBody()
                            .lineLimit(2)
                            .strikethrough(isCompleted)
                            .opacity(isCompleted ? 0.6 : 1)
                        
                        HStack(spacing: DueSpacing.Gap.inline) {
                            Text(subject)
                                .dueCaption()
                            
                            Text("•")
                                .dueCaption()
                            
                            Text(dueDateText)
                                .dueCaption(color: dueDateColor)
                        }
                    }
                    
                    Spacer()
                    
                    // Priority Indicator
                    if !isCompleted {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(priorityColor)
                            .frame(width: 4, height: 40)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var priorityColor: Color {
        switch priority {
        case .high:
            return DueColors.Semantic.error
        case .medium:
            return DueColors.Semantic.warning
        case .low:
            return DueColors.Semantic.info
        }
    }
    
    private var dueDateText: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: dueDate, relativeTo: Date())
    }
    
    private var dueDateColor: Color {
        let now = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now)!
        
        if dueDate < now {
            return DueColors.Semantic.error
        } else if dueDate < tomorrow {
            return DueColors.Semantic.warning
        } else {
            return DueColors.UI.secondaryText
        }
    }
}

// MARK: - Stats Card
public struct DueStatsCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    let trend: Trend?
    
    public enum Trend {
        case up(Double)
        case down(Double)
        case neutral
    }
    
    public init(
        title: String,
        value: String,
        subtitle: String,
        icon: String,
        color: Color,
        trend: Trend? = nil
    ) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.icon = icon
        self.color = color
        self.trend = trend
    }
    
    public var body: some View {
        DueCard {
            VStack(alignment: .leading, spacing: DueSpacing.Gap.standard) {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(color)
                    
                    Spacer()
                    
                    if let trend = trend {
                        trendView(trend)
                    }
                }
                
                VStack(alignment: .leading, spacing: DueSpacing.Gap.minimal) {
                    Text(value)
                        .font(DueTypography.Display.title2)
                        .foregroundColor(DueColors.UI.primaryText)
                    
                    Text(title)
                        .dueCaption()
                }
                
                Text(subtitle)
                    .dueFootnote()
            }
        }
    }
    
    @ViewBuilder
    private func trendView(_ trend: Trend) -> some View {
        HStack(spacing: 2) {
            switch trend {
            case .up(let value):
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 12, weight: .medium))
                Text("+\(Int(value))%")
                    .dueCaption(color: DueColors.Semantic.success)
            case .down(let value):
                Image(systemName: "arrow.down.right")
                    .font(.system(size: 12, weight: .medium))
                Text("-\(Int(value))%")
                    .dueCaption(color: DueColors.Semantic.error)
            case .neutral:
                Image(systemName: "minus")
                    .font(.system(size: 12, weight: .medium))
                Text("0%")
                    .dueCaption()
            }
        }
        .foregroundColor(trendColor(trend))
    }
    
    private func trendColor(_ trend: Trend) -> Color {
        switch trend {
        case .up:
            return DueColors.Semantic.success
        case .down:
            return DueColors.Semantic.error
        case .neutral:
            return DueColors.UI.secondaryText
        }
    }
}

// MARK: - Card Button Style
struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.spring(response: 0.3), value: configuration.isPressed)
    }
}