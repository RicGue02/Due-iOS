//
//  ScheduleFeatured.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import SwiftUI

struct ScheduleFeaturedView: View {
    
    @Environment(ScheduleModel.self) private var model
    @State private var isDetailViewShowing = false
    @State private var tabSelectionIndex: Int = 0
    @State private var addSchedule = false
    @State private var displayedSchedule: Schedule?
    
    @State private var animate = false
    let secondaryAccentColor = Color.blue
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if !model.schedules.isEmpty {
                        if !model.featuredSchedules.isEmpty {
                            HStack {
                                Text("Today's Subjects")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.primary)
                                
                                Spacer()
                                
                                Button {
                                    addSchedule = true
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(.blue)
                                }
                            }
                            .padding(.horizontal)
                    
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 16) {
                                    ForEach(model.featuredSchedules.filter { $0.featured == true }) { item in
                                        SubjectCard(subject: item) {
                                            model.selectedSchedule = item
                                            isDetailViewShowing = true
                                        }
                                        .onAppear {
                                            displayedSchedule = item
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .sheet(isPresented: $isDetailViewShowing) {
                                ScheduleDetailView()
                                    .environment(model)
                            }
                    
                            if let displayedSchedule = displayedSchedule {
                                VStack(spacing: 16) {
                                    // Today's Schedule Card
                                    VStack(spacing: 12) {
                                        Text("Today's Schedule")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        ForEach(displayedSchedule.times, id: \.self) { subjectTime in
                                            if subjectTime.day_index == getTodayIndex() {
                                                HStack {
                                                    Image(systemName: "clock.fill")
                                                        .foregroundStyle(.blue)
                                                    Text(subjectTime.time.getString())
                                                        .font(.title2)
                                                        .fontWeight(.medium)
                                                    Spacer()
                                                }
                                            }
                                        }
                                    }
                                    .padding()
                                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                                    
                                    // Subject Details Card
                                    VStack(alignment: .leading, spacing: 16) {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Institution")
                                                .font(.headline)
                                                .fontWeight(.semibold)
                                            Text(displayedSchedule.description)
                                                .font(.body)
                                                .foregroundStyle(.secondary)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Schedule")
                                                .font(.headline)
                                                .fontWeight(.semibold)
                                            
                                            ForEach(displayedSchedule.times, id: \.self) { subjectTime in
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
                                        
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Teacher")
                                                .font(.headline)
                                                .fontWeight(.semibold)
                                            ScheduleHighlights(highlights: displayedSchedule.highlights)
                                                .font(.body)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    .padding()
                                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                                }
                                .padding(.horizontal)
                            }
                    
                        } else {
                            ContentUnavailableView {
                                Label("No Subjects Today", systemImage: "calendar.badge.exclamationmark")
                            } description: {
                                Text("You have no subjects scheduled for today. Enjoy your free time!")
                            }
                            .padding()
                        }
                        
                    } else {
                        ContentUnavailableView {
                            Label("Welcome to Due!", systemImage: "books.vertical")
                        } description: {
                            Text("Add your first subject to get started with managing your schedule.")
                        } actions: {
                            Button("Add Subject") {
                                addSchedule = true
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Today")
            .navigationBarTitleDisplayMode(.large)
            .onAppear(perform: addAnimation)
            .sheet(isPresented: $addSchedule) {
                AddScheduleView()
                    .environment(model)
            }
        }
    }
    
//    func setFeaturedIndex() {
//        // Find the index of first schedule that is featured
//        let index = model.schedules.firstIndex { (schedule) -> Bool in
//            return true ///schedule.featured
//        }
//        tabSelectionIndex = index ?? 0
//    }
    
    func addAnimation() {
        guard !animate else { return }
        Task {
            try await Task.sleep(for: .seconds(1.5))
            await MainActor.run {
                withAnimation(
                    .easeInOut(duration: 2.0)
                    .repeatForever()
                ) {
                    animate.toggle()
                }
            }
        }
    }
}

struct SubjectCard: View {
    let subject: Schedule
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                AsyncImage(url: subject.imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.regularMaterial)
                        .overlay {
                            Image(systemName: "book.fill")
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)
                        }
                }
                .frame(width: 280, height: 200)
                .clipped()
                
                VStack(spacing: 8) {
                    Text(subject.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    if let teacher = subject.highlights.first {
                        Text(teacher)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.regularMaterial)
            }
        }
        .buttonStyle(.plain)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

struct ScheduleFeaturedView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleFeaturedView()
            .environment(ScheduleModel())
    }
}

