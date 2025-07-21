import SwiftUI

// MARK: - Due Color System
// Modern, vibrant colors designed for students

public struct DueColors {
    // MARK: - Brand Colors
    public static let primaryBlue = Color(hex: "007AFF")      // iOS Blue - Trust & Focus
    public static let primaryPurple = Color(hex: "5856D6")    // Academic Purple
    public static let primaryTeal = Color(hex: "00C7BE")      // Fresh & Modern
    public static let primaryIndigo = Color(hex: "5E5CE6")    // Deep Focus
    
    // MARK: - Semantic Colors
    public struct Semantic {
        // Success States
        public static let success = Color(hex: "34C759")      // Green for completed tasks
        public static let successLight = Color(hex: "7FE598")
        public static let successBackground = Color(hex: "E8F9ED")
        
        // Warning States  
        public static let warning = Color(hex: "FF9500")      // Orange for upcoming deadlines
        public static let warningLight = Color(hex: "FFCA7A")
        public static let warningBackground = Color(hex: "FFF4E5")
        
        // Error/Urgent States
        public static let error = Color(hex: "FF3B30")        // Red for overdue items
        public static let errorLight = Color(hex: "FF8078")
        public static let errorBackground = Color(hex: "FFEBE9")
        
        // Info States
        public static let info = primaryTeal
        public static let infoLight = Color(hex: "5DE5DF")
        public static let infoBackground = Color(hex: "E5FAF9")
    }
    
    // MARK: - Subject Colors (12 vibrant options)
    public struct Subject {
        public static let coral = Color(hex: "FF6B6B")       // Math
        public static let orange = Color(hex: "FFA06B")      // Science
        public static let amber = Color(hex: "FFD93D")       // History
        public static let mint = Color(hex: "6BCF7F")        // Language
        public static let teal = Color(hex: "4ECDC4")        // Literature
        public static let ocean = Color(hex: "45B7D1")       // Geography
        public static let sky = Color(hex: "72C3F1")         // Computer Science
        public static let purple = Color(hex: "A78BFA")      // Arts
        public static let pink = Color(hex: "F472B6")        // Music
        public static let rose = Color(hex: "FB7185")        // Physical Ed
        public static let violet = Color(hex: "C084FC")      // Philosophy
        public static let indigo = Color(hex: "818CF8")      // Engineering
        
        public static let all: [Color] = [
            coral, orange, amber, mint, teal, ocean,
            sky, purple, pink, rose, violet, indigo
        ]
    }
    
    // MARK: - UI Colors
    public struct UI {
        // Backgrounds
        public static let background = Color(.systemBackground)
        public static let secondaryBackground = Color(.secondarySystemBackground)
        public static let tertiaryBackground = Color(.tertiarySystemBackground)
        public static let groupedBackground = Color(.systemGroupedBackground)
        
        // Text
        public static let primaryText = Color(.label)
        public static let secondaryText = Color(.secondaryLabel)
        public static let tertiaryText = Color(.tertiaryLabel)
        public static let quaternaryText = Color(.quaternaryLabel)
        public static let placeholderText = Color(.placeholderText)
        
        // Separators & Borders
        public static let separator = Color(.separator)
        public static let opaqueSeparator = Color(.opaqueSeparator)
        public static let border = Color(UIColor.separator.withAlphaComponent(0.2))
        
        // Interactive Elements
        public static let tint = primaryBlue
        public static let link = primaryBlue
        public static let inactive = Color(.systemGray3)
        public static let disabled = Color(.systemGray4)
    }
    
    // MARK: - Special Effects
    public struct Effects {
        // Gradients for modern UI
        public static let primaryGradient = LinearGradient(
            colors: [primaryBlue, primaryPurple],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        public static let successGradient = LinearGradient(
            colors: [Semantic.success, Color(hex: "2FB344")],
            startPoint: .top,
            endPoint: .bottom
        )
        
        public static let warningGradient = LinearGradient(
            colors: [Semantic.warning, Color(hex: "FF7F00")],
            startPoint: .top,
            endPoint: .bottom
        )
        
        public static let skyGradient = LinearGradient(
            colors: [Color(hex: "667EEA"), Color(hex: "764BA2")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // Glass effect colors
        public static let glassWhite = Color.white.opacity(0.1)
        public static let glassBackground = Color(UIColor.systemBackground.withAlphaComponent(0.8))
        
        // Shadow color
        public static let shadow = Color.black.opacity(0.1)
        public static let heavyShadow = Color.black.opacity(0.15)
    }
    
    // MARK: - Dark Mode Adaptive Colors
    public struct Adaptive {
        public static let cardBackground = Color("CardBackground")
        public static let elevatedBackground = Color("ElevatedBackground")
        public static let accentBackground = Color("AccentBackground")
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}