//
//  DataService.swift
//  Schedule
//
//  Created by Ricardo Guerrero Godínez on 8/9/21.
//

import SwiftUI
import UIKit

class DataService {
    
    static func getLocalData() -> [Schedule] {
        
        // Parse local json file
        
        // Get a url path to the json file
        let pathString = Bundle.main.path(forResource: "schedule", ofType: "json")
        
        // Check if pathString is not nil, otherwise...
        guard pathString != nil else {
            return [Schedule]()
        }
        
        // Create a url object
        let url = URL(fileURLWithPath: pathString!)
        
        do {
            // Create a data object
            let data = try Data(contentsOf: url)
            
            // Decode the data with a JSON decoder
            let decoder = JSONDecoder()
            
            do {
                
                let scheduleData = try decoder.decode([Schedule].self, from: data)
                
                // Add the unique IDs
//                for r in scheduleData {
//                    r.id = UUID()
//                    
//                }
                
                // Return the recipes
                return scheduleData
            }
            catch {
                // error with parsing json
                print(error)
            }
        }
        catch {
            // error with getting data
            print(error)
        }
        
        return [Schedule]()
    }
    
    
    static func getImageFromDocumentDirectory(by url: URL?) -> UIImage {
        guard let url = url else { return UIImage() }
        do {
            let imageData = try Data(contentsOf: url)
            let image = UIImage(data: imageData)
            return image ?? UIImage()
            
        } catch {
            print("Failed to get this image: \(error.localizedDescription)")
        }
        
        return UIImage()
    }
    static func getImageUrlFromDocumentDirectory(image: UIImage?) -> URL? {
        
        /// Convert to Data
        if let data = image?.pngData() {
            /// Create URL
            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let url = documents.appendingPathComponent("\(UUID().uuidString).png")
            do {
                /// Write to Disk
                try data.write(to: url)
                return url
                /// Store URL in User Defaults
                ///UserDefaults.standard.set(url, forKey: "background")
                
            } catch {
                print("Unable to Write Data to Disk (\(error))")
            }
            
        }
        
        return nil
    }
}

extension Date {
    func getString() -> String {
        let date = self
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
