//
//  OnboardingModels.swift
//  Schedule
//
//  Created for Due Student App
//

import Foundation

// MARK: - Academic Types
enum AcademicLevel: String, CaseIterable {
    case highSchool = "High School"
    case university = "University"
    case tradeSchool = "Trade School"
    case language = "Language Course"
    case certification = "Certification"
    
    var icon: String {
        switch self {
        case .highSchool: return "graduationcap"
        case .university: return "building.columns"
        case .tradeSchool: return "hammer"
        case .language: return "globe"
        case .certification: return "checkmark.seal"
        }
    }
    
    var description: String {
        switch self {
        case .highSchool: return "Regular high school classes"
        case .university: return "College or university courses"
        case .tradeSchool: return "Technical or vocational training"
        case .language: return "Language learning classes"
        case .certification: return "Professional certification prep"
        }
    }
    
    var defaultSubjectCount: Int {
        switch self {
        case .highSchool: return 8
        case .university: return 5
        case .tradeSchool: return 4
        case .language: return 2
        case .certification: return 3
        }
    }
}

// MARK: - Academic Templates
struct AcademicTemplate {
    let id = UUID()
    let name: String
    let level: AcademicLevel
    let subjectCount: Int
    let timeSlots: [TimeSlot]
    let commonSubjects: [String]
    
    struct TimeSlot {
        let startTime: String
        let endTime: String
        let daysOfWeek: [Int] // 1 = Monday, 7 = Sunday
        let isPopular: Bool
    }
}

// MARK: - Pre-defined Templates
extension AcademicTemplate {
    
    static let universityTemplates: [AcademicTemplate] = [
        AcademicTemplate(
            name: "Engineering Student",
            level: .university,
            subjectCount: 6,
            timeSlots: [
                TimeSlot(startTime: "07:00", endTime: "08:30", daysOfWeek: [2, 4], isPopular: true),
                TimeSlot(startTime: "08:00", endTime: "09:30", daysOfWeek: [1, 3, 5], isPopular: true),
                TimeSlot(startTime: "10:00", endTime: "11:30", daysOfWeek: [1, 3, 5], isPopular: true),
                TimeSlot(startTime: "13:00", endTime: "16:00", daysOfWeek: [2, 4], isPopular: true)
            ],
            commonSubjects: ["Calculus", "Physics", "Programming", "Engineering Design", "Chemistry", "Statistics"]
        ),
        
        AcademicTemplate(
            name: "Business Student", 
            level: .university,
            subjectCount: 5,
            timeSlots: [
                TimeSlot(startTime: "09:00", endTime: "10:30", daysOfWeek: [1, 3, 5], isPopular: true),
                TimeSlot(startTime: "11:00", endTime: "12:30", daysOfWeek: [2, 4], isPopular: true),
                TimeSlot(startTime: "14:00", endTime: "15:30", daysOfWeek: [1, 3], isPopular: true),
                TimeSlot(startTime: "16:00", endTime: "17:30", daysOfWeek: [2, 4], isPopular: false)
            ],
            commonSubjects: ["Accounting", "Marketing", "Finance", "Management", "Economics"]
        ),
        
        AcademicTemplate(
            name: "Liberal Arts Student",
            level: .university, 
            subjectCount: 5,
            timeSlots: [
                TimeSlot(startTime: "08:00", endTime: "09:30", daysOfWeek: [1, 3, 5], isPopular: false),
                TimeSlot(startTime: "10:00", endTime: "11:30", daysOfWeek: [2, 4], isPopular: true),
                TimeSlot(startTime: "13:00", endTime: "14:30", daysOfWeek: [1, 3, 5], isPopular: true),
                TimeSlot(startTime: "15:00", endTime: "16:30", daysOfWeek: [2, 4], isPopular: true)
            ],
            commonSubjects: ["History", "Literature", "Philosophy", "Psychology", "Sociology"]
        ),
        
        AcademicTemplate(
            name: "Science Student",
            level: .university,
            subjectCount: 6,
            timeSlots: [
                TimeSlot(startTime: "07:00", endTime: "08:30", daysOfWeek: [1, 3, 5], isPopular: true),
                TimeSlot(startTime: "09:00", endTime: "12:00", daysOfWeek: [2, 4], isPopular: true), // Labs
                TimeSlot(startTime: "13:00", endTime: "14:30", daysOfWeek: [1, 3, 5], isPopular: true),
                TimeSlot(startTime: "15:00", endTime: "18:00", daysOfWeek: [2], isPopular: false) // Lab
            ],
            commonSubjects: ["Biology", "Chemistry", "Physics", "Mathematics", "Research Methods", "Statistics"]
        )
    ]
    
