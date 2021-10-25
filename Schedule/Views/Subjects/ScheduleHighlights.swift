//
//  ScheduleHighlights.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import SwiftUI

struct ScheduleHighlights: View {
    
    var allHighlights = ""
    
    init(highlights:[String]) {
        
        // Loop through the highlights and build the string
        for item in highlights {
            // If this is the last item, don't add a comma
            if item == highlights.last{
                allHighlights += item
            }
            else {
                allHighlights += item + ", "
            }
        }
    }
    
    var body: some View {
        Text(allHighlights)
            //.palatinoFont(15, weight: .regular)
            .font(.system(size: 15,weight: .regular))
    }
}

