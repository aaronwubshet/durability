import Foundation

// MARK: - User Profile Models

struct UserProfile: Codable, Identifiable {
    let id: UUID
    var email: String
    var firstName: String
    var lastName: String
    var profileImageURL: String?
    
    // Biometrics
    var height: Double? // in cm
    var weight: Double? // in kg
    var age: Int?
    var sex: Sex?
    
    // Injury History
    var injuries: [Injury]
    
    // Training History
    var trainingHistory: TrainingHistory
    
    // Goals
    var goals: [Goal]
    
    // Current State
    var currentTrainingRegimen: TrainingRegimen?
    var currentInjuryStatus: InjuryStatus?
    var currentCompetition: Competition?
    
    // Qualitative State
    var qualitativeState: QualitativeState
    
    // Assessment Results
    var assessmentResults: [AssessmentResult]
    
    // Super Metrics
    var superMetrics: SuperMetricScores?
    
    // Durability Score
    var durabilityScore: Double?
    
    // Created/Updated
    var createdAt: Date
    var updatedAt: Date
    
    init(email: String, firstName: String, lastName: String) {
        self.id = UUID()
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.injuries = []
        self.trainingHistory = TrainingHistory()
        self.goals = []
        self.qualitativeState = QualitativeState()
        self.assessmentResults = []
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

enum Sex: String, CaseIterable, Codable {
    case male = "male"
    case female = "female"
    case other = "other"
    case preferNotToSay = "prefer_not_to_say"
}

struct Injury: Codable, Identifiable {
    let id: UUID
    var type: String
    var severity: InjurySeverity
    var recoveryStatus: RecoveryStatus
    var year: Int
    var description: String?
    var affectedBodyPart: String?
    var isActive: Bool
    
    init(type: String, severity: InjurySeverity, recoveryStatus: RecoveryStatus, year: Int) {
        self.id = UUID()
        self.type = type
        self.severity = severity
        self.recoveryStatus = recoveryStatus
        self.year = year
        self.isActive = recoveryStatus == .active
    }
}

enum InjurySeverity: String, CaseIterable, Codable {
    case mild = "mild"
    case moderate = "moderate"
    case severe = "severe"
}

enum RecoveryStatus: String, CaseIterable, Codable {
    case active = "active"
    case recovering = "recovering"
    case resolved = "resolved"
}

struct TrainingHistory: Codable {
    var frequency: String?
    var intensity: String?
    var focusAreas: [String]
    var currentPlan: String?
    var yearsOfTraining: Int?
    var sports: [String]
    
    init() {
        self.focusAreas = []
        self.sports = []
    }
}

struct Goal: Codable, Identifiable {
    let id: UUID
    var description: String
    var priority: GoalPriority
    var targetDate: Date?
    var isAchieved: Bool
    
    init(description: String, priority: GoalPriority) {
        self.id = UUID()
        self.description = description
        self.priority = priority
        self.isAchieved = false
    }
}

enum GoalPriority: String, CaseIterable, Codable {
    case low = "low"
    case medium = "medium"
    case high = "high"
}

struct TrainingRegimen: Codable {
    var frequency: String
    var intensity: String
    var exercises: [String]
    var duration: String
    var notes: String?
}

struct InjuryStatus: Codable {
    var hasActiveInjuries: Bool
    var painLevel: Int // 1-10
    var limitations: [String]
    var recoveryProgress: Double // 0-1
}

struct Competition: Codable {
    var name: String
    var date: Date
    var type: String
    var goals: [String]
}

struct QualitativeState: Codable {
    var fatigueLevel: Int // 1-10
    var soreness: String?
    var motivation: String?
    var stressLevel: Int // 1-10
    var sleepQuality: Int // 1-10
    
    init() {
        self.fatigueLevel = 5
        self.stressLevel = 5
        self.sleepQuality = 5
    }
} 