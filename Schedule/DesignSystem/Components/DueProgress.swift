import SwiftUI

// MARK: - Progress Bar
public struct DueProgressBar: View {
    let value: Double
    let total: Double
    let color: Color
    let showLabel: Bool
    let height: CGFloat
    
    public init(
        value: Double,
        total: Double = 1.0,
        color: Color = DueColors.primaryBlue,
        showLabel: Bool = false,
        height: CGFloat = DueSpacing.Component.progressHeight
    ) {
        self.value = value
        self.total = total
        self.color = color
        self.showLabel = showLabel
        self.height = height
    }
    
    private var progress: Double {
        min(max(value / total, 0), 1)
    }
    
    private var percentage: Int {
        Int(progress * 100)
    }
    
    public var body: some View {
        VStack(alignment: .trailing, spacing: DueSpacing.Gap.minimal) {
            if showLabel {
                Text("\(percentage)%")
                    .dueCaption()
                    .monospacedDigit()
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(color.opacity(0.2))
                        .frame(height: height)
                    
                    // Progress
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(color)
                        .frame(width: geometry.size.width * progress, height: height)
                        .animation(.spring(response: 0.5), value: progress)
                }
            }
            .frame(height: height)
        }
    }
}

// MARK: - Circular Progress
public struct DueCircularProgress: View {
    let value: Double
    let total: Double
    let size: CGFloat
    let lineWidth: CGFloat
    let color: Color
    let showLabel: Bool
    
    public init(
        value: Double,
        total: Double = 1.0,
        size: CGFloat = 80,
        lineWidth: CGFloat = 8,
        color: Color = DueColors.primaryBlue,
        showLabel: Bool = true
    ) {
        self.value = value
        self.total = total
        self.size = size
        self.lineWidth = lineWidth
        self.color = color
        self.showLabel = showLabel
    }
    
    private var progress: Double {
        min(max(value / total, 0), 1)
    }
    
    private var percentage: Int {
        Int(progress * 100)
    }
    
    public var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)
                .frame(width: size, height: size)
            
            // Progress circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .frame(width: size, height: size)
                .rotationEffect(Angle(degrees: -90))
                .animation(.spring(response: 0.5), value: progress)
            
            // Label
            if showLabel {
                Text("\(percentage)%")
                    .font(.system(size: size * 0.3, weight: .semibold, design: .rounded))
                    .foregroundColor(DueColors.UI.primaryText)
                    .monospacedDigit()
            }
        }
    }
}

// MARK: - Segmented Progress
public struct DueSegmentedProgress: View {
    let segments: Int
    let filledSegments: Int
    let color: Color
    let height: CGFloat
    
    public init(
        segments: Int,
        filledSegments: Int,
        color: Color = DueColors.primaryBlue,
        height: CGFloat = DueSpacing.Component.progressHeight
    ) {
        self.segments = max(segments, 1)
        self.filledSegments = min(max(filledSegments, 0), segments)
        self.color = color
        self.height = height
    }
    
    public var body: some View {
        HStack(spacing: DueSpacing.Gap.minimal) {
            ForEach(0..<segments, id: \.self) { index in
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(index < filledSegments ? color : color.opacity(0.2))
                    .frame(height: height)
                    .animation(.spring(response: 0.3).delay(Double(index) * 0.05), value: filledSegments)
            }
        }
    }
}

// MARK: - Study Streak Indicator
public struct DueStreakIndicator: View {
    let currentStreak: Int
    let bestStreak: Int
    let isActive: Bool
    
    public init(
        currentStreak: Int,
        bestStreak: Int,
        isActive: Bool = true
    ) {
        self.currentStreak = currentStreak
        self.bestStreak = bestStreak
        self.isActive = isActive
    }
    
    public var body: some View {
        HStack(spacing: DueSpacing.Gap.standard) {
            // Flame icon
            ZStack {
                Circle()
                    .fill(isActive ? DueColors.Semantic.warning.opacity(0.2) : Color.gray.opacity(0.2))
                    .frame(width: 48, height: 48)
                
                Image(systemName: "flame.fill")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isActive ? DueColors.Semantic.warning : .gray)
            }
            
            VStack(alignment: .leading, spacing: DueSpacing.Gap.minimal) {
                Text("\(currentStreak) days")
                    .dueHeadline()
                
                Text("Best: \(bestStreak) days")
                    .dueCaption()
            }
            
            Spacer()
            
            if currentStreak >= 7 {
                Image(systemName: "star.fill")
                    .font(.system(size: 20))
                    .foregroundColor(DueColors.Semantic.warning)
            }
        }
        .padding(DueSpacing.Padding.standard)
        .background(
            RoundedRectangle(cornerRadius: DueSpacing.Component.cardCornerRadius)
                .fill(DueColors.UI.secondaryBackground)
        )
    }
}

// MARK: - Grade Progress
public struct DueGradeProgress: View {
    let currentGrade: Double
    let targetGrade: Double
    let subject: String
    
    public init(
        currentGrade: Double,
        targetGrade: Double,
        subject: String
    ) {
        self.currentGrade = currentGrade
        self.targetGrade = targetGrade
        self.subject = subject
    }
    
    private var progress: Double {
        currentGrade / targetGrade
    }
    
    private var progressColor: Color {
        if currentGrade >= targetGrade {
            return DueColors.Semantic.success
        } else if currentGrade >= targetGrade * 0.8 {
            return DueColors.Semantic.warning
        } else {
            return DueColors.Semantic.error
        }
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: DueSpacing.Gap.standard) {
            HStack {
                Text(subject)
                    .dueSubheadline()
                
                Spacer()
                
                Text(String(format: "%.1f / %.1f", currentGrade, targetGrade))
                    .dueCaption()
                    .monospacedDigit()
            }
            
            DueProgressBar(
                value: currentGrade,
                total: targetGrade,
                color: progressColor
            )
            
            if currentGrade < targetGrade {
                Text("Need \(String(format: "%.1f", targetGrade - currentGrade)) more points")
                    .dueFootnote()
            } else {
                HStack(spacing: DueSpacing.Gap.minimal) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 14))
                    Text("Target achieved!")
                }
                .dueFootnote(color: DueColors.Semantic.success)
            }
        }
        .padding(DueSpacing.Padding.standard)
        .background(
            RoundedRectangle(cornerRadius: DueSpacing.Component.cardCornerRadius)
                .fill(DueColors.UI.secondaryBackground)
        )
    }
}