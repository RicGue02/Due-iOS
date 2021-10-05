//
//  Schedule.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import SwiftUI
import UIKit

struct Schedule: Identifiable, Hashable, Codable {
    
    var id:String
    var name:String
    var urls:String
    var imageURL:URL?
    var description:String
    var clase:String
    var recursos:String
    var chat:String
    var highlights: [String]
    var times = [SubjectTime]()
    var moreinfo: [String]
    
    var featured:Bool? {
        for time in times {
            if time.day_index == getTodayIndex() {
                return true
            }
        }
        return false
    }
    
    
    func getImage(width: CGFloat) -> UIImage {
        return DataService.getImageFromDocumentDirectory(by: self.imageURL)
        
        /**
         if let imageData = self.image?.photo {
         if let uiImage = UIImage(data: imageData) {
         let resizedImage = self.resizeImage(image: uiImage, newWidth: width)
         return resizedImage ?? UIImage()
         }
         }
         return UIImage()
         */
        
    }
    
    private func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

/**
 public struct CodableImage: Codable {
 public let photo: Data?
 public init(photo: UIImage) {
 self.photo = photo.pngData()
 }
 }*/

struct Links: Identifiable, Hashable, Codable {
    var id:UUID?
    var name:String
    var num:Int?
}

struct SubjectTime: Hashable, Codable {
    var id:String ///this will be notification ID
    var day_index:Int
    var time:Date
}

enum WeekDays: String, CaseIterable {
    case Monday
    case Tuesday
    case Wendnesday
    case Thrusday
    case Friday
    case Saturday
    case Sunday
    
    
    var index:Int {
        switch self {
        case .Sunday: return 1
        case .Monday: return 2
        case .Tuesday: return 3
        case .Wendnesday: return 4
        case .Thrusday: return 5
        case .Friday: return 6
        case .Saturday: return 7
        }
    }
}

extension Int {
    var dayName: String {
        switch self {
        case 1: return "Sunday"
        case 2: return "Monday"
        case 3: return "Tuesday"
        case 4: return "Wendnesday"
        case 5: return "Thrusday"
        case 6: return "Friday"
        case 7: return "Saturday"
        default: return "NONE"
            
        }
    }
}

func getTodayIndex() -> Int {

//    var calender = Calendar.current
//    calender.firstWeekday = 1
//    let components = calender.dateComponents([.weekday, .weekdayOrdinal, .weekOfMonth, .weekOfYear, .day, .hour, .minute], from: Date())
//    let todayDate = calender.date(from: components)
//
    
//    let prefLanguage = Locale.preferredLanguages[0]
//            var calendar = Calendar(identifier: .gregorian)
//            calendar.locale = NSLocale(localeIdentifier: prefLanguage) as Locale
    
    
    
    let formatter: DateFormatter = DateFormatter()
    formatter.dateFormat = "e"
    var day_index:Int = Int(formatter.string(from: Date()))!
    
    let currentCalendarStartDay = Calendar.current.firstWeekday
    
    if currentCalendarStartDay == 2 { //Monday
        day_index = day_index + 1
        if day_index >= 8 {
            day_index = 1
        }
    }
    return day_index
}
