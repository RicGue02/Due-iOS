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
    @Environment(\.dismiss) private var dismiss
    @Environment(ScheduleModel.self) private var scheduleModel
    
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
    @State private var image: UIImage? = nil
    @State private var isEditMode = false
    @State private var showingDeleteConfirmation = false
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationStack {
            Form {
                // Image Section
                Section {
                    HStack {
                        Spacer()
                        
                        Button {
                            isShowPhotoLibrary = true
                        } label: {
                            VStack(spacing: 8) {
                                if let image = image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                } else {
                                    Circle()
                                        .fill(.regularMaterial)
                                        .frame(width: 100, height: 100)
                                        .overlay {
                                            Image(systemName: "camera.fill")
                                                .font(.title)
                                                .foregroundStyle(.secondary)
                                        }
                                }
                                
                                Text("Add Photo")
                                    .font(.caption)
                                    .foregroundStyle(.blue)
                            }
                        }
                        .buttonStyle(.plain)
                        
                        Spacer()
                    }
                } header: {
                    Text("Subject Photo")
                }
                
                // Basic Information
                Section {
                    TextField("Subject Name", text: $nameText)
                    
                    TextField("Institution", text: $descriptionText, axis: .vertical)
                        .lineLimit(2...4)
                    
                    TextField("Teacher", text: $highlightsText)
                } header: {
                    Text("Basic Information")
                }
                
                // Schedule
                Section {
                    ForEach(timesArray.indices, id: \.self) { index in
                        HStack {
                            Label {
                                Text("\(timesArray[index].day_index.dayName) at \(timesArray[index].time.getString())")
                            } icon: {
                                Image(systemName: "calendar")
                                    .foregroundStyle(.blue)
                            }
                            
                            Spacer()
                            
                            Button {
                                NotificationManager.shared.removeNotificationRequest(timesArray[index].id)
                                timesArray.remove(at: index)
                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                    
                    ScheduleTimePicker(timesArray: $timesArray, date: $date)
                } header: {
                    Text("Schedule")
                } footer: {
                    Text("Add class times for this subject")
                }
                
                // Links and Resources
                Section {
                    TextField("Meeting Link", text: $claseText)
                        .keyboardType(.URL)
                    
                    TextField("Platform Link", text: $courseText)
                        .keyboardType(.URL)
                    
                    TextField("Resources", text: $recursosText)
                        .keyboardType(.URL)
                    
                    TextField("Chat", text: $chatText)
                        .keyboardType(.URL)
                    
                    TextField("Additional Info", text: $moreInfoText, axis: .vertical)
                        .lineLimit(2...4)
                } header: {
                    Text("Links & Resources")
                }
            }
            .navigationTitle(isEditMode ? "Edit Subject" : "New Subject")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditMode ? "Save" : "Add") {
                        addSchedule()
                    }
                    .fontWeight(.semibold)
                    .disabled(nameText.trimmingCharacters(in: .whitespaces).isEmpty || timesArray.isEmpty)
                }
                
                if isEditMode {
                    ToolbarItem(placement: .destructiveAction) {
                        Button {
                            showingDeleteConfirmation = true
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            .onAppear { updateContent() }
            .sheet(isPresented: $isShowPhotoLibrary) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $image)
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
            .alert("Delete Subject", isPresented: $showingDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    if let schedule = scheduleModel.selectedSchedule {
                        scheduleModel.updateSchedules(schedule, isEditMode: true, removeIt: true)
                        Task {
                            try await Task.sleep(for: .milliseconds(200))
                            await MainActor.run {
                                scheduleModel.selectedSchedule = nil
                                dismiss()
                            }
                        }
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure you want to delete this subject? This action cannot be undone.")
            }
        }
    }
    
    
    private func addSchedule() {
        let trimmedName = nameText.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedName.isEmpty else {
            errorMessage = "Please enter a subject name"
            showingError = true
            return
        }
        
        guard !timesArray.isEmpty else {
            errorMessage = "Please add at least one class time"
            showingError = true
            return
        }
        
        do {
            let schedule = try buildScheduleModel()
            scheduleModel.updateSchedules(schedule, isEditMode: isEditMode)
            
            Task {
                try await Task.sleep(for: .milliseconds(200))
                await MainActor.run {
                    dismiss()
                }
            }
        } catch {
            errorMessage = "Failed to save subject: \(error.localizedDescription)"
            showingError = true
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
    
    private func buildScheduleModel() throws -> Schedule {
        let imageURL: URL?
        if let image = self.image {
            imageURL = try DataService.getImageUrlFromDocumentDirectory(image: image)
        } else {
            imageURL = self.scheduleModel.selectedSchedule?.imageURL
        }
        
        let schedule = Schedule(id: self.scheduleModel.selectedSchedule?.id ?? UUID().uuidString,
                                name: nameText,
                                urls: courseText,
                                imageURL: imageURL,
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

struct ScheduleTimePicker: View {
    @Binding var timesArray: [SubjectTime]
    @Binding var date: Date
    @State private var weekdayIndex: Int = -1
    
    var body: some View {
        HStack(spacing: 12) {
            Menu {
                ForEach(WeekDays.allCases, id: \.self) { day in
                    Button {
                        weekdayIndex = day.index
                    } label: {
                        Text(day.rawValue)
                    }
                }
            } label: {
                Text(weekdayIndex > 0 ? weekdayIndex.dayName : "Choose day")
                    .foregroundStyle(weekdayIndex > 0 ? .primary : .secondary)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            
            DatePicker("Time", selection: $date, displayedComponents: [.hourAndMinute])
                .labelsHidden()
                .datePickerStyle(.compact)
            
            Button {
                if weekdayIndex > 0 {
                    let subjectTime = SubjectTime(id: UUID().uuidString, day_index: weekdayIndex, time: date)
                    if !timesArray.contains(subjectTime) {
                        timesArray.append(subjectTime)
                        weekdayIndex = -1
                    }
                }
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundStyle(weekdayIndex > 0 ? .blue : .secondary)
            }
            .disabled(weekdayIndex <= 0)
        }
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
                //espacio y cambio por institution
                Text("Institution:        ")
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
            // highlights ahora es teacher
            ///Highlights
            inputItem(textBinding: $highlightsText, title: "Teacher")
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
            .animation(.none, value: UUID())
           
            SelectedDates(timesArray: $timesArray)
            ///**** **** ***** ***** ***** ***** *****
            Divider()
            ///Clase
            inputItem(textBinding: $claseText, title: "Meeting link")
            ///Course Link
            inputItem(textBinding: $courseText, title: "Platform link")
            ///Recursos Link
            inputItem(textBinding: $recursosText, title: "Resources")
            ///Chat link
            inputItem(textBinding: $chatText, title: "Chat")
            ///More info text
            inputItem(textBinding: $moreInfoText, title: "More Info")
            
        }
        //.palatinoFont(14, weight: .regular)
        .font(.system(size: 14,weight: .regular))
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
                            NotificationManager.shared.removeNotificationRequest(subjectTime.id)
                            timesArray.remove(at: index)
                        }
                }
                //.palatinoFont(14, weight: .regular)
                .font(.system(size: 14,weight: .regular))
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        //.palatinoFont(14, weight: .regular)
        .font(.system(size: 14,weight: .regular))
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
        //.palatinoFont(14, weight: .regular)
        .font(.system(size: 14,weight: .regular))
    }
    
}


struct AddScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleFeaturedView()
        .environment(ScheduleModel())
    }
}
