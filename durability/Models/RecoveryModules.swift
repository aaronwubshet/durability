import Foundation

// MARK: - Recovery Module Models

struct RecoveryModule: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let durationWeeks: Int
    let uniqueMovementsCount: Int
    let recommendedFor: [String]
    let phases: [RecoveryPhase]
    let difficulty: ModuleDifficulty
    
    init(id: String, title: String, description: String, durationWeeks: Int, uniqueMovementsCount: Int, recommendedFor: [String], phases: [RecoveryPhase], difficulty: ModuleDifficulty) {
        self.id = id
        self.title = title
        self.description = description
        self.durationWeeks = durationWeeks
        self.uniqueMovementsCount = uniqueMovementsCount
        self.recommendedFor = recommendedFor
        self.phases = phases
        self.difficulty = difficulty
    }
}

struct RecoveryPhase: Codable, Identifiable {
    let id: UUID
    let title: String
    let duration: Int // in weeks
    let exercises: [String]
    let description: String
    let goals: [String]
    
    init(title: String, duration: Int, exercises: [String], description: String, goals: [String]) {
        self.id = UUID()
        self.title = title
        self.duration = duration
        self.exercises = exercises
        self.description = description
        self.goals = goals
    }
}

enum ModuleDifficulty: String, CaseIterable, Codable {
    case beginner = "beginner"
    case intermediate = "intermediate"
    case advanced = "advanced"
}

// MARK: - Recovery Module Definitions

extension RecoveryModule {
    static let allModules: [RecoveryModule] = [
        uclRecoveryModule,
        aclRecoveryModule,
        achillesRecoveryModule,
        labralShoulderRecoveryModule,
        itBandRecoveryModule
    ]
    
    static let uclRecoveryModule = RecoveryModule(
        id: "ucl_recovery",
        title: "UCL Recovery: Return to Throwing",
        description: "A 12-week program to restore elbow stability and return to throwing",
        durationWeeks: 12,
        uniqueMovementsCount: 18,
        recommendedFor: ["Elbow pain", "Baseball players", "Throwing athletes"],
        phases: [
            RecoveryPhase(
                title: "Weeks 1-2: Pain Management",
                duration: 2,
                exercises: ["Elbow isometrics", "Gentle wrist flexor stretches", "Ice/heat therapy", "Pain-free grip exercises"],
                description: "Focus on pain management and gentle range of motion",
                goals: ["Reduce pain", "Maintain basic range of motion", "Prevent stiffness"]
            ),
            RecoveryPhase(
                title: "Weeks 3-4: Early Strengthening",
                duration: 2,
                exercises: ["Forearm pronation/supination", "Wrist curls (light weight)", "Elbow flexion/extension", "Grip strengthening"],
                description: "Begin gentle strengthening exercises",
                goals: ["Improve forearm strength", "Increase range of motion", "Build foundation for throwing"]
            ),
            RecoveryPhase(
                title: "Weeks 5-6: Progressive Loading",
                duration: 2,
                exercises: ["Eccentric wrist flexor work", "Progressive resistance exercises", "Shoulder stability work", "Core integration"],
                description: "Increase resistance and complexity",
                goals: ["Build strength", "Improve stability", "Prepare for throwing motion"]
            ),
            RecoveryPhase(
                title: "Weeks 7-8: Sport-Specific Prep",
                duration: 2,
                exercises: ["Throwing motion simulation", "Plyometric preparation", "Endurance work", "Balance and coordination"],
                description: "Prepare for return to throwing",
                goals: ["Simulate throwing motion", "Build endurance", "Improve coordination"]
            ),
            RecoveryPhase(
                title: "Weeks 9-10: Return to Throwing",
                duration: 2,
                exercises: ["Progressive throwing program", "Velocity building", "Recovery monitoring", "Performance metrics"],
                description: "Begin actual throwing with progression",
                goals: ["Return to throwing", "Build velocity", "Monitor recovery"]
            ),
            RecoveryPhase(
                title: "Weeks 11-12: Performance Optimization",
                duration: 2,
                exercises: ["Full throwing program", "Competition simulation", "Injury prevention", "Maintenance program"],
                description: "Optimize performance and prevent reinjury",
                goals: ["Full return to sport", "Performance optimization", "Injury prevention"]
            )
        ],
        difficulty: .intermediate
    )
    
