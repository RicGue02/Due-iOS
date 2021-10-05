//
//  ScheduleDetailView.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import SwiftUI

struct ScheduleDetailView: View {
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var scheduleModel: ScheduleModel
    @State var editItem = false
    var navigationBar:Bool = false
    
    var body: some View {
        ZStack {
            if let schedule = scheduleModel.selectedSchedule {
                ScrollView {
                    VStack (alignment: .leading) {
                        
                        // MARK: Schedule Image
                        ZStack {
                            Image(uiImage: schedule.getImage(width: 600))
                                .resizable()
                                .scaledToFill()
                                .frame(maxHeight: 300)
                                .background(Color.gray.opacity(0.2))
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
                            .palatinoFont(24, weight: .bold)
                        
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
                            
                            
                            if let chatURL = URL(string: schedule.chat) {
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
                                .palatinoFont(16, weight: .bold)
                                .padding([.bottom, .top], 5)
                            
                            ForEach(schedule.times, id:\.self){ subjectTime in
                                Label {
                                    Text(subjectTime.day_index.dayName + " at " + subjectTime.time.getString())
                                } icon: {
                                    Image(systemName: "clock")
                                }
                                .padding(.bottom, 5)
                                .palatinoFont(15, weight: .regular)
                            }
                            
                        }
                        .padding(.horizontal)
                        
                        // MARK: Divider
                        Divider()
                        
                        // MARK: More Information
                        VStack(alignment: .leading) {
                            Text("Aditional Information")
                                .palatinoFont(16, weight: .bold)
                                .padding([.bottom, .top], 5)
                            
                            ForEach(schedule.moreinfo, id:\.self) { info in
                                Text(info)
                                    .palatinoFont(15, weight: .regular)
                                    .padding(.bottom, 5)
                            }
                        }
                        .padding(.horizontal)
                        
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            self.edit()
                        } label: {
                            Label("Edit", systemImage: "pencil")
                                .palatinoFont(16, weight: .bold)
                        }
                    }
                }
                .overlay(
                    ZStack {
                        if !navigationBar {
                            Button {
                                self.edit()
                            } label: {
                                Label("Edit", systemImage: "pencil")
                                    .padding(4)
                                    .background(Color.white)
                                    .clipShape(Capsule())
                            }
                            .padding()
                        }
                    }
                    
                    ,alignment: .topLeading
                )
                .sheet(isPresented: $editItem){
                    AddScheduleView()
                        .environmentObject(scheduleModel)
                }
                
                
            }else {
                Text("DELETED!")
                    .font(.title)
                    .onAppear {
                        self.mode.wrappedValue.dismiss()
                    }
            }
        }
    }
    
    private func edit() {
        if let schedule = scheduleModel.selectedSchedule {
            self.scheduleModel.selectedSchedule = schedule
                    self.editItem.toggle()
        }
    }
}

struct ScheduleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        // Create a dummy subject and pass it into the detail view so that we can see a preview
        ///let model = ScheduleModel()
        
        ScheduleDetailView()
    }
}

