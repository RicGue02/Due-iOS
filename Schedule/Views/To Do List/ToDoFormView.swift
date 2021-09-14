//
//  ToDoFormView.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 14/9/21.
//

import SwiftUI

struct CheckboxStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return HStack {
            configuration.label
            Spacer()
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width:24,height: 24)
                .foregroundColor(configuration.isOn ? .green : .gray)
                .font(.system(size: 20, weight: .bold, design: .default))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}

struct ToDoFormView: View {
    
    @EnvironmentObject var dataStore: DataStore
    
    @ObservedObject var formVM: ToDoFormViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        NavigationView {
            
            Form {
                VStack( alignment: .leading) {
                    TextField("Escriba aquí...", text: $formVM.name)
                        .padding(7)
                    Divider()
//                    Toggle("Listo", isOn: $formVM.completed)
                    Toggle(isOn: $formVM.completed, label: {
                        Text("¡Lista la asignación!")
                            .font(Font.custom("Avenir", size: 18))
//                        Image(systemName: "pencil")
                        
                    })
                    .padding()
                    .toggleStyle(CheckboxStyle())
                }
            }
            .navigationTitle("Nueva asignación")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: cancelButton, trailing: updateSaveButton)
        }
    }
}

extension ToDoFormView {
    func updateToDo() {
        let toDo = ToDo(id: formVM.id!, name: formVM.name, completed: formVM.completed)
        dataStore.updateToDo.send(toDo)
        presentationMode.wrappedValue.dismiss()
    }
    
    func addToDo() {
        let toDo = ToDo(name: formVM.name)
        dataStore.addToDo.send(toDo)
        presentationMode.wrappedValue.dismiss()
    }
    
    var cancelButton: some View {
        Button("Cancelar") {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    
    var updateSaveButton: some View {
        Button( formVM.updating ? "Actualizar" : "Guardar",
                action: formVM.updating ? updateToDo : addToDo)
            .disabled(formVM.isDisabled)
            .foregroundColor(.blue)
    }
}

struct ToDoFormView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoFormView(formVM: ToDoFormViewModel())
            .environmentObject(DataStore())
    }
}

