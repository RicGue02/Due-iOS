//
//  ContentCard.swift
//  Fisioflow - Design System Components
//
//  Created by Ricardo Guerrero Godínez on 15/7/25.
//

import SwiftUI

// MARK: - Content Card
struct ContentCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content
        }
        .padding(Spacing.lg)
        .background(Color.surfacePrimary)
        .cornerRadius(Spacing.radiusLarge)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Preview
struct ContentCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: Spacing.lg) {
            ContentCard {
                VStack(alignment: .leading, spacing: Spacing.md) {
                    Text("Card Title")
                        .textStyle(.sectionTitle)
                    
                    Text("This is some content inside a content card. It provides a clean, elevated surface for displaying information.")
                        .textStyle(.listSubtitle)
                    
                    HStack {
                        PrimaryButton(title: "Action", icon: "checkmark") {
                            // Action
                        }
                        
                        Spacer()
                        
                        Text("Secondary info")
                            .textStyle(.formCaption)
                            .foregroundColor(.labelSecondary)
                    }
                }
            }
            
            ContentCard {
                HStack {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text("Simple Card")
                            .textStyle(.listTitle)
                        Text("With minimal content")
                            .textStyle(.listSubtitle)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.labelTertiary)
                }
            }
        }
        .padding()
        .background(Color.surfaceGrouped)
    }
}