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
    
    var body: some View {
        NavigationView {
            ZStack {
                if listViewModel.items.isEmpty {
                    NoItemsView()
                        .transition(AnyTransition.opacity.animation(.easeIn))
                } else {
                    List {
                        ForEach(listViewModel.items) { item in
                            ListRowView(item: item)
                                .onTapGesture {
                                    withAnimation(.linear) {
                                        listViewModel.updateItem(item: item)
                                    }
                                }
                        }
                        .onDelete(perform: listViewModel.deleteItem)
                        .onMove(perform: listViewModel.moveItem)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Tasks")
            .font(Font.custom("Palentino", size: 16))
            .environment(\.editMode, $editMode)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton(editMode: $editMode)
                        .font(Font.custom("Palentino", size: 14))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("New", destination: AddView())
                        .font(Font.custom("Palentino", size: 16))
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
                    .font(Font.custom("Palentino", size: 16))
            } else {
                Text("Edit")
                    .font(Font.custom("Palentino", size: 16))
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
