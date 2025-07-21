import SwiftUI

// MARK: - Due Typography System
// Modern, readable typography for academic content

public struct DueTypography {
    // MARK: - Font Configuration
    private static let systemFont = Font.system
    private static let roundedFont = Font.system(.body, design: .rounded)
    
    // MARK: - Display Styles (For headers and important UI)
    public struct Display {
        public static let largeTitle = systemFont(.largeTitle, design: .rounded)
            .weight(.bold)
        
        public static let title = systemFont(.title, design: .rounded)
            .weight(.semibold)
        
        public static let title2 = systemFont(.title2, design: .rounded)
            .weight(.semibold)
        
        public static let title3 = systemFont(.title3, design: .rounded)
            .weight(.medium)
    }
    
    // MARK: - Text Styles (For content)
    public struct Text {
        public static let headline = systemFont(.headline)
            .weight(.semibold)
        
        public static let subheadline = systemFont(.subheadline)
            .weight(.medium)
        
        public static let body = systemFont(.body)
            .weight(.regular)
        
        public static let bodyEmphasized = systemFont(.body)
            .weight(.medium)
        
        public static let callout = systemFont(.callout)
            .weight(.regular)
        
        public static let footnote = systemFont(.footnote)
            .weight(.regular)
        
        public static let caption = systemFont(.caption)
            .weight(.regular)
        
        public static let caption2 = systemFont(.caption2)
            .weight(.regular)
    }
    
    // MARK: - Special Styles
    public struct Special {
        // For grades and scores
        public static let grade = systemFont(.largeTitle, design: .rounded)
            .weight(.heavy)
            .monospacedDigit()
        
        // For time displays
        public static let time = systemFont(.title2, design: .rounded)
            .weight(.semibold)
            .monospacedDigit()
        
        // For countdown timers
        public static let countdown = systemFont(.title, design: .rounded)
            .weight(.bold)
            .monospacedDigit()
        
        // For code/formulas
        public static let code = Font.system(.body, design: .monospaced)
            .weight(.regular)
        
        // For badges and labels
        public static let badge = systemFont(.caption, design: .rounded)
            .weight(.semibold)
        
        // For buttons
        public static let button = systemFont(.body, design: .rounded)
            .weight(.semibold)
        
        public static let smallButton = systemFont(.callout, design: .rounded)
            .weight(.semibold)
    }
    
    // MARK: - Dynamic Type Support
    public struct Dynamic {
        public static func title(_ size: CGFloat) -> Font {
            .system(size: size, weight: .semibold, design: .rounded)
        }
        
        public static func body(_ size: CGFloat) -> Font {
            .system(size: size, weight: .regular, design: .default)
        }
        
        public static func custom(_ size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> Font {
            .system(size: size, weight: weight, design: design)
        }
    }
}

// MARK: - Text Style ViewModifier
public struct DueTextStyle: ViewModifier {
    let font: Font
    let color: Color
    let lineSpacing: CGFloat
    
    public init(
        font: Font,
        color: Color = DueColors.UI.primaryText,
        lineSpacing: CGFloat = 4
    ) {
        self.font = font
        self.color = color
        self.lineSpacing = lineSpacing
    }
    
    public func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
            .lineSpacing(lineSpacing)
    }
}

// MARK: - Text Style Extensions
public extension View {
    // Display styles
    func dueLargeTitle(color: Color = DueColors.UI.primaryText) -> some View {
        modifier(DueTextStyle(font: DueTypography.Display.largeTitle, color: color))
    }
    
    func dueTitle(color: Color = DueColors.UI.primaryText) -> some View {
        modifier(DueTextStyle(font: DueTypography.Display.title, color: color))
    }
    
    func dueTitle2(color: Color = DueColors.UI.primaryText) -> some View {
        modifier(DueTextStyle(font: DueTypography.Display.title2, color: color))
    }
    
    func dueTitle3(color: Color = DueColors.UI.primaryText) -> some View {
        modifier(DueTextStyle(font: DueTypography.Display.title3, color: color))
    }
    
    // Text styles
    func dueHeadline(color: Color = DueColors.UI.primaryText) -> some View {
        modifier(DueTextStyle(font: DueTypography.Text.headline, color: color))
    }
    
    func dueSubheadline(color: Color = DueColors.UI.secondaryText) -> some View {
        modifier(DueTextStyle(font: DueTypography.Text.subheadline, color: color))
    }
    
    func dueBody(color: Color = DueColors.UI.primaryText) -> some View {
        modifier(DueTextStyle(font: DueTypography.Text.body, color: color))
    }
    
    func dueBodyEmphasized(color: Color = DueColors.UI.primaryText) -> some View {
        modifier(DueTextStyle(font: DueTypography.Text.bodyEmphasized, color: color))
    }
    
    func dueCallout(color: Color = DueColors.UI.primaryText) -> some View {
        modifier(DueTextStyle(font: DueTypography.Text.callout, color: color))
    }
    
    func dueFootnote(color: Color = DueColors.UI.secondaryText) -> some View {
        modifier(DueTextStyle(font: DueTypography.Text.footnote, color: color))
    }
    
    func dueCaption(color: Color = DueColors.UI.tertiaryText) -> some View {
        modifier(DueTextStyle(font: DueTypography.Text.caption, color: color))
    }
    
    // Special styles
    func dueGrade(color: Color = DueColors.UI.primaryText) -> some View {
        modifier(DueTextStyle(font: DueTypography.Special.grade, color: color))
    }
    
    func dueTime(color: Color = DueColors.UI.primaryText) -> some View {
        modifier(DueTextStyle(font: DueTypography.Special.time, color: color))
    }
    
    func dueCountdown(color: Color = DueColors.Semantic.warning) -> some View {
        modifier(DueTextStyle(font: DueTypography.Special.countdown, color: color))
    }
    
    func dueCode(color: Color = DueColors.UI.primaryText) -> some View {
        modifier(DueTextStyle(font: DueTypography.Special.code, color: color, lineSpacing: 6))
    }
    
    func dueBadge(color: Color = DueColors.UI.primaryText) -> some View {
        modifier(DueTextStyle(font: DueTypography.Special.badge, color: color, lineSpacing: 0))
    }
    
    func dueButton(color: Color = .white) -> some View {
        modifier(DueTextStyle(font: DueTypography.Special.button, color: color, lineSpacing: 0))
    }
}