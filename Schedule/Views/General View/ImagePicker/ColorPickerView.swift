//
//  ColorPickerView.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 29/9/21.
//

import UIKit
import SwiftUI

// Function can be use to determinate subjects in the to do list
// As well as a new atributte in addScheduleView

struct ColorPickerView: View {
    @State var pickedColor : Color = .black
    
    var body: some View {
        
        ColorPicker("Pick Color", selection: $pickedColor, supportsOpacity: true)
            .padding()
        
    }
}

struct ColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView()
    }
}
