//
//  TaskNotificationManager.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 10/3/21.
//

import SwiftUI

extension NotificationManager {
    
    nonisolated func taskSchedule(_ task: TaskItem) {
        let timeBefore24Hours = getNotificationDateComponents(task.due, expectedDate: DateComponents(hour: -24))
        let timeBefore12Hours = getNotificationDateComponents(task.due, expectedDate: DateComponents(hour: -12))
        let timeBefore6Hours = getNotificationDateComponents(task.due, expectedDate: DateComponents(hour: -6))
        let timeBefore3Hours = getNotificationDateComponents(task.due, expectedDate: DateComponents(hour: -3))
        
        self.scheduleNotification(dateComponents: timeBefore24Hours, id: "\(task.id)_24hour",
                                  title: "Reminder", subtitle: "You have 24 hours to complete '\(task.title)'", repeats: false)
        self.scheduleNotification(dateComponents: timeBefore12Hours, id: "\(task.id)_12hour",
                                  title: "Reminder", subtitle: "You have 12 hours to complete '\(task.title)'", repeats: false)
        self.scheduleNotification(dateComponents: timeBefore6Hours, id: "\(task.id)_6hour",
                                  title: "Reminder", subtitle: "You have 6 hours to complete '\(task.title)'", repeats: false)
        self.scheduleNotification(dateComponents: timeBefore3Hours, id: "\(task.id)_3hour",
                                  title: "Reminder", subtitle: "You have 3 hours to complete '\(task.title)'", repeats: false)
        
        
    }
    
    
    
    nonisolated private func getNotificationDateComponents(_ date: Date, expectedDate: DateComponents) -> DateComponents {
        let newDate = Calendar.current.date(byAdding: expectedDate, to: date)!
        
        //Notification Time
        var dateComponent = DateComponents()
        ///Get Components of subject time
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: newDate)
        
        dateComponent.year = components.year
        dateComponent.month = components.month
        dateComponent.day = components.day
        dateComponent.hour = components.hour
        dateComponent.minute = components.minute
        dateComponent.second = components.second
        
        return dateComponent
    }
    
}