    static let highSchoolTemplate = AcademicTemplate(
        name: "High School Student",
        level: .highSchool,
        subjectCount: 8,
        timeSlots: [
            TimeSlot(startTime: "07:30", endTime: "08:20", daysOfWeek: [1, 2, 3, 4, 5], isPopular: true),
            TimeSlot(startTime: "08:25", endTime: "09:15", daysOfWeek: [1, 2, 3, 4, 5], isPopular: true),
            TimeSlot(startTime: "09:20", endTime: "10:10", daysOfWeek: [1, 2, 3, 4, 5], isPopular: true),
            TimeSlot(startTime: "10:15", endTime: "11:05", daysOfWeek: [1, 2, 3, 4, 5], isPopular: true),
            TimeSlot(startTime: "11:35", endTime: "12:25", daysOfWeek: [1, 2, 3, 4, 5], isPopular: true),
            TimeSlot(startTime: "12:30", endTime: "13:20", daysOfWeek: [1, 2, 3, 4, 5], isPopular: true),
            TimeSlot(startTime: "13:25", endTime: "14:15", daysOfWeek: [1, 2, 3, 4, 5], isPopular: true),
            TimeSlot(startTime: "14:20", endTime: "15:10", daysOfWeek: [1, 2, 3, 4, 5], isPopular: true)
        ],
        commonSubjects: ["Mathematics", "English", "Science", "History", "Spanish", "Physical Education", "Art", "Elective"]
    )
    
    static let tradeSchoolTemplate = AcademicTemplate(
        name: "Trade School Student",
        level: .tradeSchool,
        subjectCount: 4,
        timeSlots: [
            TimeSlot(startTime: "08:00", endTime: "12:00", daysOfWeek: [1, 3, 5], isPopular: true),
            TimeSlot(startTime: "13:00", endTime: "17:00", daysOfWeek: [2, 4], isPopular: true)
        ],
        commonSubjects: ["Technical Skills", "Safety Training", "Theory", "Practical Application"]
    )
    
    static func getTemplates(for level: AcademicLevel) -> [AcademicTemplate] {
        switch level {
        case .university:
            return universityTemplates
        case .highSchool:
            return [highSchoolTemplate]
        case .tradeSchool:
            return [tradeSchoolTemplate]
        case .language:
            return [languageTemplate]
        case .certification:
            return [certificationTemplate]
        }
    }
    
    private static let languageTemplate = AcademicTemplate(
        name: "Language Course",
        level: .language,
        subjectCount: 2,
        timeSlots: [
            TimeSlot(startTime: "18:00", endTime: "20:00", daysOfWeek: [2, 4], isPopular: true),
            TimeSlot(startTime: "09:00", endTime: "11:00", daysOfWeek: [6], isPopular: true)
        ],
        commonSubjects: ["Grammar & Vocabulary", "Conversation Practice"]
    )
    
    private static let certificationTemplate = AcademicTemplate(
        name: "Certification Prep",
        level: .certification,
        subjectCount: 3,
        timeSlots: [
            TimeSlot(startTime: "19:00", endTime: "21:00", daysOfWeek: [1, 3], isPopular: true),
            TimeSlot(startTime: "09:00", endTime: "12:00", daysOfWeek: [6], isPopular: true)
        ],
        commonSubjects: ["Study Materials", "Practice Tests", "Review Sessions"]
    )
}

// MARK: - Onboarding State
@Observable
class OnboardingState {
    var currentStep: OnboardingStep = .welcome
    var selectedLevel: AcademicLevel?
    var selectedTemplate: AcademicTemplate?
    var subjectCount: Int = 5
    var studentName: String = ""
    var institution: String = ""
    var isCompleted: Bool = false
    
    enum OnboardingStep: Int, CaseIterable {
        case welcome = 0
        case academicLevel = 1
        case template = 2
        case subjectCount = 3
        case quickSetup = 4
        case completed = 5
        
        var title: String {
            switch self {
            case .welcome: return "Welcome to Due!"
            case .academicLevel: return "What are you studying?"
            case .template: return "Choose your style"
            case .subjectCount: return "How many subjects?"
            case .quickSetup: return "Add your first class"
            case .completed: return "You're all set!"
            }
        }
        
        var subtitle: String {
            switch self {
            case .welcome: return "The only app you need to succeed academically"
            case .academicLevel: return "This helps us customize Due for you"
            case .template: return "Pick what matches your schedule best"
            case .subjectCount: return "We'll help you organize them all"
            case .quickSetup: return "Let's add your next class"
            case .completed: return "Due is ready to help you stay organized"
            }
        }
    }
    
    func nextStep() {
        if currentStep.rawValue < OnboardingStep.allCases.count - 1 {
            currentStep = OnboardingStep(rawValue: currentStep.rawValue + 1) ?? .completed
        }
    }
    
    func previousStep() {
        if currentStep.rawValue > 0 {
            currentStep = OnboardingStep(rawValue: currentStep.rawValue - 1) ?? .welcome
        }
    }
    
    var progress: Double {
        return Double(currentStep.rawValue) / Double(OnboardingStep.allCases.count - 1)
    }
    
    var canProceed: Bool {
        switch currentStep {
        case .welcome: return true
        case .academicLevel: return selectedLevel != nil
        case .template: return selectedTemplate != nil
        case .subjectCount: return subjectCount > 0
        case .quickSetup: return true
        case .completed: return true
        }
    }
}