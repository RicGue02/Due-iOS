//
//  ContentView.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import SwiftUI

struct ScheduleTabView: View {
    @StateObject var listViewModel: ListViewModel = ListViewModel()
    
    var body: some View {
        
        Divider()
        
        TabView {
            ScheduleFeaturedView()
                .tabItem {
                    VStack {
                        Image(systemName: "calendar")
                        Text("Schedule")
                    }
                }
           
            ListView()
                .tabItem {
                    VStack {
                        Image(systemName: "list.star")
                        Text("Tasks")
                    }
                }
            
            ScheduleListView()
                .tabItem {
                    VStack {
                        Image(systemName: "books.vertical")
                        Text("Subjects")
                    }
                }
        }
        .environmentObject(ScheduleModel())
    }
}

struct ScheduleTabView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleTabView()
    }
}

