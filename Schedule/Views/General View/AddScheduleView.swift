//
//  AddScheduleView.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 9/20/21.
//

import SwiftUI


private let holderWidth:CGFloat = 80
private let bg = Color.gray.opacity(0.2)

struct AddScheduleView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var scheduleModel: ScheduleModel
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    
    
    
    @State private var nameText = ""
    @State private var descriptionText = ""
    @State private var highlightsText = ""
    @State private var claseText = ""
    @State private var courseText = ""
    @State private var recursosText = ""
    @State private var chatText = ""
    @State private var moreInfoText = ""
    @State private var date = Date()
    @State private var timesArray = [SubjectTime]()
    
    @State private var isShowPhotoLibrary = false
    @State private var image:UIImage? = nil
    @State private var isEditMode = false
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    
                    //Image
                    VStack {
                        Image(uiImage: self.image ?? UIImage())
                            .resizable()
                            .scaledToFill()
                            .frame(width: 140, height: 140)
                            .background(bg)
                            .clipShape(Circle())
                            .overlay(
                                ZStack {
                                    if self.image == nil {
                                        Image(systemName: "plus.circle")
                                            .font(.title)
                                    }
                                }
                            )
                            .onTapGesture {
                                self.isShowPhotoLibrary = true
                            }
                        Text("Add image")
                            .foregroundColor(.blue)
                            .palatinoFont(12, weight: .regular)
                            .onTapGesture {self.isShowPhotoLibrary = true}
                    }
                    
                    ///Name
                    inputItem(textBinding: $nameText, title: "Name")
                    //Input Items
                    MainView(nameText: $nameText,
                             descriptionText: $descriptionText,
                             highlightsText: $highlightsText,
                             claseText: $claseText,
                             courseText: $courseText,
                             recursosText: $recursosText,
                             chatText: $chatText,
                             moreInfoText: $moreInfoText,
                             timesArray: $timesArray)
                    
                    //Add Button
                    Button {
                        self.addSchedule()
                    } label: {
                        Text(isEditMode ? "Save" : "Add")
                            .palatinoFont(16, weight: .bold)
                            .foregroundColor(Color.white)
                            .frame(height: 44)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .clipShape(Capsule())
                            .padding(.top, 20)
                    }
                    
                }
            }
        }
        .overlay(
            ZStack {
                if let schedule = self.scheduleModel.selectedSchedule, isEditMode {
                    Button {
                        self.scheduleModel.updateSchedules(schedule, isEditMode: true, removeIt: true)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.scheduleModel.selectedSchedule = nil
                            self.presentationMode.wrappedValue.dismiss()
                        }
                        
                    } label: {
                        Label("delete", systemImage: "xmark")
                            .padding(4)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                    .padding()
                }
                
            }
            
            ,alignment: .topTrailing
        )
        .padding()
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .onAppear {
            updateContent()
        }
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        }
    }
    
    
    private func addSchedule() {
        if self.nameText != "" {
            if timesArray.isEmpty {
               return
            }
            
            let schedule = self.buildScheduleModel()
            self.scheduleModel.updateSchedules(schedule, isEditMode: self.isEditMode)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private func updateContent() {
        if let schedule = scheduleModel.selectedSchedule {
            self.isEditMode = true
            self.image = schedule.getImage(width: 600)
            self.nameText = schedule.name
            self.descriptionText = schedule.description
            self.highlightsText = schedule.highlights.first ?? ""
            self.claseText = schedule.clase
            self.courseText = schedule.urls
            self.recursosText = schedule.recursos
            self.chatText = schedule.chat
            self.moreInfoText = schedule.moreinfo.first ?? ""
            self.timesArray = schedule.times
        }
    }
    
    private func buildScheduleModel() -> Schedule {
        let schedule = Schedule(id: self.scheduleModel.selectedSchedule?.id ?? UUID().uuidString,
                                name: nameText,
                                urls: courseText,
                                imageURL: DataService.getImageUrlFromDocumentDirectory(image: self.image),
                                description: descriptionText,
                                clase: claseText,
                                recursos: recursosText,
                                chat: chatText,
                                highlights: [highlightsText],
                                times: timesArray,
                                moreinfo: [moreInfoText])
        
        self.scheduleModel.selectedSchedule = schedule
        return schedule
    }
}

private struct MainView:View {
    @Binding var nameText:String
    @Binding var descriptionText:String
    @Binding var highlightsText:String
    @Binding var claseText:String
    @Binding var courseText:String
    @Binding var recursosText:String
    @Binding var chatText:String
    @Binding var moreInfoText:String
    @Binding var timesArray:[SubjectTime]
    
    @State private var date = Date()
    @State private var weekdayIndex: Int = -1
    
    
    var body: some View {
        VStack(spacing: 16) {
            ///Description
            HStack(alignment: .top) {
                Text("Description:    ")
                    .font(.caption)
                    .multilineTextAlignment(.leading)
                    .frame(width: holderWidth)
                    
                
                TextEditor(text: $descriptionText)
                    .palatinoFont(14, weight: .regular)
                    .multilineTextAlignment(.leading)
                    .frame(height: 50)
                    .padding(6)
                    .background(bg)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            
            ///Highlights
            inputItem(textBinding: $highlightsText, title: "Highlights")
            ///Dates
            
            HStack (spacing:25) {
                Menu {
                    ForEach(WeekDays.allCases, id:\.self) { day in
                        Button {
                            self.weekdayIndex = day.index
                        } label: {
                            Text("\(day.rawValue)")
                        }
                    }
                } label: {
                    Text(weekdayIndex > 0 ? weekdayIndex.dayName : "Choose day")
                        .frame(minWidth: holderWidth)
                }
                
                DatePicker("Date:", selection: $date, displayedComponents: [.hourAndMinute])
                    .labelsHidden()
                
                Spacer()
                
                Button {
                    if weekdayIndex > 0 {
                        let subjectTime = SubjectTime(id: UUID().uuidString, day_index: self.weekdayIndex, time: self.date)
                        if !timesArray.contains(subjectTime) {
                            self.timesArray.append(subjectTime)
                            self.weekdayIndex = -1
                        }
                    }
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.title2)
                        .opacity(weekdayIndex > 0 ? 1.0 : 0.2)
                }
            }
            .padding(6)
            .background(bg)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .animation(.none)
           
            SelectedDates(timesArray: $timesArray)
            ///**** **** ***** ***** ***** ***** *****
            Divider()
            ///Clase
            inputItem(textBinding: $claseText, title: "Zoom link")
            ///Course Link
            inputItem(textBinding: $courseText, title: "Platform link")
            ///Recursos Link
            inputItem(textBinding: $recursosText, title: "Resources")
            ///Chat link
            inputItem(textBinding: $chatText, title: "Chat")
            ///More info text
            inputItem(textBinding: $moreInfoText, title: "More Info")
            
        }
        .palatinoFont(14, weight: .regular)
    }
}

struct SelectedDates: View {
    @Binding var timesArray:[SubjectTime]
    var body: some View {
        VStack(spacing: 6) {
            ForEach(Array(zip(timesArray.indices, timesArray)), id: \.0) { index, subjectTime in
                Label {
                    Text("\(subjectTime.day_index.dayName) at \(subjectTime.time.getString())")
                } icon: {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.red)
                        .onTapGesture {
                            ///this line only for edit mode
                            ///because there is a notification scheduled
                            NotificationManager.default.removeNotificationRequest(subjectTime.id)
                            timesArray.remove(at: index)
                        }
                }
                .palatinoFont(14, weight: .regular)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .palatinoFont(14, weight: .regular)
    }
}

private struct inputItem: View {
    
    @Binding var textBinding:String
    var title:String
    
    var body: some View {
        HStack {
            Text("\(title): ")
                .font(.caption)
                .frame(width: holderWidth, alignment: .leading)
            
            TextField("\(title)...", text: $textBinding)
                .multilineTextAlignment(.leading)
                .padding(6)
                .background(bg)
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .palatinoFont(14, weight: .regular)
    }
    
}


struct AddScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        AddScheduleView()
    }
}
