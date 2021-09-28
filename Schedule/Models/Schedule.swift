//
//  Schedule.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import SwiftUI
import UIKit

struct Schedule: Identifiable, Codable {
    
    var id:UUID? { return UUID() }
    var name:String
    var urls:String
    var imageURL:URL?
    var description:String
    var clase:String
    var recursos:String
    var chat:String
    var highlights: [String]
    var dates = [Date]()
    var moreinfo: [String]
    
    var featured:Bool? {
        for date in dates {
            if Calendar.current.isDateInToday(date) {
                return true
            }
        }
        return false
    }
    
    
    func getImage(width: CGFloat) -> UIImage {
        return DataService.getImageFromDocumentDirectory(by: self.imageURL)
        
//        if let imageData = self.image?.photo {
//            if let uiImage = UIImage(data: imageData) {
//                let resizedImage = self.resizeImage(image: uiImage, newWidth: width)
//                return resizedImage ?? UIImage()
//            }
//        }
        //return UIImage()
        
    }
    
    
    
    private func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}

//public struct CodableImage: Codable {
//    public let photo: Data?
//    public init(photo: UIImage) {
//        self.photo = photo.pngData()
//    }
//}

struct Links: Identifiable, Decodable {
    var id:UUID?
    var name:String
    var num:Int?
}

