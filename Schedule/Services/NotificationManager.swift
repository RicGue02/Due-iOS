//
//  NotificationManager.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 10/2/21.
//

import SwiftUI


class NotificationManager {
    static let `default` = NotificationManager()
    
    //First time we initialize Notification Class (request Auth & remove delivered)
    init() {
        self.requestAuthorization()
        self.removeAllDeliveredNotifications()
    }
    
    //Request Notification Alert To User
    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
    }
    
    func subjectSchedule(_ schedule: Schedule) {
        for subjectTime in schedule.times {
            
            ///Set Notification Before 20 Mins
            let timeBefore20Mins = getNotificationDateComponents(subjectTime, expectedDate: DateComponents(minute: -20), spesificTime: false)
            self.scheduleNotification(dateComponents: timeBefore20Mins,
                                      id: "\(subjectTime.id)_20min",
                                      title: schedule.name,
                                      subtitle: "Before 20 min", repeats: true)
            
            
            ///Set Notification before 1 day at 8 PM
            var newSubjectTime = subjectTime
            var newDayIndex = newSubjectTime.day_index - 1
            if newDayIndex <= 0 { newDayIndex = 7 }
            newSubjectTime.day_index = newDayIndex
            
            let timeBefore1Day = getNotificationDateComponents(newSubjectTime, expectedDate: DateComponents(minute: 0), spesificTime: true)
            self.scheduleNotification(dateComponents: timeBefore1Day,
                                      id: "\(subjectTime.id)_1day",
                                      title: schedule.name,
                                      subtitle: "Tomorrow at \(subjectTime.time.getString())", repeats: true)
        }
    }
    
    
    
     private func getNotificationDateComponents(_ subjectTime: SubjectTime, expectedDate: DateComponents, spesificTime:Bool) -> DateComponents {
        let newDate = Calendar.current.date(byAdding: expectedDate, to: subjectTime.time)!
        
        //Notification Time
        var dateComponent = DateComponents()
        ///Get Components of subject time
        let components = Calendar.current.dateComponents([.hour, .minute], from: newDate)
        dateComponent.weekday = subjectTime.day_index
        
        if spesificTime {
            dateComponent.hour = 20
            dateComponent.minute = 00
            
            
        }else {
            dateComponent.hour = components.hour
            dateComponent.minute = components.minute
        }
        return dateComponent
    }
    
    
    //Schedule Notification
    func scheduleNotification(dateComponents:DateComponents, id: String, title: String, subtitle:String, repeats:Bool) {
        //guard let schedule = notification.match.schedule else { return }
        
        //Notification Content
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = .default
        
        
        
        //Notification Trigger
        let calendarTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
        //Notification Request
        let request = UNNotificationRequest(identifier: id,
                                            content: content,
                                            trigger: calendarTrigger)
        
        //To Avoid Add multi requests of same notification
        ///remove if already Added
        self.removeNotificationRequest(id)
        
        //Add New request after remove old if was added
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    //Remove Scheduled Notification
    func removeNotificationRequest(_ notificationID: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [
            ///Subject
            "\(notificationID)_20min",
            "\(notificationID)_1day",
            
            ///Task
            "\(notificationID)_24hour",
            "\(notificationID)_12hour",
            "\(notificationID)_6hour",
            "\(notificationID)_3hour"
        ])
    }
    
    //Remove All Scheduled Natification
    func removeAllPendingNotifications() {
        DispatchQueue.main.async {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }
    
    //Remove Delivered Notification
    private func removeAllDeliveredNotifications() {
        DispatchQueue.main.async {
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
}
