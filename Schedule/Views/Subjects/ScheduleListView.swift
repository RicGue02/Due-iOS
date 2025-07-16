//
//  ScheduleListView.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import SwiftUI

struct ScheduleListView: View {
    
    @Environment(ScheduleModel.self) private var model
    @State private var addSchedule = false
    @State private var showScheduleDetails = false
    
    var body: some View {
        NavigationStack {
            Group {
                if model.schedules.isEmpty {
                    ContentUnavailableView {
                        Label("No Subjects", systemImage: "books.vertical")
                    } description: {
                        Text("Add your first subject to get started with organizing your schedule.")
                    } actions: {
                        Button("Add Subject") {
                            model.selectedSchedule = nil
                            addSchedule = true
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                } else {
                    List(model.schedules) { subject in
                        SubjectListRow(subject: subject) {
                            model.selectedSchedule = subject
                            showScheduleDetails = true
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Subjects")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        model.selectedSchedule = nil
                        addSchedule = true
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                    }
                }
            }
            .navigationDestination(isPresented: $showScheduleDetails) {
                ScheduleDetailView(navigationBar: true)
                    .navigationTitle(model.selectedSchedule?.name ?? "")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .sheet(isPresented: $addSchedule) {
                AddScheduleView()
                    .environment(model)
            }
        }
    }
}

struct SubjectListRow: View {
    let subject: Schedule
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                AsyncImage(url: subject.imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.regularMaterial)
                        .overlay {
                            Image(systemName: "book.fill")
                                .font(.title2)
                                .foregroundStyle(.secondary)
                        }
                }
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(subject.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if let teacher = subject.highlights.first, !teacher.isEmpty {
                        Text(teacher)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    if !subject.description.isEmpty {
                        Text(subject.description)
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.tertiary)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}

struct ScheduleListView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleListView()
            .environment(ScheduleModel())
    }
}
