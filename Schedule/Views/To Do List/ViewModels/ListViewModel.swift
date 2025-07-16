//
//  ListViewModel.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import Foundation
import SwiftUI
import Observation

@MainActor
@Observable
class ListViewModel {
    
    var selectedItemToEdit: TaskItem? = nil
    var items: [TaskItem] = [] {
        didSet {
            saveItems()
        }
    }
 
    let itemsKey: String = "items_list"
    
    init() {
        getItems()
    }
    
    func getItems() {
        guard
            let data = UserDefaults.standard.data(forKey: itemsKey),
            let savedItems = try? JSONDecoder().decode([TaskItem].self, from: data)
        else { return }

        self.items = savedItems
    }
    
    func deleteItem(indexSet: IndexSet) {
        items.remove(atOffsets: indexSet)
    }
    
    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to)
    }
    
    func addItem(task: TaskItem) {
        ///let newItem = ItemModel(title: title, isCompleted: false)
        items.append(task)
        NotificationManager.shared.taskSchedule(task)
    }
    func savedEdited(task: TaskItem) {
        for (index, item) in items.enumerated() {
            if item.id == task.id {
                items[index] = task
                NotificationManager.shared.taskSchedule(task)
                break
            }
        }
        Task {
            try await Task.sleep(for: .milliseconds(300))
            await MainActor.run {
                selectedItemToEdit = nil
            }
        }
    }
    
    func updateItem(item: TaskItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item.updateCompletion()
        }
    }
    
    func saveItems() {
        if let encodedData = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encodedData, forKey: itemsKey)
        }
    }
}
