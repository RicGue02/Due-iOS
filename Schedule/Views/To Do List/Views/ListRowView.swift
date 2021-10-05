//
//  ListRowView.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import SwiftUI

struct ListRowView: View {
    let item: TaskItem
    var completedBtn:()->()
    var editBtn:()->()
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                .foregroundColor(item.isCompleted ? .green : .red)
                .onTapGesture {
                    completedBtn()
                }
            
            VStack {
                Text(item.title)
                    .palatinoFont(20, weight: .bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 4) {
                    Text("DUE:")
                        .palatinoFont(12, weight: .bold)
                    Text("\(item.due.getFullDateString())")
                        .palatinoFont(11, weight: .regular)
                    Spacer()
                }
                .padding(.leading, 20)
                HStack(spacing: 4) {
                    Text("REMAINING:")
                        .palatinoFont(12, weight: .bold)
                    Text("\(item.remaining ?? "")")
                        .palatinoFont(11, weight: .regular)
                    Spacer()
                }
                .padding(.leading, 20)
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
                    .palatinoFont(12, weight: .regular)
            }

        }
        .font(.title2)
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .onTapGesture {
            editBtn()
        }
    }
}

//struct ListRowView_Previews: PreviewProvider {
//    
//    static var item1 = ItemModel(title: "Homework.", isCompleted: false)
//    static var item2 = ItemModel(title: "Project.", isCompleted: true)
//    
//    static var previews: some View {
//        Group {
//            ListRowView(item: item1)
//            ListRowView(item: item2)
//        }
//        .previewLayout(.sizeThatFits)
//        
//    }
//}
