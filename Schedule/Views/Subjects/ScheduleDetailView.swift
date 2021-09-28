//
//  ScheduleDetailView.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import SwiftUI

struct ScheduleDetailView: View {
    
    var schedule:Schedule
    
    var body: some View {
        
        ScrollView {
        
            VStack (alignment: .leading) {
                
                // MARK: Schedule Image
                
                ZStack {
                    Image(uiImage: schedule.getImage(width: 600))
                        .resizable()
                        .scaledToFill()
                        .clipped()
                    
                    if let urls = URL(string: schedule.urls) {
                        Link(destination: urls) {
                            Image(systemName: "link.circle")
                                .foregroundColor(.black)
                                .font(.largeTitle)
                                .position(x: 360, y: 35)
                        }
                    }
                }
                
                // MARK: Schedule title
                Text(schedule.name)
                    .bold()
                    .padding(.top, 20)
                    .padding(.leading)
                    .font(Font.custom("Palentino Heavy", size: 24))
                
                HStack {

                    if let claseURL = URL(string: schedule.clase) {
                        Link(destination: claseURL) {
                            Image(systemName: "video.circle")
                                .foregroundColor(.black)
                                .font(.largeTitle)
                                .position(x: 60, y: 20)
                        }
                    }
                    
 
                    if let recursosURL = URL(string: schedule.recursos) {
                        Link(destination: recursosURL) {
                            Image(systemName: "person.crop.circle")
                                .foregroundColor(.black)
                                .font(.largeTitle)
                                .position(x: 60, y: 20)
                        }
                    }
                    

                    if let chatURL = URL(string: schedule.clase) {
                        Link(destination: chatURL) {
                            Image(systemName: "phone.circle")
                                .foregroundColor(.black)
                                .font(.largeTitle)
                                .position(x: 60, y: 20)
                        }
                    }
                    
                }
                .padding(5)
            
                // MARK: Links
                VStack(alignment: .leading) {
                    Text("Schedule")
                        .font(Font.custom("Palentino", size: 16))
                        .padding([.bottom, .top], 5)
                    
                    ForEach(0..<schedule.dates.count, id: \.self) { index in
                        
                        Text("➝ " + "\(schedule.dates[index])")
                            .padding(.bottom, 5)
                            .font(Font.custom("Palentino", size: 15))
                    }

    
                }
                .padding(.horizontal)
                
                // MARK: Divider
                Divider()
                
                // MARK: More Information
                VStack(alignment: .leading) {
                    Text("Aditional Information")
                        .font(Font.custom("Palentino", size: 16))
                        .padding([.bottom, .top], 5)
                    
                    ForEach(0..<schedule.moreinfo.count, id: \.self) { index in
                        
                        Text(schedule.moreinfo[index])
                            .padding(.bottom, 5)
                            .font(Font.custom("Palentino", size: 15))
                    }
                }
                .padding(.horizontal)
                
            }
        }
    }
}

struct ScheduleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        // Create a dummy subject and pass it into the detail view so that we can see a preview
        let model = ScheduleModel()
        
        ScheduleDetailView(schedule: model.schedules[0])
    }
}

