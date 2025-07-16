//
//  AddView.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import SwiftUI

struct AddView: View {
    
    // MARK: PROPERTIES
    
    @Environment(\.dismiss) private var dismiss
    @Environment(ListViewModel.self) private var listViewModel
    @Environment(ScheduleModel.self) private var model
    
    @State var titleText: String = ""
    @State var dueDate: Date = Date()
    @State var subject: Schedule? = nil
    var isEditMode: Bool = false
    
    @State var showAlert: Bool = false
    @State var errorMessage: String = ""
    
    // MARK: BODY
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Task title", text: $titleText)
                        .font(.body)
                } header: {
                    Text("Title")
                } footer: {
                    Text("Enter a descriptive title for your task")
                }
                
                Section {
                    Picker("Subject", selection: $subject) {
                        Text("No Subject")
                            .tag(nil as Schedule?)
                        
                        ForEach(model.schedules) { schedule in
                            HStack {
                                AsyncImage(url: schedule.imageURL) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Circle()
                                        .fill(.regularMaterial)
                                        .overlay {
                                            Image(systemName: "book.fill")
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                        }
                                }
                                .frame(width: 20, height: 20)
                                .clipShape(Circle())
                                
                                Text(schedule.name)
                            }
                            .tag(schedule as Schedule?)
                        }
                    }
                    .pickerStyle(.menu)
                } header: {
                    Text("Subject")
                } footer: {
                    Text("Associate this task with a subject")
                }
                
                Section {
                    DatePicker(
                        "Due Date", 
                        selection: $dueDate, 
                        in: Date()...,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(.compact)
                } header: {
                    Text("Due Date")
                } footer: {
                    Text("When this task should be completed")
                }
            }
            .navigationTitle(isEditMode ? "Edit Task" : "New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditMode ? "Save" : "Add") {
                        saveButtonPressed()
                    }
                    .fontWeight(.semibold)
                    .disabled(titleText.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .alert("Error", isPresented: $showAlert) {
                Button("OK") { }
            } message: {
                Text(errorMessage)
            }
            .onAppear {
                if let item = listViewModel.selectedItemToEdit {
                    titleText = item.title
                    dueDate = item.due
                    subject = item.subject
                }
            }
        }
    }
    
    func saveButtonPressed() {
        let trimmedTitle = titleText.trimmingCharacters(in: .whitespaces)
        
        guard !trimmedTitle.isEmpty else {
            errorMessage = "Please enter a task title"
            showAlert = true
            return
        }
        
        guard trimmedTitle.count >= 3 else {
            errorMessage = "Task title must be at least 3 characters long"
            showAlert = true
            return
        }
        
        let taskId = isEditMode ? (listViewModel.selectedItemToEdit?.id ?? UUID().uuidString) : UUID().uuidString
        let isCompleted = isEditMode ? (listViewModel.selectedItemToEdit?.isCompleted ?? false) : false
        
        let task = TaskItem(
            id: taskId,
            title: trimmedTitle,
            due: dueDate,
            subject: subject,
            isCompleted: isCompleted
        )
        
        if isEditMode {
            listViewModel.savedEdited(task: task)
        } else {
            listViewModel.addItem(task: task)
        }
        
        dismiss()
    }
    
}

// MARK: PREVIEW

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
            .environment(ListViewModel())
            .environment(ScheduleModel())
    }
}
