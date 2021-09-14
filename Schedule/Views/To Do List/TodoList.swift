//
//  ScheduleTodoList.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 9/9/21.
//

import SwiftUI

struct TodoList: View {
    
    @EnvironmentObject var dataStore : DataStore
    
    @State private var modalType: ModalType? = nil
    
    var body: some View {
        
        NavigationView {
            
            List() {
                
                ForEach(dataStore.toDos.value) { toDo in
                    Button {modalType = .update(toDo)} label: {
                        Text(toDo.name)
                            .font(.title3)
                            .strikethrough(toDo.completed)
                            .foregroundColor(toDo.completed ? .black : Color(.label))
                    }
                }
                .onDelete(perform: dataStore.deleteToDo.send)
                
            }
            .navigationTitle("Asignaciones")
            .listStyle(InsetGroupedListStyle())
            .toolbar {ToolbarItem(placement: .navigationBarTrailing) {Button {modalType = .new} label: {Image(systemName: "plus.circle")}
                }
            }
        }
        .foregroundColor(.black)
        .sheet(item: $modalType) { $0 }
        .alert(item: $dataStore.appError.value) { appError in
            Alert(title: Text("Oh Oh"), message: Text(appError.error.localizedDescription))
        }
        
    }
}


struct TodoList_Previews: PreviewProvider {
    static var previews: some View {
        TodoList()
            .environmentObject(DataStore())
    }
}


