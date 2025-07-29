import Foundation
import SwiftUI

// MARK: - App State Management

@MainActor
class AppState: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: UserProfile?
    @Published var isLoading: Bool = false
    @Published var currentAssessment: AssessmentResult?
    @Published var selectedTab: Int = 0
    
    // Onboarding state
    @Published var onboardingStep: OnboardingStep = .welcome
    @Published var onboardingData: OnboardingData = OnboardingData()
    
    // Assessment state
    @Published var currentExerciseIndex: Int = 0
    @Published var assessmentExercises: [AssessmentExercise] = AssessmentExercise.allExercises
    @Published var isAssessmentActive: Bool = false
    
    // Recovery modules
    @Published var activeRecoveryModule: RecoveryModule?
    @Published var recoveryModuleProgress: [String: Int] = [:] // moduleId: currentWeek
    
    // Recovery workout tracking
    @Published var currentRecoverySession: RecoveryWorkoutSession?
    @Published var recoveryWorkoutHistory: [RecoveryWorkoutSession] = []
    @Published var isRecoveryWorkoutActive: Bool = false
    
    init() {
        // Check if user is already authenticated
        checkAuthenticationStatus()
    }
    
    private func checkAuthenticationStatus() {
        // For now, simulate checking authentication
        // In a real app, this would check iCloud or other auth service
        isLoading = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            // For demo purposes, start with onboarding
            self.isAuthenticated = false
        }
    }
    
    func signIn(email: String, password: String) {
        isLoading = true
        
        // Simulate authentication
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            self.isAuthenticated = true
            
            // Check if this is the demo account
            if email.lowercased() == "demo@durability.com" && password == "demo123" {
                self.currentUser = self.createDemoUser()
            } else {
                // Create a regular user for demo
                self.currentUser = UserProfile(email: email, firstName: "Demo", lastName: "User")
            }
        }
    }
    
    func signUp(email: String, firstName: String, lastName: String, password: String) {
        isLoading = true
        
        // Simulate user creation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            self.isAuthenticated = true
            self.currentUser = UserProfile(email: email, firstName: firstName, lastName: lastName)
        }
    }
    
    func signOut() {
        isAuthenticated = false
        currentUser = nil
        onboardingStep = .welcome
        onboardingData = OnboardingData()
    }
    
    func startAssessment() {
        isAssessmentActive = true
        currentExerciseIndex = 0
        currentAssessment = AssessmentResult()
    }
    
    func completeAssessment() {
        isAssessmentActive = false
        currentExerciseIndex = 0
        
        // Calculate super metrics and durability score
        if let assessment = currentAssessment {
            calculateSuperMetrics(from: assessment)
            calculateDurabilityScore()
            
            // Save to user profile
            currentUser?.assessmentResults.append(assessment)
            currentUser?.superMetrics = assessment.superMetrics
            currentUser?.durabilityScore = assessment.durabilityScore
        }
    }
    
    private func calculateSuperMetrics(from assessment: AssessmentResult) {
        // Simulate calculation based on exercise results
        var superMetrics = SuperMetricScores()
        
        // Simple calculation based on completed exercises
        let completedExercises = assessment.exercises.filter { $0.isCompleted }
        let completionRate = Double(completedExercises.count) / Double(assessmentExercises.count)
        
        // Simulate metrics based on completion and some randomness
        superMetrics.rangeOfMotion = min(1.0, completionRate + Double.random(in: 0.1...0.3))
        superMetrics.flexibility = min(1.0, completionRate + Double.random(in: 0.1...0.3))
        superMetrics.mobility = min(1.0, completionRate + Double.random(in: 0.1...0.3))
        superMetrics.functionalStrength = min(1.0, completionRate + Double.random(in: 0.1...0.3))
        superMetrics.aerobicCapacity = min(1.0, completionRate + Double.random(in: 0.1...0.3))
        
        currentAssessment?.superMetrics = superMetrics
    }
    
    private func calculateDurabilityScore() {
        guard let assessment = currentAssessment else { return }
        
        // Weighted average of super metrics
        let superMetrics = assessment.superMetrics
        let durabilityScore = (
            superMetrics.rangeOfMotion * 0.25 +
            superMetrics.flexibility * 0.15 +
            superMetrics.mobility * 0.20 +
            superMetrics.functionalStrength * 0.25 +
            superMetrics.aerobicCapacity * 0.15
        ) * 100 // Convert to 0-100 scale
        
        currentAssessment?.durabilityScore = durabilityScore
    }
    
    func startRecoveryModule(_ module: RecoveryModule) {
        activeRecoveryModule = module
        recoveryModuleProgress[module.id] = 1
    }
    
    func advanceRecoveryModule() {
        guard let module = activeRecoveryModule else { return }
        let currentWeek = recoveryModuleProgress[module.id] ?? 1
        if currentWeek < module.durationWeeks {
            recoveryModuleProgress[module.id] = currentWeek + 1
        }
    }
    
    // MARK: - Recovery Workout Tracking
    
    func startRecoveryWorkout(for module: RecoveryModule, phaseIndex: Int, weekNumber: Int) {
        var session = RecoveryWorkoutSession(moduleId: module.id, phaseIndex: phaseIndex, weekNumber: weekNumber)
        currentRecoverySession = session
        isRecoveryWorkoutActive = true
        
        // Create initial workout with exercises from the phase
        let phase = module.phases[phaseIndex]
        var workout = RecoveryWorkout(moduleId: module.id, phaseIndex: phaseIndex, weekNumber: weekNumber)
        
        // Add exercises from the phase
        workout.exercises = phase.exercises.map { exerciseName in
            var exercise = RecoveryExercise(name: exerciseName)
            // Add default sets based on exercise type
            exercise.sets = [RecoverySet(), RecoverySet(), RecoverySet()] // Default 3 sets
            return exercise
        }
        
        session.workouts.append(workout)
        currentRecoverySession = session
    }
    
    func completeRecoveryWorkout() {
        guard var session = currentRecoverySession else { return }
        
        session.endTime = Date()
        session.isCompleted = true
        
        // Mark all workouts as completed
        for i in session.workouts.indices {
            session.workouts[i].isCompleted = true
            for j in session.workouts[i].exercises.indices {
                session.workouts[i].exercises[j].isCompleted = true
                for k in session.workouts[i].exercises[j].sets.indices {
                    session.workouts[i].exercises[j].sets[k].isCompleted = true
                }
            }
        }
        
        // Save to history
        recoveryWorkoutHistory.append(session)
        
        // Clear current session
        currentRecoverySession = nil
        isRecoveryWorkoutActive = false
        
        // Advance to next week if this was the last workout of the week
        advanceRecoveryModule()
    }
    
    func pauseRecoveryWorkout() {
        // Save current session to history without marking as completed
        if let session = currentRecoverySession {
            recoveryWorkoutHistory.append(session)
        }
        
        currentRecoverySession = nil
        isRecoveryWorkoutActive = false
    }
    
    func getCurrentPhase(for module: RecoveryModule) -> RecoveryPhase? {
        guard let currentWeek = recoveryModuleProgress[module.id] else { return nil }
        
        var weekCount = 0
        for (_, phase) in module.phases.enumerated() {
            if weekCount < currentWeek && currentWeek <= weekCount + phase.duration {
                return phase
            }
            weekCount += phase.duration
        }
        return nil
    }
    
    func getCurrentPhaseIndex(for module: RecoveryModule) -> Int? {
        guard let currentWeek = recoveryModuleProgress[module.id] else { return nil }
        
        var weekCount = 0
        for (index, phase) in module.phases.enumerated() {
            if weekCount < currentWeek && currentWeek <= weekCount + phase.duration {
                return index
            }
            weekCount += phase.duration
        }
        return nil
    }
    
    // MARK: - Demo User Creation
    
    private func createDemoUser() -> UserProfile {
        var demoUser = UserProfile(email: "demo@durability.com", firstName: "Alex", lastName: "Thompson")
        
        // Set biometrics
        demoUser.height = 175.0 // 5'9"
        demoUser.weight = 75.0 // 165 lbs
        demoUser.age = 28
        demoUser.sex = .male
        
        // Add injury history
        demoUser.injuries = [
            Injury(type: "ACL Tear", severity: .moderate, recoveryStatus: .resolved, year: 2022),
            Injury(type: "Shoulder Impingement", severity: .mild, recoveryStatus: .recovering, year: 2023)
        ]
        
        // Add training history
        var trainingHistory = TrainingHistory()
        trainingHistory.frequency = "4-5 times per week"
        trainingHistory.intensity = "High"
        trainingHistory.focusAreas = ["Strength", "Mobility", "Recovery"]
        trainingHistory.currentPlan = "Durability-focused training"
        trainingHistory.yearsOfTraining = 8
        trainingHistory.sports = ["Basketball", "Weightlifting", "Yoga"]
        demoUser.trainingHistory = trainingHistory
        
        // Add goals
        demoUser.goals = [
            Goal(description: "Improve overall durability score to 85+", priority: .high),
            Goal(description: "Complete ACL recovery program", priority: .high),
            Goal(description: "Increase mobility in hips and shoulders", priority: .medium),
            Goal(description: "Return to competitive basketball", priority: .medium)
        ]
        
        // Add current training regimen
        demoUser.currentTrainingRegimen = TrainingRegimen(
            frequency: "4 times per week",
            intensity: "Moderate to High",
            exercises: ["Squats", "Deadlifts", "Mobility work", "Recovery exercises"],
            duration: "60-90 minutes",
            notes: "Focus on form and gradual progression"
        )
        
        // Add current injury status
        demoUser.currentInjuryStatus = InjuryStatus(
            hasActiveInjuries: true,
            painLevel: 3,
            limitations: ["Limited shoulder range of motion", "Avoiding high-impact activities"],
            recoveryProgress: 0.75
        )
        
        // Add qualitative state
        var qualitativeState = QualitativeState()
        qualitativeState.fatigueLevel = 4
        qualitativeState.soreness = "Mild shoulder discomfort"
        qualitativeState.motivation = "Feeling strong and making good progress"
        qualitativeState.stressLevel = 3
        qualitativeState.sleepQuality = 7
        demoUser.qualitativeState = qualitativeState
        
        // Add completed assessments with super metrics
        let pastAssessments = [
            createPastAssessment(date: Date().addingTimeInterval(-7*24*3600), durabilityScore: 72),
            createPastAssessment(date: Date().addingTimeInterval(-14*24*3600), durabilityScore: 68),
            createPastAssessment(date: Date().addingTimeInterval(-21*24*3600), durabilityScore: 65),
            createPastAssessment(date: Date().addingTimeInterval(-28*24*3600), durabilityScore: 62)
        ]
        
        // Set super metrics for current state (improving over time)
        demoUser.superMetrics = SuperMetricScores(
            rangeOfMotion: 0.78,
            flexibility: 0.72,
            mobility: 0.75,
            functionalStrength: 0.82,
            aerobicCapacity: 0.68
        )
        
        // Set current durability score
        demoUser.durabilityScore = 76.0
        
        // Add assessment history
        demoUser.assessmentResults = pastAssessments
        
        // Set active recovery module
        let aclModule = RecoveryModule.allModules.first { $0.id == "acl_recovery" }
        if let aclModule = aclModule {
            activeRecoveryModule = aclModule
            recoveryModuleProgress[aclModule.id] = 3 // Week 3 of 8
        }
        
        return demoUser
    }
    
    private func createPastAssessment(date: Date, durabilityScore: Double) -> AssessmentResult {
        var assessment = AssessmentResult()
        assessment.date = date
        assessment.durabilityScore = durabilityScore
        
        // Create sample exercise results
        let exercises = [
            "Overhead Squat", "Single Leg Balance", "Hip Hinge", 
            "Shoulder Mobility", "Core Stability"
        ]
        
        assessment.exercises = exercises.map { exerciseName in
            var result = ExerciseResult(exerciseName: exerciseName)
            result.isCompleted = true
            return result
        }
        
        // Calculate super metrics based on durability score
        let baseScore = durabilityScore / 100.0
        assessment.superMetrics = SuperMetricScores(
            rangeOfMotion: baseScore + Double.random(in: -0.1...0.1),
            flexibility: baseScore + Double.random(in: -0.1...0.1),
            mobility: baseScore + Double.random(in: -0.1...0.1),
            functionalStrength: baseScore + Double.random(in: -0.1...0.1),
            aerobicCapacity: baseScore + Double.random(in: -0.1...0.1)
        )
        
        return assessment
    }
}

// MARK: - Onboarding State

enum OnboardingStep: Int, CaseIterable {
    case welcome = 0
    case accountCreation = 1
    case profileSurvey = 2
    case movementAssessment = 3
    case healthKitIntegration = 4
    case personalizedProgramming = 5
    case complete = 6
}

struct OnboardingData {
    var email: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var password: String = ""
    
    // Profile survey responses
    var injuryHistory: String = ""
    var trainingHistory: String = ""
    var competitionHistory: String = ""
    var currentRegimen: String = ""
    var currentInjuries: String = ""
    var goals: String = ""
    
    // Biometrics
    var height: Double?
    var weight: Double?
    var age: Int?
    var sex: Sex?
    
    // Qualitative state
    var fatigueLevel: Int = 5
    var soreness: String = ""
    var motivation: String = ""
    
    // HealthKit permission
    var healthKitEnabled: Bool = false
} 