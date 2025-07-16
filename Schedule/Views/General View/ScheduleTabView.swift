//
//  ContentView.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import SwiftUI

struct ScheduleTabView: View {
    @State private var scheduleModel = ScheduleModel()
    @State private var listViewModel = ListViewModel()
    
    var body: some View {
        TabView {
            ScheduleFeaturedView()
                .tabItem {
                    Label("Today", systemImage: "calendar")
                }
                .tag(0)
            
            ListView()
                .tabItem {
                    Label("Tasks", systemImage: "list.star")
                }
                .tag(1)
            
            ScheduleListView()
                .tabItem {
                    Label("Subjects", systemImage: "books.vertical")
                }
                .tag(2)
        }
        .environment(scheduleModel)
        .environment(listViewModel)
        .tint(.accentColor)
    }
}

struct ScheduleTabView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleTabView()
    }
}

