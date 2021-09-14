//
//  ScheduleFeatured.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import SwiftUI

struct ScheduleFeaturedView: View {
    
    
    @EnvironmentObject var model:ScheduleModel
    @State var isDetailViewShowing = false
    @State var tabSelectionIndex = 0
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
        
            Text("Materias Destacadas")
                .bold()
                .padding(.leading)
                .padding(.top, 40)
                .font(Font.custom("Avenir Heavy", size: 24))
                
            
            GeometryReader { geo in
            
            TabView (selection: $tabSelectionIndex) {
                
                // Loop through each schedule
                ForEach (0..<model.schedules.count) { index in
                    
                    // Only show those that should be featured
                    if model.schedules[index].featured == true {
                    
                        // Recipe card button
                        Button(action: {
                            
                            // Show the schedule detail sheet
                            self.isDetailViewShowing = true
                            
                        }, label: {
                            
                            // schedule card
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.white)
                                    
                                
                                VStack(spacing: 0) {
                                    Image(model.schedules[index].image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipped()
                                    Text(model.schedules[index].name)
                                        .padding(5)
                                        .font(Font.custom("Avenir", size: 15))
                                }
                            }
                            
                        })
                        .tag(index)
                        .sheet(isPresented: $isDetailViewShowing) {
                            // Show the schedule Detail View
                            ScheduleDetailView(schedule: model.schedules[index])
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: geo.size.width - 40, height: geo.size.height - 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .cornerRadius(15)
                        .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.5), radius: 10, x: -5, y: 5)
                        
                    }
                }
                
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            
        }
        
            VStack (alignment: .leading, spacing: 10) {
                
                Text("Institución:")
                    .font(Font.custom("Avenir Heavy", size: 16))
                Text(model.schedules[tabSelectionIndex].description)
                    .font(Font.custom("Avenir", size: 15))
                Text("Profesor(a):")
                    .font(Font.custom("Avenir Heavy", size: 16))
                ScheduleHighlights(highlights: model.schedules[tabSelectionIndex].highlights)
                
            }
            .padding([.leading, .bottom])
        }
        .onAppear(perform: {
            setFeaturedIndex()
        })
    }
    
    func setFeaturedIndex() {
        
        // Find the index of first schedule that is featured
        let index = model.schedules.firstIndex { (schedule) -> Bool in
            return schedule.featured
        }
        tabSelectionIndex = index ?? 0
    }
}

struct RecipeFeaturedView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleFeaturedView()
            .environmentObject(ScheduleModel())
    }
}

