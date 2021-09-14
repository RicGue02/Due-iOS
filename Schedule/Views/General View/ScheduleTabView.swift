//
//  ContentView.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import SwiftUI



struct ScheduleTabView: View {
    
    
    var body: some View {
        
        TabView {
            
            ScheduleFeaturedView()
                .tabItem {
                    VStack {
                        Image(systemName: "book")
                        Text("Horario")
                    }
                }
           
            TodoList()
                .tabItem {
                    VStack {
                        Image(systemName: "list.star")
                        Text("Asignaciones")
                    }
                }
            
            ScheduleListView()
                .tabItem {
                    VStack {
                        Image(systemName: "books.vertical")
                        Text("Materias")
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

