//
//  ListRowView.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import SwiftUI

struct ListRowView: View {
    
    var item: TaskItem
    var completedBtn:()->()
    var editBtn:()->()
    
    var body: some View {
        
        HStack(alignment: .top) {
            Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                .foregroundColor(item.isCompleted ? .green : .red)
                .onTapGesture {completedBtn()}
            
            VStack {
                Text(item.title)
                    //.palatinoFont(20, weight: .bold)
                    .font(.system(size: 16,weight: .regular))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 4) {
                    Text("Due:")
                        //.palatinoFont(12, weight: .bold)
                        .font(.system(size: 12,weight: .thin))
                    Text("\(item.due.getFullDateString())")
                        //.palatinoFont(11, weight: .regular)
                        .font(.system(size: 10,weight: .thin))

                    Spacer()
                }
                .padding(.leading, 10)
                
                HStack(spacing: 4) {
                    Text("Remaninig:")
                        //.palatinoFont(12, weight: .bold)
                        .font(.system(size: 12,weight: .thin))

                    Text("\(item.remaining ?? "")")
                        //.palatinoFont(11, weight: .regular)
                        .font(.system(size: 10,weight: .thin))
                    Spacer()
                }
                .padding(.leading, 10)
            }
            
            Spacer()
            
            VStack {
                if let uiimage = item.subject?.getImage(width: 100) {
                    Image(uiImage: uiimage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                
                Text(item.subject?.name ?? "")
                    //.palatinoFont(12, weight: .regular)
                    .font(.system(size: 10,weight: .thin))
                    .multilineTextAlignment(.center)
                    .frame(width: 60)

            }
            
        }
        .font(.title2)
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture {editBtn()}
    }
}

