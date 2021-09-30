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
    @State var addSchedule = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            if !model.schedules.isEmpty {
                Text("Featured Subjects")
                    .bold()
                    .padding(.leading)
                    .padding(.top, 40)
                    .font(Font.custom("Palentino Heavy", size: 24))
                
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
                                            Image(uiImage: model.schedules[index].getImage(width: 600))
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(height: geo.size.height - 100)
                                                .clipped()
                                        }
                                        .overlay(
                                            VStack {
                                                Text(model.schedules[index].name)
                                                    .font(Font.custom("Palentino", size: 15))
                                                    .frame(maxWidth: .infinity, alignment: .center)
                                                    .padding(8)
                                                    .background(Color.white)
                                            }
                                            
                                            ,alignment: .bottom
                                        )
                                    }
                                    
                                })
                                .tag(index)
                                .sheet(isPresented: $isDetailViewShowing) {
                                    // Show the schedule Detail View
                                    ScheduleDetailView(schedule: model.schedules[index])
                                }
                                .buttonStyle(PlainButtonStyle())
                                .frame(width: geo.size.width - 40, height: geo.size.height - 100, alignment: .center)
                                .cornerRadius(15)
                                .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.5), radius: 10, x: -5, y: 5)
                                
                            }
                        }
                        
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    
                }
                
                
                if model.schedules[tabSelectionIndex].featured == true {
                    VStack (alignment: .leading, spacing: 10) {
                        Text("Institución:")
                            .font(Font.custom("Palentino Heavy", size: 16))
                        Text(model.schedules[tabSelectionIndex].description)
                            .font(Font.custom("Palentino", size: 15))
                        Text("Profesor(a):")
                            .font(Font.custom("Palentino Heavy", size: 16))
                        ScheduleHighlights(highlights: model.schedules[tabSelectionIndex].highlights)
                        
                    }
                    .padding([.leading, .bottom])
                }
                
                
                
            }else {
                HStack(spacing: 5) {
                    Button(action: {
                        self.addSchedule = true
                    }, label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                    })
                    Text("No subjects attached!")
                        .font(Font.custom("Palentino", size: 14))
                        .onTapGesture {self.addSchedule = true}
                }
                .padding()
            }
        }
        .onAppear(perform: {
            setFeaturedIndex()
        })
        .sheet(isPresented: $addSchedule) {
            AddScheduleView()
                .environmentObject(model)
        }
    }
    
    func setFeaturedIndex() {
        // Find the index of first schedule that is featured
        let index = model.schedules.firstIndex { (schedule) -> Bool in
            return true ///schedule.featured
        }
        tabSelectionIndex = index ?? 0
    }
}

struct ScheduleFeaturedView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleFeaturedView()
            .environmentObject(ScheduleModel())
    }
}

