//
//  ScheduleApp.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import SwiftUI

@main
struct ScheduleApp: App {
    
    @StateObject var listViewModel: ListViewModel = ListViewModel()
    
    var body: some Scene {
        WindowGroup {
            ScheduleTabView()
                .environmentObject(listViewModel)
        }
    }
}

