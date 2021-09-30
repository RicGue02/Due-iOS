//
//  AddScheduleView.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 9/20/21.
//

import SwiftUI


private let holderWidth:CGFloat = 80
struct AddScheduleView: View {
    init() { UITextView.appearance().backgroundColor = .clear}
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var scheduleModel: ScheduleModel
    
    @State private var nameText = ""
    @State private var descriptionText = ""
    @State private var highlightsText = ""
    @State private var claseText = ""
    @State private var courseText = ""
    @State private var recursosText = ""
    @State private var chatText = ""
    @State private var moreInfoText = ""
    @State private var date = Date()
    @State private var datesArray = [Date]()
    
    @State private var isShowPhotoLibrary = false
    @State private var image:UIImage? = nil
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    
                    //Image
                    VStack {
                        Image(uiImage: self.image ?? UIImage())
                            .resizable()
                            .scaledToFill()
                            .frame(width: 140, height: 140)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                            .overlay(
                                ZStack {
                                    if self.image == nil {
                                        Image(systemName: "plus.circle")
                                            .font(.title)
                                    }
                                }
                            )
                            .onTapGesture {
                                self.isShowPhotoLibrary = true
                            }
                        Text("Add image")
                            .foregroundColor(.blue)
                            .font(Font.custom("Palentino", size: 12))
                            .onTapGesture {self.isShowPhotoLibrary = true}
                    }
                    
                    ///Name
                    inputItem(textBinding: $nameText, title: "Name")
                    //Input Items
                    MainView(nameText: $nameText,
                             descriptionText: $descriptionText,
                             highlightsText: $highlightsText,
                             claseText: $claseText,
                             courseText: $courseText,
                             recursosText: $recursosText,
                             chatText: $chatText,
                             moreInfoText: $moreInfoText,
                             datesArray: $datesArray)
                    
                    //Add Button
                    Button {
                        self.addSchedule()
                    } label: {
                        Text("Add")
                            .font(Font.custom("Palentino", size: 16))
                            .bold()
                            .foregroundColor(Color.white)
                            .frame(height: 44)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .clipShape(Capsule())
                            .padding(.top, 20)
                    }
                    
                }
            }
        }
        .padding()
        

//        .onChange(of: self.date, perform: { date in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                self.datesArray.append(date)
//            }
//        })
        
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        }
    }
    
    
    private func addSchedule() {
        if self.nameText != "" {
            if datesArray.isEmpty {
                self.datesArray = [Date()]
            }
            
            let schedule = Schedule(name: nameText,
                                    urls: courseText,
                                    imageURL: DataService.getImageUrlFromDocumentDirectory(image: self.image),
                                    description: descriptionText,
                                    clase: claseText,
                                    recursos: recursosText,
                                    chat: chatText,
                                    highlights: [highlightsText],
                                    dates: datesArray,
                                    moreinfo: [moreInfoText])
            
            self.scheduleModel.saveSchedule(schedule)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

private struct MainView:View {
    @Binding var nameText:String
    @Binding var descriptionText:String
    @Binding var highlightsText:String
    @Binding var claseText:String
    @Binding var courseText:String
    @Binding var recursosText:String
    @Binding var chatText:String
    @Binding var moreInfoText:String
    @Binding var datesArray: [Date]
    @State private var date = Date()
    
    var body: some View {
        VStack(spacing: 16) {
            ///Description
            HStack(alignment: .top) {
                Text("Description:    ")
                    .font(.caption)
                    .multilineTextAlignment(.leading)
                    .frame(width: holderWidth)
                    
                
                TextEditor(text: $descriptionText)
                    .frame(height: 50)
                    .padding(6)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .font(Font.custom("Palentino", size: 14))
            }
            
            ///Highlights
            inputItem(textBinding: $highlightsText, title: "Highlights")
            ///Dates
            HStack (spacing:26) {
                DatePicker("Date:", selection: $date)
                    .font(.caption)
                    .font(Font.custom("Palentino", size: 14))
                Button {
                    if !datesArray.contains(date) {
                        self.datesArray.append(date)
                    }
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.title2)
                }
            }
            .frame(alignment: .leading)
            

            SelectedDates(dateArray: $datesArray)
            ///**** **** ***** ***** ***** ***** *****
            Divider()
            ///Clase
            inputItem(textBinding: $claseText, title: "Zoom link")
            ///Course Link
            inputItem(textBinding: $courseText, title: "Platform link")
            ///Recursos Link
            inputItem(textBinding: $recursosText, title: "Resources")
            ///Chat link
            inputItem(textBinding: $chatText, title: "Chat")
            ///More info text
            inputItem(textBinding: $moreInfoText, title: "More Info")
            
        }
        .font(Font.custom("Palentino", size: 14))
    }
}

struct SelectedDates: View {
    @Binding var dateArray:[Date]
    var body: some View {
        VStack {
            ForEach(dateArray, id:\.self) { date in
                Text(date.getString())
                    .font(Font.custom("Palentino", size: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .font(Font.custom("Palentino", size: 14))
    }
}

private struct inputItem: View {
    
    @Binding var textBinding:String
    var title:String
    
    var body: some View {
        HStack {
            Text("\(title): ")
                .font(.caption)
                .frame(width: holderWidth, alignment: .leading)
            
            TextField("\(title)...", text: $textBinding)
                .padding(6)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .font(Font.custom("Palentino", size: 14))
    }
    
}


struct AddScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        AddScheduleView()
    }
}
