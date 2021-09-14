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
                    Image(schedule.image)
                        .resizable()
                        .scaledToFill()
                    
                    Link(destination: URL(string: schedule.urls)!) {
                        Image(systemName: "link.circle")
                            .foregroundColor(.black)
                            .font(.largeTitle)
                            .position(x: 360, y: 35)
                            
                    }
                }
                
                // MARK: Schedule title
                Text(schedule.name)
                    .bold()
                    .padding(.top, 20)
                    .padding(.leading)
                    .font(Font.custom("Avenir Heavy", size: 24))
                
                HStack {

                    Link(destination: URL(string: schedule.clase)!) {
                        Image(systemName: "video.circle")
                            .foregroundColor(.black)
                            .font(.largeTitle)
                            .position(x: 60, y: 20)
                    }
 
                    Link(destination: URL(string: schedule.recursos)!) {
                        Image(systemName: "person.crop.circle")
                            .foregroundColor(.black)
                            .font(.largeTitle)
                            .position(x: 60, y: 20)
                    }

                    Link(destination: URL(string: schedule.chat)!) {
                        Image(systemName: "phone.circle")
                            .foregroundColor(.black)
                            .font(.largeTitle)
                            .position(x: 60, y: 20)
                    }
                }
                .padding(5)

                
                
                // MARK: Links
                VStack(alignment: .leading) {
                    Text("Horario")
                        .font(Font.custom("Avenir Heavy", size: 16))
                        .padding([.bottom, .top], 5)
                    
                    ForEach(0..<schedule.link.count, id: \.self) { index in
                        
                        Text("➝ " + schedule.link[index])
                            .padding(.bottom, 5)
                            .font(Font.custom("Avenir", size: 15))
                    }

    
                }
                .padding(.horizontal)
                
                // MARK: Divider
                Divider()
                
                // MARK: More Information
                VStack(alignment: .leading) {
                    Text("Información Adicional")
                        .font(Font.custom("Avenir Heavy", size: 16))
                        .padding([.bottom, .top], 5)
                    
                    ForEach(0..<schedule.moreinfo.count, id: \.self) { index in
                        
                        Text(schedule.moreinfo[index])
                            .padding(.bottom, 5)
                            .font(Font.custom("Avenir", size: 15))
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

