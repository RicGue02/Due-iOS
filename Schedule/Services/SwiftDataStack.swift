import SwiftUI
import SwiftData

// MARK: - SwiftData Models

@Model
final class SDSchedule {
    @Attribute(.unique) var id: UUID
    var name: String
    var teacher: String
    var classroom: String
    var icon: String
    var color: String
    var createdAt: Date
    var updatedAt: Date
    
    @Relationship(deleteRule: .cascade) var tasks: [SDTaskItem]
    @Relationship(deleteRule: .cascade) var subjectTimes: [SDSubjectTime]
    
    init(
        id: UUID = UUID(),
        name: String,
        teacher: String = "",
        classroom: String = "",
        icon: String = "book.fill",
        color: String = "blue",
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.teacher = teacher
        self.classroom = classroom
        self.icon = icon
        self.color = color
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.tasks = []
        self.subjectTimes = []
    }
}

@Model
final class SDTaskItem {
    @Attribute(.unique) var id: UUID
    var title: String
    var taskDescription: String
    var dueDate: Date
    var isCompleted: Bool
    var priority: String
    var createdAt: Date
    var updatedAt: Date
    
    var schedule: SDSchedule?
    
    init(
        id: UUID = UUID(),
        title: String,
        taskDescription: String = "",
        dueDate: Date,
        isCompleted: Bool = false,
        priority: String = "medium",
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.taskDescription = taskDescription
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.priority = priority
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

@Model
final class SDSubjectTime {
    @Attribute(.unique) var id: UUID
    var day: String
    var startTime: Date
    var endTime: Date
    var notificationId: String?
    var createdAt: Date
    var updatedAt: Date
    
    var schedule: SDSchedule?
    
    init(
        id: UUID = UUID(),
        day: String,
        startTime: Date,
        endTime: Date,
        notificationId: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.day = day
        self.startTime = startTime
        self.endTime = endTime
        self.notificationId = notificationId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

@Model
final class SDUserPreferences {
    @Attribute(.unique) var id: UUID
    var hasCompletedOnboarding: Bool
    var selectedAcademicLevel: String?
    var selectedMajor: String?
    var notificationsEnabled: Bool
    var widgetEnabled: Bool
    var lastSyncDate: Date?
    var createdAt: Date
    var updatedAt: Date
    
    init(
        id: UUID = UUID(),
        hasCompletedOnboarding: Bool = false,
        selectedAcademicLevel: String? = nil,
        selectedMajor: String? = nil,
        notificationsEnabled: Bool = true,
        widgetEnabled: Bool = false,
        lastSyncDate: Date? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.selectedAcademicLevel = selectedAcademicLevel
        self.selectedMajor = selectedMajor
        self.notificationsEnabled = notificationsEnabled
        self.widgetEnabled = widgetEnabled
        self.lastSyncDate = lastSyncDate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - SwiftData Service

@MainActor
final class SwiftDataService {
    static let shared = SwiftDataService()
    
    private var container: ModelContainer?
    private var context: ModelContext?
    
    private init() {}
    
    func setupContainer() throws {
        let schema = Schema([
            SDSchedule.self,
            SDTaskItem.self,
            SDSubjectTime.self,
            SDUserPreferences.self
        ])
        
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            allowsSave: true
        )
        
        container = try ModelContainer(
            for: schema,
            configurations: [modelConfiguration]
        )
        
        if let container = container {
            context = ModelContext(container)
        }
    }
    
    var modelContext: ModelContext {
        guard let context = context else {
            fatalError("SwiftData context not initialized. Call setupContainer() first.")
        }
        return context
    }
}

// MARK: - SwiftData ViewModel

@MainActor
@Observable
final class SwiftDataViewModel {
    private let dataService = SwiftDataService.shared
    
    init() {}
    
    func migrateFromUserDefaults() {
        // Simple migration check
        guard !UserDefaults.standard.bool(forKey: "swiftdata_migration_complete") else { return }
        
        // Migration will happen here when ready
        UserDefaults.standard.set(true, forKey: "swiftdata_migration_complete")
    }
}