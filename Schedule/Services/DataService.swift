//
//  DataService.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import SwiftUI
import UIKit

class DataService {
    
    static func getLocalData() throws -> [Schedule] {
        // Get a url path to the json file
        guard let pathString = Bundle.main.path(forResource: "schedule", ofType: "json") else {
            throw DueError.dataLoadFailed("Schedule.json file not found in bundle")
        }
        
        // Create a url object
        let url = URL(fileURLWithPath: pathString)
        
        do {
            // Create a data object
            let data = try Data(contentsOf: url)
            
            // Decode the data with a JSON decoder
            let decoder = JSONDecoder()
            let scheduleData = try decoder.decode([Schedule].self, from: data)
            
            return scheduleData
        } catch {
            throw DueError.dataLoadFailed("Failed to parse schedule data: \(error.localizedDescription)")
        }
    }
    
    
    static func getImageFromDocumentDirectory(by url: URL?) throws -> UIImage {
        guard let url = url else {
            throw DueError.imageLoadFailed("No image URL provided")
        }
        
        do {
            let imageData = try Data(contentsOf: url)
            guard let image = UIImage(data: imageData) else {
                throw DueError.imageLoadFailed("Invalid image data")
            }
            return image
        } catch {
            throw DueError.imageLoadFailed("Failed to load image: \(error.localizedDescription)")
        }
    }
    static func getImageUrlFromDocumentDirectory(image: UIImage?) throws -> URL {
        guard let image = image,
              let data = image.pngData() else {
            throw DueError.imageSaveFailed("Unable to convert image to data")
        }
        
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = documents.appendingPathComponent("\(UUID().uuidString).png")
        
        do {
            try data.write(to: url)
            return url
        } catch {
            throw DueError.imageSaveFailed("Unable to write image to disk: \(error.localizedDescription)")
        }
    }
}

extension Date {
    func getString() -> String {
        let date = self
        let formatter = DateFormatter()
        ///formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func getFullDateString() -> String {
        let date = self
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
