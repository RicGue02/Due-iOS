//
//  Spacing.swift
//  Fisioflow - Design System
//
//  Created by Ricardo Guerrero Godínez on 14/7/25.
//

import SwiftUI

// MARK: - Spacing Scale
struct Spacing {
    // Base spacing unit (4pt grid system)
    static let unit: CGFloat = 4
    
    // Spacing Scale
    static let xs: CGFloat = unit * 1      // 4pt
    static let sm: CGFloat = unit * 2      // 8pt
    static let md: CGFloat = unit * 3      // 12pt
    static let lg: CGFloat = unit * 4      // 16pt
    static let xl: CGFloat = unit * 5      // 20pt
    static let xxl: CGFloat = unit * 6     // 24pt
    static let xxxl: CGFloat = unit * 8    // 32pt
    
    // Semantic Spacing
    static let cardPadding: CGFloat = lg        // 16pt
    static let screenPadding: CGFloat = lg      // 16pt
    static let sectionSpacing: CGFloat = xxl    // 24pt
    static let itemSpacing: CGFloat = md        // 12pt
    static let formFieldSpacing: CGFloat = lg   // 16pt
    
    // Component Specific
    static let buttonHeight: CGFloat = 50
    static let inputHeight: CGFloat = 44
    static let tabBarHeight: CGFloat = 80
    static let navigationBarHeight: CGFloat = 44
    
    // Corner Radius
    static let radiusSmall: CGFloat = 8
    static let radiusMedium: CGFloat = 12
    static let radiusLarge: CGFloat = 16
    static let radiusXL: CGFloat = 20
    
    // Icon Sizes
    static let iconSmall: CGFloat = 16
    static let iconMedium: CGFloat = 20
    static let iconLarge: CGFloat = 24
    static let iconXL: CGFloat = 32
    
    // Avatar Sizes
    static let avatarSmall: CGFloat = 32
    static let avatarMedium: CGFloat = 40
    static let avatarLarge: CGFloat = 50
    static let avatarXL: CGFloat = 64
}

// MARK: - Layout Utilities
extension View {
    // Padding shortcuts
    func paddingXS() -> some View {
        self.padding(Spacing.xs)
    }
    
    func paddingSM() -> some View {
        self.padding(Spacing.sm)
    }
    
    func paddingMD() -> some View {
        self.padding(Spacing.md)
    }
    
    func paddingLG() -> some View {
        self.padding(Spacing.lg)
    }
    
    func paddingXL() -> some View {
        self.padding(Spacing.xl)
    }
    
    // Screen-level padding
    func screenPadding() -> some View {
        self.padding(.horizontal, Spacing.screenPadding)
    }
    
    // Card-level padding
    func cardPadding() -> some View {
        self.padding(Spacing.cardPadding)
    }
}

// MARK: - Safe Area Utilities (iOS 17+ Modern Implementation)
extension View {
    /// Modern safe area handling using SwiftUI's native environment
    func safePadding(_ edges: Edge.Set = .all) -> some View {
        self.padding(edges, 0)
            .background(GeometryReader { geometry in
                Color.clear.preference(key: SafeAreaInsetsKey.self, value: geometry.safeAreaInsets)
            })
    }
}

// MARK: - Safe Area Preference Key
struct SafeAreaInsetsKey: PreferenceKey {
    static var defaultValue: EdgeInsets = EdgeInsets()
    static func reduce(value: inout EdgeInsets, nextValue: () -> EdgeInsets) {
        value = nextValue()
    }
}

// MARK: - Legacy Safe Area Support (Deprecated - Use Environment instead)
@available(*, deprecated, message: "Use @Environment(\\.safeAreaInsets) or safePadding() modifier instead")
struct SafeAreaInsets {
    @available(*, deprecated, message: "Use @Environment(\\.safeAreaInsets).bottom")
    static var bottom: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 0
        }
        return window.safeAreaInsets.bottom
    }
    
    @available(*, deprecated, message: "Use @Environment(\\.safeAreaInsets).top")
    static var top: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 0
        }
        return window.safeAreaInsets.top
    }
    
    @available(*, deprecated, message: "Use @Environment(\\.safeAreaInsets).leading")
    static var leading: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 0
        }
        return window.safeAreaInsets.left
    }
    
    @available(*, deprecated, message: "Use @Environment(\\.safeAreaInsets).trailing")
    static var trailing: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 0
        }
        return window.safeAreaInsets.right
    }
}
