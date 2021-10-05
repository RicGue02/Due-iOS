//
//  ItemModel.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import Foundation

// Immutable Struct has only 'let' constants
struct TaskItem: Identifiable, Codable {
    
    let id: String
    let title: String
    let due:Date
    let subject: Schedule?
    var isCompleted: Bool
    
    
    func updateCompletion() -> TaskItem {
        var newModel = self
        newModel.isCompleted = !isCompleted
        return newModel
        ///return ItemModel(id: id, title: title, due: due, subject: subject, isCompleted: !isCompleted)
    }
    
    var remaining:String? {
        var remainingTimeString = ""
        let diffs = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date(), to: due)
        
        if (diffs.year ?? 0) > 0 {
            remainingTimeString = "\(diffs.year!) Years"
        }else if (diffs.month ?? 0) > 0 {
            remainingTimeString = "\(diffs.month!) Months, \(diffs.day ?? 0) Days"
        }else if (diffs.day ?? 0) > 0 {
            remainingTimeString = "\(diffs.day!) Days, \(diffs.hour ?? 0) Hours"
        }else if (diffs.hour ?? 0) > 0 {
            remainingTimeString = "\(diffs.hour!) Hours, \(diffs.minute ?? 0) Minutes"
        }else {
            if diffs.minute ?? 0 <= 0 && diffs.second ?? 0 <= 0 {
                remainingTimeString = "Due time passed!"
            }else {
                remainingTimeString = "\(diffs.minute ?? 0) Minutes, \(diffs.second ?? 0) Seconds"
            }
            
        }
        
        
        return remainingTimeString
    }
}

