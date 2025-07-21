//
//  QuickActionButton.swift
//  Fisioflow
//
//  Created by Ricardo Guerrero Godínez on 4/7/25.
//

import SwiftUI

struct QuickActionButton: View {
    @Environment(\.colorScheme) private var colorScheme

    var icon: String
    var label: String
    // Now accepts a two-color gradient instead of a single color
    var gradient: Gradient
    var action: () -> Void

    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            action()
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(LinearGradient(
                            gradient: gradient,
                            startPoint: .top,
                            endPoint: .bottom))
                        .frame(width: 36, height: 36)
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                }
                Text(label)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 24)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(LinearGradient(
                        gradient: gradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing))
            )
            .shadow(
                color: Color.black.opacity(colorScheme == .light ? 0.2 : 0.6),
                radius: colorScheme == .light ? 6 : 10,
                x: 0, y: colorScheme == .light ? 3 : 5
            )
        }
        .padding(.horizontal, 24)
    }
}