    static let aclRecoveryModule = RecoveryModule(
        id: "acl_recovery",
        title: "ACL Recovery: Cleared to Confident",
        description: "A 16-week program to restore knee stability and return to sport",
        durationWeeks: 16,
        uniqueMovementsCount: 22,
        recommendedFor: ["Knee pain", "Athletes", "Post-surgery"],
        phases: [
            RecoveryPhase(
                title: "Weeks 1-2: Post-Surgery Recovery",
                duration: 2,
                exercises: ["Range of motion exercises", "Quad sets", "Ankle pumps", "Pain management"],
                description: "Focus on basic recovery and pain management",
                goals: ["Reduce swelling", "Maintain range of motion", "Manage pain"]
            ),
            RecoveryPhase(
                title: "Weeks 3-4: Early Strengthening",
                duration: 2,
                exercises: ["Straight leg raises", "Heel slides", "Mini squats", "Calf raises"],
                description: "Begin gentle strengthening exercises",
                goals: ["Improve quad strength", "Increase range of motion", "Build foundation"]
            ),
            RecoveryPhase(
                title: "Weeks 5-6: Progressive Loading",
                duration: 2,
                exercises: ["Wall sits", "Step-ups", "Leg press", "Balance exercises"],
                description: "Increase resistance and complexity",
                goals: ["Build strength", "Improve balance", "Prepare for weight bearing"]
            ),
            RecoveryPhase(
                title: "Weeks 7-8: Strength Building",
                duration: 2,
                exercises: ["Squats", "Lunges", "Deadlifts", "Plyometric preparation"],
                description: "Build strength and prepare for dynamic movements",
                goals: ["Build functional strength", "Prepare for plyometrics", "Improve stability"]
            ),
            RecoveryPhase(
                title: "Weeks 9-12: Sport-Specific",
                duration: 4,
                exercises: ["Cutting and pivoting", "Jump training", "Agility drills", "Endurance work"],
                description: "Prepare for sport-specific movements",
                goals: ["Improve agility", "Build endurance", "Prepare for return to sport"]
            ),
            RecoveryPhase(
                title: "Weeks 13-16: Return to Sport",
                duration: 4,
                exercises: ["Full sport simulation", "Performance testing", "Injury prevention", "Maintenance program"],
                description: "Full return to sport with confidence",
                goals: ["Full return to sport", "Performance optimization", "Injury prevention"]
            )
        ],
        difficulty: .intermediate
    )
    
    static let achillesRecoveryModule = RecoveryModule(
        id: "achilles_recovery",
        title: "Achilles Recovery: Return to Running",
        description: "A 14-week program to restore calf strength and return to running",
        durationWeeks: 14,
        uniqueMovementsCount: 20,
        recommendedFor: ["Calf pain", "Runners", "Achilles tendonitis"],
        phases: [
            RecoveryPhase(
                title: "Weeks 1-2: Pain Management",
                duration: 2,
                exercises: ["Gentle calf stretches", "Ice/heat therapy", "Pain-free range of motion", "Massage techniques"],
                description: "Focus on pain management and gentle stretching",
                goals: ["Reduce pain", "Improve flexibility", "Maintain range of motion"]
            ),
            RecoveryPhase(
                title: "Weeks 3-4: Early Strengthening",
                duration: 2,
                exercises: ["Eccentric calf raises", "Towel scrunches", "Ankle mobility", "Gentle walking"],
                description: "Begin gentle strengthening exercises",
                goals: ["Improve calf strength", "Increase ankle mobility", "Prepare for walking"]
            ),
            RecoveryPhase(
                title: "Weeks 5-6: Progressive Loading",
                duration: 2,
                exercises: ["Progressive calf raises", "Single-leg balance", "Step-ups", "Pool walking"],
                description: "Increase resistance and complexity",
                goals: ["Build strength", "Improve balance", "Prepare for running"]
            ),
            RecoveryPhase(
                title: "Weeks 7-8: Strength Building",
                duration: 2,
                exercises: ["Heavy calf raises", "Plyometric preparation", "Hip strengthening", "Core work"],
                description: "Build strength and prepare for dynamic movements",
                goals: ["Build functional strength", "Prepare for plyometrics", "Improve stability"]
            ),
            RecoveryPhase(
                title: "Weeks 9-10: Return to Running",
                duration: 2,
                exercises: ["Walk-run progression", "Speed work", "Endurance building", "Recovery monitoring"],
                description: "Begin return to running with progression",
                goals: ["Return to running", "Build endurance", "Monitor recovery"]
            ),
            RecoveryPhase(
                title: "Weeks 11-14: Performance",
                duration: 4,
                exercises: ["Full running program", "Race simulation", "Injury prevention", "Maintenance program"],
                description: "Optimize performance and prevent reinjury",
                goals: ["Full return to running", "Performance optimization", "Injury prevention"]
            )
        ],
        difficulty: .intermediate
    )
    
