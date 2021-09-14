//
//  ScheduleTodoList.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 9/9/21.
//

import Foundation

struct ToDo: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var completed: Bool = false
    
}
