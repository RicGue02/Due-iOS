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
    
    init() {
        // Create an instance of data service and get the data
        ///self.schedules = DataService.getLocalData()
        self.getSavedSchedules { list in
            DispatchQueue.main.async {
                self.schedules = list
            }
        }
    }
    
    
    func saveSchedule(_ schedule: Schedule) {
        DispatchQueue.global().async {
            self.getSavedSchedules { list in
                var newList = list
                if newList.isEmpty {
                    newList = [schedule]
                }else {
                    newList.insert(schedule, at: 0)
                }
                //Save
                do {
                    let data = try JSONEncoder().encode(newList)
                    UserDefaults.standard.setValue(data, forKey: saved_schedules_key)
                }catch {
                    print("Failed to save this schedule")
                }
                
                DispatchQueue.main.async {
                    self.schedules = newList
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
