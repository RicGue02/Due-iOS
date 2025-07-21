//
//  Card.swift
//  Fisioflow - Design System Components
//
//  Created by Ricardo Guerrero Godínez on 14/7/25.
//

import SwiftUI

// MARK: - Basic Card Container
struct Card<Content: View>: View {
    let content: Content
    let padding: CGFloat
    let cornerRadius: CGFloat
    let shadowRadius: CGFloat
    
    init(
        padding: CGFloat = Spacing.lg,
        cornerRadius: CGFloat = Spacing.radiusMedium,
        shadowRadius: CGFloat = 2,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(Color.surfacePrimary)
            .cornerRadius(cornerRadius)
            .shadow(
                color: Color.black.opacity(0.05),
                radius: shadowRadius,
                x: 0,
                y: 1
            )
    }
}

// MARK: - Preview
#if DEBUG
struct Card_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: Spacing.lg) {
            Card {
                VStack(alignment: .leading, spacing: Spacing.sm) {
                    Text("Card Title")
                        .textStyle(.sectionTitle)
                    Text("This is a sample card content with some description text.")
                        .textStyle(.listSubtitle)
                }
            }
            
            Card(padding: Spacing.md, cornerRadius: Spacing.radiusSmall) {
                HStack {
                    Image(systemName: "person.circle")
                        .foregroundColor(.brandBlue)
                    Text("Compact Card")
                        .textStyle(.listTitle)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.labelSecondary)
                }
            }
        }
        .padding()
        .background(Color.surfaceSecondary)
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Card Component")
    }
}
#endif