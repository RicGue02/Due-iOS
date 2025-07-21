//
//  HapticFeedback.swift
//  Fisioflow - Design System
//  iOS 17+ Haptic Feedback System
//
//  Created by Ricardo Guerrero Godínez on 14/7/25.
//

import SwiftUI
import UIKit

// MARK: - Haptic Feedback Manager
struct HapticFeedback {
    /// Light impact feedback - for subtle interactions
    static func light() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
    }
    
    /// Medium impact feedback - for standard interactions
    static func medium() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    /// Heavy impact feedback - for important interactions
    static func heavy() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.impactOccurred()
    }
    
    /// Success feedback - for successful actions
    static func success() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
    }
    
    /// Warning feedback - for warning actions
    static func warning() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.warning)
    }
    
    /// Error feedback - for error states
    static func error() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.error)
    }
    
    /// Selection feedback - for picker/selector changes
    static func selection() {
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.selectionChanged()
    }
}

// MARK: - Haptic View Modifiers
extension View {
    /// Adds light haptic feedback on tap
    func hapticLight() -> some View {
        self.onTapGesture {
            HapticFeedback.light()
        }
    }
    
    /// Adds medium haptic feedback on tap
    func hapticMedium() -> some View {
        self.onTapGesture {
            HapticFeedback.medium()
        }
    }
    
    /// Adds success haptic feedback
    func hapticSuccess() -> some View {
        self.modifier(HapticSuccessModifier())
    }
    
    /// Adds error haptic feedback
    func hapticError() -> some View {
        self.modifier(HapticErrorModifier())
    }
    
    /// Adds selection haptic feedback for pickers
    func hapticSelection() -> some View {
        self.modifier(HapticSelectionModifier())
    }
}

// MARK: - Haptic Modifiers
struct HapticSuccessModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                HapticFeedback.success()
            }
    }
}

struct HapticErrorModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                HapticFeedback.error()
            }
    }
}

struct HapticSelectionModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                HapticFeedback.selection()
            }
    }
}

// MARK: - Usage Examples
/*
 Usage in components:
 
 Button("Save") {
     // Action
 }
 .onTapGesture {
     HapticFeedback.success()
 }
 
 // Or using modifiers:
 FormField(...)
     .hapticLight()
 
 PrimaryButton("Submit") {
     // Action
 }
 .hapticSuccess()
 */