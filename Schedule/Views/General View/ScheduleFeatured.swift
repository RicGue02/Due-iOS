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
    @State var tabSelectionIndex:Int = 0
    @State var addSchedule = false
    @State var displayedSchedule:Schedule? = nil
    
    @State var animate: Bool = false
    let secondaryAccentColor = Color(.blue)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if !model.schedules.isEmpty {
                if !model.featuredSchedules.isEmpty {
                    Text("Featured Subjects")
                        //.palatinoFont(24, weight: .bold)
                        .font(.system(size: 24,weight: .bold))
                        .padding(.leading)
                        .padding(.top, 40)
                    
                    GeometryReader { geo in
                        TabView (selection: $tabSelectionIndex) {
                            // Loop through each schedule
                            ForEach(Array(zip(model.featuredSchedules.indices, model.featuredSchedules)), id: \.0) { index, item in
                                if item.featured! {
                                    VStack {
                                        // Recipe card button
                                        Button(action: {
                                            // Show the schedule detail sheet
                                            self.model.selectedSchedule = item
                                            self.isDetailViewShowing = true
                                            
                                        }, label: {
                                            
                                            // schedule card
                                            ZStack {
                                                Rectangle()
                                                    .foregroundColor(Color(.systemGray6))
                                                
                                                VStack(spacing: 0) {
                                                    Image(uiImage: item.getImage(width: 600))
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(height: geo.size.height - 100)
                                                        .clipped()
                                                }
                                                .overlay(
                                                    VStack {
                                                        Text(item.name)
                                                            //.palatinoFont(15, weight: .regular)
                                                            .font(.system(size: 14,weight: .regular))
                                                            .frame(maxWidth: .infinity, alignment: .center)
                                                            .padding(8)
                                                    }
                                                    
                                                    ,alignment: .bottom
                                                )
                                            }
                                            
                                        })
                                        .tag(item.id)
                                        .sheet(isPresented: $isDetailViewShowing) {
                                            // Show the schedule Detail View
                                            ScheduleDetailView()
                                                .environmentObject(model)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        .frame(width: geo.size.width - 40, height: geo.size.height - 100, alignment: .center)
                                        .cornerRadius(15)
                                        .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.5), radius: 10, x: -5, y: 5)
                                        .onAppear {self.displayedSchedule = item}
                                    }
                                    .tag(index)
                                }
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                    }
                    .frame(minHeight: 480)
                    
                    if let displayedSchedule = displayedSchedule {
                        VStack (alignment: .leading, spacing: 10) {
                            VStack {
                                
                                // Editar para display mas lindo 
                                Text("Today")
                                    //.palatinoFont(12, weight: .regular)
                                    .font(.system(size: 12,weight: .regular))

                                ForEach(displayedSchedule.times, id:\.self) { subjectTime in
                                    if subjectTime.day_index == getTodayIndex() {
                                        Text(subjectTime.time.getString())
                                            //.palatinoFont(26, weight: .regular)
                                            .font(.system(size: 18,weight: .thin))
                                    }
                                }
                            }.frame(maxWidth: .infinity)
                            
                            Divider()
                            
                            ScrollView(showsIndicators: false) {
                                VStack(alignment: .leading) {
                                                                        
                                    Text("Institution:")
                                        //.palatinoFont(18, weight: .bold)
                                        .font(.system(size: 16,weight: .regular))
                                    Text(displayedSchedule.description)
                                        //.palatinoFont(15, weight: .regular)
                                        .font(.system(size: 14,weight: .thin))
                                        .padding(.leading, 16)
                                    
                                    Spacer()
                                    
                                    Text("Date:")
                                        //.palatinoFont(18, weight: .bold)
                                        .font(.system(size: 16,weight: .regular))
                                    
                                    ForEach(displayedSchedule.times, id:\.self) { subjectTime in
                                        Label {
                                            Text(subjectTime.day_index.dayName + " at " + subjectTime.time.getString())
                                                //.palatinoFont(15, weight: .regular)
                                                .font(.system(size: 14,weight: .thin))
                                        } icon: {
                                            Image(systemName: "clock")
                                        }
                                    }
                                    .padding(.leading, 16)
                                    
                                    Spacer()
                                    
                                    Text("Teacher:")
                                        //.palatinoFont(18, weight: .bold)
                                        .font(.system(size: 16,weight: .regular))
                                    
                                    ScheduleHighlights(highlights: displayedSchedule.highlights)
                                        //.palatinoFont(16, weight: .regular)
                                        .font(.system(size: 14,weight: .thin))
                                        .padding(.leading, 16)
                                }
                                                                
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                        }
                        .padding([.leading, .bottom])
                    }
                    
                }else {
                   
                    Text("No Subjects Today!")
                        .font(.title.bold())
                    
                }
                
            }else {
                VStack(spacing: 10) {
                    Text("Welcome to Due!")
                        //.palatinoFont(26, weight: .bold)
                        .font(.system(size: 26,weight: .regular))

                    Text("Add your subject so you can keep everything tight")
                        .padding(.bottom, 20)
                        //.palatinoFont(14, weight: .regular)
                        .font(.system(size: 14,weight: .thin))
                    
                    Divider()
                    Spacer()
                    
                    //aún no me decido de la imagen/logo
                    Image("med")
                        .resizable()
                        .scaledToFit()
                        .clipped()
                    
                    Spacer()

                    HStack(spacing: 10) {
                        Button(action: {
                            self.addSchedule = true
                        }, label: {
                            Image(systemName: "plus.circle")
                                .font(.title2)
                        })
                        Text("New subject!")
                            //.palatinoFont(14, weight: .bold)
                            .font(.system(size: 14,weight: .bold))
                            .onTapGesture {self.addSchedule = true}
                            .foregroundColor(.blue)
                    }
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(10)
                    .padding(.horizontal, animate ? 30 : 50)
                    .shadow(
                        color: animate ? secondaryAccentColor.opacity(0.5) : Color.blue.opacity(0.5),
                        radius: animate ? 30 : 10,
                        x: 0,
                        y: animate ? 50 : 30)
                    .scaleEffect(animate ? 1.1 : 1.0)
                    .offset(y: animate ? -7 : 0)
                }
            }
        }
        .frame(maxWidth: 400)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 20)
        .onAppear(perform: addAnimation)
        //.onAppear(perform: {setFeaturedIndex()})
        .sheet(isPresented: $addSchedule) {
            AddScheduleView()
            .environmentObject(model)
        }
    }
    
//    func setFeaturedIndex() {
//        // Find the index of first schedule that is featured
//        let index = model.schedules.firstIndex { (schedule) -> Bool in
//            return true ///schedule.featured
//        }
//        tabSelectionIndex = index ?? 0
//    }
    
    func addAnimation() {
        guard !animate else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(
                Animation
                    .easeInOut(duration: 2.0)
                    .repeatForever()
            ) {
                animate.toggle()
            }
        }
    }
}



struct ScheduleFeaturedView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleFeaturedView()
            .environmentObject(ScheduleModel())
    }
}

