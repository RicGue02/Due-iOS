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
        for index in 0..<highlights.count {
            
            // If this is the last item, don't add a comma
            if index == highlights.count - 1 {
                allHighlights += highlights[index]
            }
            else {
                allHighlights += highlights[index] + ", "
            }
        }
    }
    
    var body: some View {
        Text(allHighlights)
            .font(Font.custom("Palentino", size: 15))
    }
}

struct ScheduleHighlights_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleHighlights(highlights: ["Probabilidades", "Swift", "POO"])
    }
}
