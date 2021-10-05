//
//  ScheduleModel.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import Foundation

private let saved_schedules_key = "saved_schedules_key"
class ScheduleModel: ObservableObject {
    
    @Published var schedules = [Schedule]()
    @Published var selectedSchedule:Schedule?
    @Published var featuredSchedules = [Schedule]()
    
    
    init() {
        // Create an instance of data service and get the data
        ///self.schedules = DataService.getLocalData()
        self.getSavedSchedules { list in
            self.updateUI(list)
        }
    }
    
    private func updateUI(_ list: [Schedule]) {
        DispatchQueue.main.async {
            self.schedules = list
            
            self.featuredSchedules.removeAll()
            for item in list {
                if (item.featured ?? false) {
                    self.featuredSchedules.append(item)
                }
            }
        }
    }
    
    
    func updateSchedules(_ schedule: Schedule, isEditMode: Bool = false, removeIt:Bool = false) {
        DispatchQueue.global().async {
            self.getSavedSchedules { list in
                
                var newList = list
                if newList.isEmpty {
                    newList = [schedule]
                    NotificationManager.default.subjectSchedule(schedule)
                }else {
                    
                    if removeIt {
                        newList.removeAll(where: {$0.id == schedule.id})
                        for item in schedule.times {
                            NotificationManager.default.removeNotificationRequest(item.id)
                        }
                        
                    }else if isEditMode {
                        //Update Current Item
                        for (index, item) in newList.enumerated() {
                            if item.id == schedule.id {
                                newList[index] = schedule
                                NotificationManager.default.subjectSchedule(schedule)
                                break
                            }
                        }
                        
                    }else {
                        //Insert New Item
                        newList.insert(schedule, at: 0)
                        NotificationManager.default.subjectSchedule(schedule)
                    }
                }
                
                
                //Save
                do {
                    let data = try JSONEncoder().encode(newList)
                    UserDefaults.standard.setValue(data, forKey: saved_schedules_key)
                    self.updateUI(newList)
                }catch {
                    print("Failed to save this schedule")
                }
                
                
            }
        }
    }
    
    func getSavedSchedules(completion:@escaping (_ list: [Schedule])->()) {
        DispatchQueue.global().async {
            guard let data = UserDefaults.standard.data(forKey: saved_schedules_key) else {
                completion([])
                return
            }
            
            do {
                let list = try JSONDecoder().decode([Schedule].self, from: data)
                completion(list)
                
            }catch {
                completion([])
                print("Failed to get saved schedules: \(error.localizedDescription)")
            }
        }
    }
}
