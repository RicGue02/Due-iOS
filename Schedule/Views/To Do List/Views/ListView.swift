//
//  ListView.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import SwiftUI

struct ListView: View {
    
    @Environment(ListViewModel.self) private var listViewModel
    @State private var showAddView = false
    @State private var isEditMode = false
    
    var body: some View {
        NavigationStack {
            Group {
                if listViewModel.items.isEmpty {
                    ContentUnavailableView {
                        Label("No Tasks Yet", systemImage: "checklist")
                    } description: {
                        Text("Add your first task to get started with staying organized.")
                    } actions: {
                        Button("Add Task") {
                            listViewModel.selectedItemToEdit = nil
                            isEditMode = false
                            showAddView = true
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                } else {
                    List {
                        ForEach(listViewModel.items) { item in
                            TaskRowView(item: item) {
                                withAnimation(.smooth) {
                                    listViewModel.updateItem(item: item)
                                }
                            } editAction: {
                                listViewModel.selectedItemToEdit = item
                                isEditMode = true
                                showAddView = true
                            }
                        }
                        .onDelete(perform: listViewModel.deleteItem)
                        .onMove(perform: listViewModel.moveItem)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Tasks")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        listViewModel.selectedItemToEdit = nil
                        isEditMode = false
                        showAddView = true
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                    }
                }
            }
            .navigationDestination(isPresented: $showAddView) {
                AddView(isEditMode: isEditMode)
            }
        }
    }    
}

struct EditButton: View {
    @Binding var editMode: EditMode

    var body: some View {
        Button {
            switch editMode {
            case .active: editMode = .inactive
            case .inactive: editMode = .active
            default: break
            }
        } label: {
            if editMode.isEditing {
                Text("Done")
                    //.palatinoFont(16, weight: .bold)
                    .font(.system(size: 16,weight: .bold))

            } else {
                Text("Edit")
                    //.palatinoFont(16, weight: .bold)
                    .font(.system(size: 16,weight: .bold))
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ListView()
        }
        .environment(ListViewModel())
    }
}
