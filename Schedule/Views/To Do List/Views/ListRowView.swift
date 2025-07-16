//
//  ListRowView.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import SwiftUI

struct TaskRowView: View {
    
    let item: TaskItem
    let completedAction: () -> Void
    let editAction: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Completion Button
            Button(action: completedAction) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(item.isCompleted ? .green : .gray)
            }
            .buttonStyle(.plain)
            
            // Task Content
            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundStyle(item.isCompleted ? .secondary : .primary)
                    .strikethrough(item.isCompleted)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 8) {
                    Label {
                        Text(item.due.formatted(date: .abbreviated, time: .shortened))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    } icon: {
                        Image(systemName: "calendar")
                            .foregroundStyle(.blue)
                    }
                    
                    if let remaining = item.remaining, !remaining.isEmpty {
                        Label {
                            Text(remaining)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        } icon: {
                            Image(systemName: "clock")
                                .foregroundStyle(.orange)
                        }
                    }
                    
                    Spacer()
                }
                
                if let subject = item.subject {
                    HStack(spacing: 8) {
                        AsyncImage(url: subject.imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(.regularMaterial)
                                .overlay {
                                    Image(systemName: "book.fill")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                        }
                        .frame(width: 28, height: 28)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        
                        Text(subject.name)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.blue)
                            .lineLimit(1)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture { editAction() }
    }
}

// Keep the old name as an alias for compatibility
typealias ListRowView = TaskRowView

