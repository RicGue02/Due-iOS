//
//  ScheduleModel.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import Foundation

class ScheduleModel: ObservableObject {
    
    @Published var schedules = [Schedule]()
    
    init() {
        
        // Create an instance of data service and get the data
        self.schedules = DataService.getLocalData()
    }
}
