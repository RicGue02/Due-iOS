//
//  Schedule.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import Foundation

class Schedule: Identifiable, Decodable {
    
    var id:UUID?
    var name:String
    var featured:Bool
    var urls:String
    var image:String
    var description:String
    var clase:String
    var recursos:String
    var chat:String
    var highlights:[String]
    var link:[String]
    var moreinfo:[String]
    
   
}

class Links: Identifiable, Decodable {

    var id:UUID?
    var name:String
    var num:Int?
}

