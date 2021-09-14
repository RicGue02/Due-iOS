//
//  ScheduleListView.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import SwiftUI

struct ScheduleListView: View {
    
    @EnvironmentObject var model:ScheduleModel
    
    var body: some View {
        
        NavigationView {
            
            VStack (alignment: .leading) {
                
                HStack(spacing: 15) {
                    Button(action: {
                        // Implementar la función de meter materias
                    }, label: {
                        Image(systemName: "plus.circle")
                            .padding(.top, 40)
                    })
                    
                    Text("All Subjects")
                        .bold()
                        .padding(.top, 40)
                        .font(Font.custom("Avenir Heavy", size: 24))
                }
                
                
                ScrollView {
                    LazyVStack (alignment: .leading) {
                        ForEach(model.schedules) { r in
                            
                            NavigationLink(
                                destination: ScheduleDetailView(schedule:r),
                                label: {
                                    
                                    // MARK: Row item
                                    HStack(spacing: 20.0) {
                                        Image(r.image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50, alignment: .center)
                                            .clipped()
                                            .cornerRadius(5)
                                        
                                        VStack (alignment: .leading) {
                                            Text(r.name)
                                                .foregroundColor(.black)
                                                .font(Font.custom("Avenir Heavy", size: 16))
                                            
                                            ScheduleHighlights(highlights: r.highlights)
                                                .foregroundColor(.black)
                                        }
                                    }
                                })
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .padding(.leading)
        }
    }
}

struct ScheduleListView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleListView()
            .environmentObject(ScheduleModel())
    }
}
