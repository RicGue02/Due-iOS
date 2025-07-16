//
//  ScheduleDetailView.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import SwiftUI

struct ScheduleDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(ScheduleModel.self) private var scheduleModel
    @Environment(ListViewModel.self) private var listViewModel
    
    @State private var showAddView = false
    @State private var isEditMode = false
    @State private var showEditSchedule = false
    
    var navigationBar: Bool = false
    
    var body: some View {
        if let schedule = scheduleModel.selectedSchedule {
            ScrollView {
                VStack(spacing: 20) {
                    // Hero Image Section
                    AsyncImage(url: schedule.imageURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(.regularMaterial)
                            .overlay {
                                Image(systemName: "book.fill")
                                    .font(.largeTitle)
                                    .foregroundStyle(.secondary)
                            }
                    }
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(alignment: .topTrailing) {
                        if !schedule.urls.isEmpty, let url = URL(string: schedule.urls) {
                            Link(destination: url) {
                                Image(systemName: "link.circle.fill")
                                    .font(.title)
                                    .foregroundStyle(.white, .blue)
                                    .background(.regularMaterial, in: Circle())
                            }
                            .padding()
                        }
                    }
                    
                    VStack(spacing: 16) {
                        // Quick Actions
                        HStack(spacing: 16) {
                            if !schedule.clase.isEmpty, let url = URL(string: schedule.clase) {
                                Link(destination: url) {
                                    Label("Join Meeting", systemImage: "video.fill")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(.blue, in: RoundedRectangle(cornerRadius: 10))
                                }
                            }
                            
                            if !schedule.recursos.isEmpty, let url = URL(string: schedule.recursos) {
                                Link(destination: url) {
                                    Label("Resources", systemImage: "folder.fill")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.blue)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
                                }
                            }
                            
                            if !schedule.chat.isEmpty, let url = URL(string: schedule.chat) {
                                Link(destination: url) {
                                    Label("Chat", systemImage: "message.fill")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.green)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 12)
                                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
                                }
                            }
                        }
                        
                        // Subject Details Card
                        VStack(alignment: .leading, spacing: 16) {
                            if !schedule.description.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Institution")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    Text(schedule.description)
                                        .font(.body)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            if let teacher = schedule.highlights.first, !teacher.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Teacher")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    Text(teacher)
                                        .font(.body)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Schedule")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                ForEach(schedule.times, id: \.self) { subjectTime in
                                    Label {
                                        Text("\(subjectTime.day_index.dayName) at \(subjectTime.time.getString())")
                                            .font(.body)
                                            .foregroundStyle(.secondary)
                                    } icon: {
                                        Image(systemName: "calendar")
                                            .foregroundStyle(.blue)
                                    }
                                }
                            }
                            
                            if let additionalInfo = schedule.moreinfo.first, !additionalInfo.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Additional Information")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    Text(additionalInfo)
                                        .font(.body)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .padding()
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                        
                        // Related Tasks
                        let relatedTasks = listViewModel.items.filter { item in
                            item.subject?.id == schedule.id
                        }
                        
                        if !relatedTasks.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Related Tasks")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                    
                                    Button {
                                        listViewModel.selectedItemToEdit = nil
                                        isEditMode = false
                                        showAddView = true
                                    } label: {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundStyle(.blue)
                                    }
                                }
                                
                                ForEach(relatedTasks) { item in
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
                            }
                            .padding()
                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                        } else {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Related Tasks")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                    
                                    Button {
                                        listViewModel.selectedItemToEdit = nil
                                        isEditMode = false
                                        showAddView = true
                                    } label: {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundStyle(.blue)
                                    }
                                }
                                
                                ContentUnavailableView {
                                    Label("No Tasks", systemImage: "checklist")
                                } description: {
                                    Text("No tasks are associated with this subject yet.")
                                }
                            }
                            .padding()
                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
                .padding(.horizontal)
            }
            .toolbar {
                if navigationBar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showEditSchedule = true
                        } label: {
                            Text("Edit")
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
            .sheet(isPresented: $showEditSchedule) {
                AddScheduleView()
                    .environment(scheduleModel)
            }
            .navigationDestination(isPresented: $showAddView) {
                AddView(isEditMode: isEditMode)
            }
        } else {
            ContentUnavailableView {
                Label("Subject Not Found", systemImage: "exclamationmark.triangle")
            } description: {
                Text("The selected subject could not be found.")
            }
        }
    }
}



