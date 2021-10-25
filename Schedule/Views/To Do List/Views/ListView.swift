//
//  ListView.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import SwiftUI

struct ListView: View {
    
    @EnvironmentObject var listViewModel: ListViewModel
    @State private var editMode = EditMode.inactive
    
    @State var showAddView = false
    @State var isEditMode = false
    
    var body: some View {
        NavigationView {
            ZStack {
                if listViewModel.items.isEmpty {
                    NoItemsView()
                        .transition(AnyTransition.opacity.animation(.easeIn))
                } else {
                    List {
                        ForEach(listViewModel.items) { item in
                            ListRowView(item: item) {
                                withAnimation(.linear) {
                                    listViewModel.updateItem(item: item)
                                }
                            } editBtn: {
                                self.listViewModel.selectedItemToEdit = item
                                self.isEditMode = true
                                self.showAddView = true
                            }
                        }
                        .onDelete(perform: listViewModel.deleteItem)
                        .onMove(perform: listViewModel.moveItem)
                    }
                    .listStyle(PlainListStyle())
                     
                    //push addView
                    NavigationLink(isActive: $showAddView) {
                        AddView(isEditMode: self.isEditMode)
                    } label: {
                        Spacer()
                            .frame(width: 1, height: 1)
                    }
                }
            }
            .navigationTitle("Tasks")
            //.palatinoFont(16, weight: .bold)
            .font(.system(size: 16,weight: .bold))
            .environment(\.editMode, $editMode)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton(editMode: $editMode)
                        .palatinoFont(14, weight: .regular)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.listViewModel.selectedItemToEdit = nil
                        self.isEditMode = false
                        self.showAddView = true
                    } label: {
                        Text("New")
                            .palatinoFont(16, weight: .bold)
                    }
                }
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
            if let isEditing = editMode.isEditing, isEditing {
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
        .environmentObject(ListViewModel())
    }
}
