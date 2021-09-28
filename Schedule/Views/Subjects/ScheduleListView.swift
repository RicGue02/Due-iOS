//
//  ScheduleListView.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import SwiftUI
import UIKit

struct ScheduleListView: View {
    
    @EnvironmentObject var model:ScheduleModel
    @State var addSchedule = false
    @State var showImages = false
    
    var body: some View {
        
        NavigationView {
            
            VStack (alignment: .leading) {
                
                HStack(spacing: 15) {
                    Button(action: {
                        // Implementar la función de meter materias
                        self.addSchedule = true
                    }, label: {
                        Image(systemName: "plus.circle")
                            .padding(.top, 40)
                    })
                    
                    Text("All Subjects")
                        .bold()
                        .padding(.top, 40)
                        .font(Font.custom("Palentino", size: 24))
                }
                
//                Divider()
                
                ScrollView {
                    VStack {
                        ForEach(model.schedules) { item in
                            NavigationLink(
                                destination: ScheduleDetailView(schedule: item),
                                label: {
                                    
                                    // MARK: Row item
                                    HStack(spacing: 20.0) {
                                        if showImages {
                                            Image(uiImage: item.getImage(width: 100))
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 50, height: 50, alignment: .center)
                                                .clipped()
                                                .cornerRadius(5)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                                )
                                        }else {
                                            Spacer()
                                                .frame(width: 50, height: 50, alignment: .center)
                                                .cornerRadius(5)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 4)
                                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                                )
                                        }
                                        
                                        VStack (alignment: .leading) {
                                            Text(item.name)
                                                .foregroundColor(.black)
                                                .font(Font.custom("Palentino", size: 16))
                                            
                                            ScheduleHighlights(highlights: item.highlights)
                                                .foregroundColor(.black)
                                            
                                        }
                                        Spacer()
                                    }
                                })
                                .padding(.bottom, 10)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .navigationBarHidden(true)
            .padding(.leading)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    self.showImages = true
                }
            }
            .sheet(isPresented: $addSchedule) {
                AddScheduleView()
                    .environmentObject(model)
            }
        }
    }
}

struct ScheduleListView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleListView()
            .environmentObject(ScheduleModel())
    }
}
