//
//  ScheduleApp.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import SwiftUI
import SwiftData

@main
struct ScheduleApp: App {
    
    @State private var listViewModel = ListViewModel()
    @State private var scheduleModel = ScheduleModel()
    @State private var hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    
    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    ScheduleTabView()
                        .environment(listViewModel)
                        .environment(scheduleModel)
                } else {
                    OnboardingFlow()
                        .environment(listViewModel)
                        .environment(scheduleModel)
                        .onReceive(NotificationCenter.default.publisher(for: .onboardingCompleted)) { _ in
                            hasCompletedOnboarding = true
                        }
                }
            }
            .animation(.smooth(duration: 0.5), value: hasCompletedOnboarding)
        }
    }
}

extension Notification.Name {
    static let onboardingCompleted = Notification.Name("onboardingCompleted")
}

