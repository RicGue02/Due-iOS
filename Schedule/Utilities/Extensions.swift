//
//  Extensions.swift
//  Schedule
//
//  Created by My Mac on 10/3/21.
//

import SwiftUI

enum DueError: LocalizedError {
    case dataLoadFailed(String)
    case dataSaveFailed(String)
    case imageLoadFailed(String)
    case imageSaveFailed(String)
    case notificationPermissionDenied
    case invalidScheduleData
    case invalidTaskData
    
    var errorDescription: String? {
        switch self {
        case .dataLoadFailed(let detail):
            return "Failed to load data: \(detail)"
        case .dataSaveFailed(let detail):
            return "Failed to save data: \(detail)"
        case .imageLoadFailed(let detail):
            return "Failed to load image: \(detail)"
        case .imageSaveFailed(let detail):
            return "Failed to save image: \(detail)"
        case .notificationPermissionDenied:
            return "Notification permission required for reminders"
        case .invalidScheduleData:
            return "Invalid schedule data format"
        case .invalidTaskData:
            return "Invalid task data format"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .dataLoadFailed, .dataSaveFailed:
            return "Please try again or restart the app"
        case .imageLoadFailed, .imageSaveFailed:
            return "Please select a different image"
        case .notificationPermissionDenied:
            return "Enable notifications in Settings to receive reminders"
        case .invalidScheduleData, .invalidTaskData:
            return "Please check your data and try again"
        }
    }
}

extension View {
    func palatinoFont(_ size:CGFloat, weight: FontWeight) -> some View {
        return self
            .font(PALATINO_FONT(size, weight: weight))
            .lineSpacing(0)
    }
}

private func PALATINO_FONT(_ size:CGFloat, weight: FontWeight) -> Font {
    let weight = weight == .bold ? "-Bold" : ""
    return Font.custom("Palatino\(weight)", size: size)
}

enum FontWeight {
    case regular, bold
}
