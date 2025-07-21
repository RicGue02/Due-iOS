import SwiftUI

// MARK: - Due Spacing System
// Consistent spacing using 4pt grid system

public struct DueSpacing {
    // MARK: - Base Unit
    private static let baseUnit: CGFloat = 4
    
    // MARK: - Spacing Scale
    public static let xxxs: CGFloat = baseUnit * 0.5  // 2pt
    public static let xxs: CGFloat = baseUnit         // 4pt
    public static let xs: CGFloat = baseUnit * 2      // 8pt
    public static let sm: CGFloat = baseUnit * 3      // 12pt
    public static let md: CGFloat = baseUnit * 4      // 16pt
    public static let lg: CGFloat = baseUnit * 5      // 20pt
    public static let xl: CGFloat = baseUnit * 6      // 24pt
    public static let xxl: CGFloat = baseUnit * 8     // 32pt
    public static let xxxl: CGFloat = baseUnit * 10   // 40pt
    public static let huge: CGFloat = baseUnit * 12   // 48pt
    
    // MARK: - Semantic Spacing
    public struct Padding {
        // Component padding
        public static let minimal = xxs
        public static let compact = xs
        public static let standard = md
        public static let comfortable = lg
        public static let spacious = xl
        
        // Screen padding
        public static let screen = md
        public static let screenTop = xxl
        public static let screenBottom = xl
        
        // Card padding
        public static let card = md
        public static let cardCompact = sm
        
        // List padding
        public static let listItem = sm
        public static let listSection = lg
        
        // Form padding
        public static let formField = sm
        public static let formSection = lg
    }
    
    public struct Gap {
        // Vertical gaps
        public static let minimal = xxs
        public static let tight = xs
        public static let standard = sm
        public static let comfortable = md
        public static let loose = lg
        public static let section = xxl
        
        // Horizontal gaps
        public static let inline = xs
        public static let related = sm
        public static let unrelated = md
    }
    
    // MARK: - Component Specific
    public struct Component {
        // Buttons
        public static let buttonHeight: CGFloat = 52
        public static let buttonHeightSmall: CGFloat = 44
        public static let buttonHeightLarge: CGFloat = 60
        public static let buttonPaddingHorizontal = md
        public static let buttonPaddingVertical = sm
        public static let buttonCornerRadius: CGFloat = 12
        
        // Cards
        public static let cardCornerRadius: CGFloat = 16
        public static let cardElevation: CGFloat = 2
        
        // Pills/Chips
        public static let pillHeight: CGFloat = 32
        public static let pillPaddingHorizontal = sm
        public static let pillCornerRadius: CGFloat = 16
        
        // Avatar
        public static let avatarSmall: CGFloat = 32
        public static let avatarMedium: CGFloat = 48
        public static let avatarLarge: CGFloat = 64
        
        // Icons
        public static let iconSmall: CGFloat = 16
        public static let iconMedium: CGFloat = 24
        public static let iconLarge: CGFloat = 32
        
        // Progress
        public static let progressHeight: CGFloat = 8
        public static let progressCornerRadius: CGFloat = 4
    }
    
    // MARK: - Layout Helpers
    public struct Layout {
        public static let maxContentWidth: CGFloat = 428
        public static let compactContentWidth: CGFloat = 320
        
        public static func adaptivePadding(for width: CGFloat) -> CGFloat {
            if width < 375 { // iPhone SE
                return Padding.compact
            } else if width < 428 { // Standard iPhone
                return Padding.standard
            } else { // Large iPhone / iPad
                return Padding.comfortable
            }
        }
    }
}

// MARK: - Spacing ViewModifiers
public extension View {
    func duePadding(_ edges: Edge.Set = .all, _ size: CGFloat = DueSpacing.Padding.standard) -> some View {
        self.padding(edges, size)
    }
    
    func dueCardPadding() -> some View {
        self.padding(DueSpacing.Padding.card)
    }
    
    func dueScreenPadding() -> some View {
        self.padding(.horizontal, DueSpacing.Padding.screen)
            .padding(.top, DueSpacing.Padding.screenTop)
            .padding(.bottom, DueSpacing.Padding.screenBottom)
    }
    
    func dueSpacing(_ axis: Axis.Set = .vertical, _ size: CGFloat = DueSpacing.Gap.standard) -> some View {
        if axis == .vertical {
            return AnyView(self.padding(.vertical, size / 2))
        } else if axis == .horizontal {
            return AnyView(self.padding(.horizontal, size / 2))
        } else {
            return AnyView(self.padding(size / 2))
        }
    }
}

// MARK: - Layout Components
public struct DueSpacer: View {
    let size: CGFloat
    let axis: Axis
    
    public init(_ size: CGFloat = DueSpacing.Gap.standard, axis: Axis = .vertical) {
        self.size = size
        self.axis = axis
    }
    
    public var body: some View {
        if axis == .vertical {
            Spacer().frame(height: size)
        } else {
            Spacer().frame(width: size)
        }
    }
}

public struct DueDivider: View {
    let color: Color
    let thickness: CGFloat
    
    public init(
        color: Color = DueColors.UI.separator,
        thickness: CGFloat = 1
    ) {
        self.color = color
        self.thickness = thickness
    }
    
    public var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: thickness)
    }
}