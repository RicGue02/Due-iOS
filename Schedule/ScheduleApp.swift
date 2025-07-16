//
//  ScheduleApp.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import SwiftUI

@main
struct ScheduleApp: App {
    
    @State private var listViewModel = ListViewModel()
    
    var body: some Scene {
        WindowGroup {
            ScheduleTabView()
                .environment(listViewModel)
        }
    }
}