    static let labralShoulderRecoveryModule = RecoveryModule(
        id: "labral_shoulder_recovery",
        title: "Labral Shoulder Recovery: Stability & Strength",
        description: "A 12-week program to restore shoulder stability and function",
        durationWeeks: 12,
        uniqueMovementsCount: 19,
        recommendedFor: ["Shoulder pain", "Overhead athletes", "Post-surgery"],
        phases: [
            RecoveryPhase(
                title: "Weeks 1-2: Post-Surgery Recovery",
                duration: 2,
                exercises: ["Passive range of motion", "Pain management", "Gentle pendulums", "Ice therapy"],
                description: "Focus on basic recovery and pain management",
                goals: ["Reduce pain", "Maintain range of motion", "Manage swelling"]
            ),
            RecoveryPhase(
                title: "Weeks 3-4: Early Strengthening",
                duration: 2,
                exercises: ["Active range of motion", "Scapular retractions", "Isometric exercises", "Gentle stretches"],
                description: "Begin gentle strengthening exercises",
                goals: ["Improve shoulder mobility", "Build scapular stability", "Increase range of motion"]
            ),
            RecoveryPhase(
                title: "Weeks 5-6: Progressive Loading",
                duration: 2,
                exercises: ["Resistance band work", "Wall push-ups", "Shoulder stability", "Core integration"],
                description: "Increase resistance and complexity",
                goals: ["Build shoulder strength", "Improve stability", "Prepare for functional movements"]
            ),
            RecoveryPhase(
                title: "Weeks 7-8: Strength Building",
                duration: 2,
                exercises: ["Progressive push-ups", "Overhead pressing", "Rotator cuff work", "Plyometric preparation"],
                description: "Build strength and prepare for dynamic movements",
                goals: ["Build functional strength", "Prepare for overhead movements", "Improve stability"]
            ),
            RecoveryPhase(
                title: "Weeks 9-10: Sport-Specific",
                duration: 2,
                exercises: ["Throwing motion", "Overhead movements", "Endurance work", "Performance testing"],
                description: "Prepare for sport-specific movements",
                goals: ["Improve sport-specific movements", "Build endurance", "Prepare for return to sport"]
            ),
            RecoveryPhase(
                title: "Weeks 11-12: Return to Sport",
                duration: 2,
                exercises: ["Full sport simulation", "Competition prep", "Injury prevention", "Maintenance program"],
                description: "Full return to sport with confidence",
                goals: ["Full return to sport", "Performance optimization", "Injury prevention"]
            )
        ],
        difficulty: .intermediate
    )
    
    static let itBandRecoveryModule = RecoveryModule(
        id: "it_band_recovery",
        title: "IT Band Recovery: Pain-Free Movement",
        description: "An 8-week program to eliminate IT band pain and restore function",
        durationWeeks: 8,
        uniqueMovementsCount: 15,
        recommendedFor: ["Knee pain", "Runners", "Lateral hip pain"],
        phases: [
            RecoveryPhase(
                title: "Weeks 1-2: Pain Management",
                duration: 2,
                exercises: ["Foam rolling", "Gentle stretches", "Ice therapy", "Activity modification"],
                description: "Focus on pain management and gentle stretching",
                goals: ["Reduce pain", "Improve flexibility", "Modify activities"]
            ),
            RecoveryPhase(
                title: "Weeks 3-4: Mobility & Stability",
                duration: 2,
                exercises: ["Hip mobility work", "Glute activation", "Core strengthening", "Balance exercises"],
                description: "Improve mobility and build stability",
                goals: ["Improve hip mobility", "Activate glutes", "Build core strength"]
            ),
            RecoveryPhase(
                title: "Weeks 5-6: Strength Building",
                duration: 2,
                exercises: ["Single-leg exercises", "Lateral movements", "Plyometric preparation", "Endurance work"],
                description: "Build strength and prepare for dynamic movements",
                goals: ["Build functional strength", "Prepare for dynamic movements", "Improve endurance"]
            ),
            RecoveryPhase(
                title: "Weeks 7-8: Return to Activity",
                duration: 2,
                exercises: ["Progressive running", "Sport-specific movements", "Injury prevention", "Maintenance program"],
                description: "Return to activity with confidence",
                goals: ["Return to running", "Performance optimization", "Injury prevention"]
            )
        ],
        difficulty: .beginner
    )
} 