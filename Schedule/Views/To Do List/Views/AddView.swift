//
//  AddView.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import SwiftUI

struct AddView: View {
    
    // MARK: PROPERTIES
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var listViewModel: ListViewModel
    @EnvironmentObject var model:ScheduleModel
    
    @State var titleText:String = ""
    @State var dueDate:Date = Date()
    @State var subject:Schedule? = nil
    var isEditMode:Bool = false
    
    @State var alertTitle: String = ""
    @State var showAlert: Bool = false
    
    // MARK: BODY
    
    var body: some View {
        ScrollView {
            VStack {
                TextField("Write here...", text: $titleText)
                    .palatinoFont(14, weight: .regular)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
                
                HStack {
                    Menu {
                        ForEach(self.model.schedules, id: \.self) { subject in
                            Button {
                                self.subject = subject
                            } label: {
                                Text(subject.name)
                            }
                        }
                        
                    } label: {
                        buttonStyle(self.subject?.name ?? "Subject")
                    }
                    .opacity(self.model.schedules.isEmpty ? 0.4 : 1.0)
                    .disabled(self.model.schedules.isEmpty)
                    
                    HStack {
                        DatePicker("", selection: $dueDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                            .labelsHidden()
                    }
                    .frame(maxWidth: .infinity)
                    .overlay(
                        Text("Due Date:")
                            .font(.caption2)
                            .padding(.top, -20)
                        ,alignment: .topLeading
                    )
                }
                .padding(.top, 40)
                Button(action: {
                    saveButtonPressed()
                }, label: {
                    buttonStyle("save")
                })
            }
            .padding(14)
            .animation(.none)
        }
        .navigationTitle("New Task")
        .alert(isPresented: $showAlert, content: getAlert)
        .onAppear {
            if let item = self.listViewModel.selectedItemToEdit {
                self.titleText = item.title
                self.dueDate = item.due
                self.subject = item.subject
            }
        }
    }
    
    // MARK: FUNCTIONS
    @ViewBuilder
    func buttonStyle(_ title:String) -> some View {
        Text(title.uppercased())
            .foregroundColor(.white)
            .lineLimit(1)
            .palatinoFont(16, weight: .bold)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .clipShape(Capsule())
    }
    
    func saveButtonPressed() {
        if textIsAppropriate() {
            var id = UUID().uuidString
            var isCompleted = false
            if isEditMode {
                id = self.listViewModel.selectedItemToEdit?.id ?? UUID().uuidString
                isCompleted = self.listViewModel.selectedItemToEdit?.isCompleted ?? false
            }
            
            
            let task = TaskItem(id: id,
                                title: titleText,
                                due: dueDate,
                                subject: subject,
                                isCompleted: isCompleted)
            
            if isEditMode {
                self.listViewModel.savedEdited(task: task)
            }else {
                self.listViewModel.addItem(task: task)
            }
            
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func textIsAppropriate() -> Bool {
        if titleText.count < 3 {
            alertTitle = "Something went wrong"
            showAlert.toggle()
            return false
        }
        return true
    }
    
    func getAlert() -> Alert {
        return Alert(title: Text(alertTitle))
    }
    
}

// MARK: PREVIEW

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                AddView()
            }
            .foregroundColor(.blue)
            .preferredColorScheme(.light)
            .environmentObject(ListViewModel())
            NavigationView {
                AddView()
            }
            .preferredColorScheme(.dark)
            .environmentObject(ListViewModel())
            .foregroundColor(.blue)
            
        }.foregroundColor(.blue)
        
    }
}
