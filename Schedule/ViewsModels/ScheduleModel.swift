//
//  ScheduleModel.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import Foundation
import Observation

private let saved_schedules_key = "saved_schedules_key"

@MainActor
@Observable 
class ScheduleModel {
    
    var schedules = [Schedule]()
    var selectedSchedule: Schedule?
    var featuredSchedules = [Schedule]()
    
    
    init() {
        Task {
            await loadSavedSchedules()
        }
    }
    
    private func updateUI(_ list: [Schedule]) {
        self.schedules = list
        
        self.featuredSchedules.removeAll()
        for item in list {
            if (item.featured ?? false) {
                self.featuredSchedules.append(item)
            }
        }
    }
    
    private func loadSavedSchedules() async {
        let list = await getSavedSchedules()
        updateUI(list)
    }
    
    
    func updateSchedules(_ schedule: Schedule, isEditMode: Bool = false, removeIt: Bool = false) {
        Task {
            do {
                let list = await getSavedSchedules()
                var newList = list
                
                if newList.isEmpty {
                    newList = [schedule]
                    NotificationManager.shared.subjectSchedule(schedule)
                } else {
                    if removeIt {
                        newList.removeAll(where: { $0.id == schedule.id })
                        for item in schedule.times {
                            NotificationManager.shared.removeNotificationRequest(item.id)
                        }
                    } else if isEditMode {
                        // Update Current Item
                        for (index, item) in newList.enumerated() {
                            if item.id == schedule.id {
                                newList[index] = schedule
                                NotificationManager.shared.subjectSchedule(schedule)
                                break
                            }
                        }
                    } else {
                        // Insert New Item
                        newList.insert(schedule, at: 0)
                        NotificationManager.shared.subjectSchedule(schedule)
                    }
                }
                
                // Save
                let data = try JSONEncoder().encode(newList)
                UserDefaults.standard.setValue(data, forKey: saved_schedules_key)
                await MainActor.run {
                    updateUI(newList)
                }
            } catch {
                print("Failed to save this schedule: \(error)")
                // TODO: Integrate with proper error handling UI
            }
        }
    }
    
    func getSavedSchedules() async -> [Schedule] {
        guard let data = UserDefaults.standard.data(forKey: saved_schedules_key) else {
            return []
        }
        
        do {
            let list = try JSONDecoder().decode([Schedule].self, from: data)
            return list
        } catch {
            print("Failed to get saved schedules: \(error.localizedDescription)")
            return []
        }
    }
}
