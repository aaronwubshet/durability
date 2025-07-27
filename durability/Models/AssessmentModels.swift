import Foundation

// MARK: - Assessment Models

struct AssessmentResult: Codable, Identifiable {
    let id: UUID
    var date: Date
    var exercises: [ExerciseResult]
    var superMetrics: SuperMetricScores
    var durabilityScore: Double
    var notes: String?
    
    init() {
        self.id = UUID()
        self.date = Date()
        self.exercises = []
        self.superMetrics = SuperMetricScores()
        self.durabilityScore = 0.0
    }
}

struct ExerciseResult: Codable, Identifiable {
    let id: UUID
    let exerciseName: String
    var metrics: [ExerciseMetric]
    var isCompleted: Bool
    var videoURL: String?
    var notes: String?
    
    init(exerciseName: String) {
        self.id = UUID()
        self.exerciseName = exerciseName
        self.metrics = []
        self.isCompleted = false
    }
}

struct ExerciseMetric: Codable, Identifiable {
    let id: UUID
    let name: String
    let value: Double
    let unit: String
    let targetRange: ClosedRange<Double>?
    let isOptimal: Bool
    
    init(name: String, value: Double, unit: String, targetRange: ClosedRange<Double>? = nil) {
        self.id = UUID()
        self.name = name
        self.value = value
        self.unit = unit
        self.targetRange = targetRange
        self.isOptimal = targetRange?.contains(value) ?? true
    }
}

struct SuperMetricScores: Codable {
    var rangeOfMotion: Double // 0-1
    var flexibility: Double // 0-1
    var mobility: Double // 0-1
    var functionalStrength: Double // 0-1
    var aerobicCapacity: Double // 0-1
    
    init() {
        self.rangeOfMotion = 0.0
        self.flexibility = 0.0
        self.mobility = 0.0
        self.functionalStrength = 0.0
        self.aerobicCapacity = 0.0
    }
    
    init(rangeOfMotion: Double, flexibility: Double, mobility: Double, functionalStrength: Double, aerobicCapacity: Double) {
        self.rangeOfMotion = rangeOfMotion
        self.flexibility = flexibility
        self.mobility = mobility
        self.functionalStrength = functionalStrength
        self.aerobicCapacity = aerobicCapacity
    }
    
    var average: Double {
        return (rangeOfMotion + flexibility + mobility + functionalStrength + aerobicCapacity) / 5.0
    }
}

// MARK: - Assessment Exercises

struct AssessmentExercise: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let instructions: String
    let demoVideoName: String?
    let audioInstructionName: String?
    let targetMetrics: [String]
    let bodyPart: String
    let difficulty: ExerciseDifficulty
    
    init(id: String, name: String, description: String, instructions: String, targetMetrics: [String], bodyPart: String, difficulty: ExerciseDifficulty) {
        self.id = id
        self.name = name
        self.description = description
        self.instructions = instructions
        self.demoVideoName = nil
        self.audioInstructionName = nil
        self.targetMetrics = targetMetrics
        self.bodyPart = bodyPart
        self.difficulty = difficulty
    }
}

enum ExerciseDifficulty: String, CaseIterable, Codable {
    case beginner = "beginner"
    case intermediate = "intermediate"
    case advanced = "advanced"
}

// MARK: - Assessment Exercise Definitions

extension AssessmentExercise {
    static let allExercises: [AssessmentExercise] = [
        AssessmentExercise(
            id: "overhead_squat",
            name: "Overhead Squat",
            description: "Assess full body mobility and stability",
            instructions: "Hold PVC pipe overhead with arms straight. Squat down as low as possible while keeping the pipe overhead and your chest up.",
            targetMetrics: ["depth", "knee_angle", "hip_angle", "shoulder_angle"],
            bodyPart: "full_body",
            difficulty: .intermediate
        ),
        AssessmentExercise(
            id: "active_straight_leg_raise",
            name: "Active Straight Leg Raise",
            description: "Assess hamstring flexibility and hip mobility",
            instructions: "Lie on your back with legs straight. Raise one leg as high as possible while keeping the other leg flat on the ground.",
            targetMetrics: ["leg_angle", "hip_flexion", "core_stability"],
            bodyPart: "lower_body",
            difficulty: .beginner
        ),
        AssessmentExercise(
            id: "shoulder_raise",
            name: "Shoulder Raise",
            description: "Assess shoulder mobility and stability",
            instructions: "Stand with arms at sides. Raise both arms overhead as high as possible while keeping them straight.",
            targetMetrics: ["shoulder_angle", "thoracic_extension", "core_stability"],
            bodyPart: "upper_body",
            difficulty: .beginner
        ),
        AssessmentExercise(
            id: "dorsiflexion_ankle_test",
            name: "Dorsiflexion Ankle Test",
            description: "Assess ankle mobility and calf flexibility",
            instructions: "Stand facing a wall. Place one foot forward and try to touch your knee to the wall while keeping your heel on the ground.",
            targetMetrics: ["ankle_angle", "calf_flexibility", "balance"],
            bodyPart: "lower_body",
            difficulty: .beginner
        ),
        AssessmentExercise(
            id: "childs_pose",
            name: "Child's Pose",
            description: "Assess thoracic spine mobility and shoulder flexibility",
            instructions: "Kneel on the ground with knees wide apart. Sit back on your heels and reach your arms forward, lowering your chest toward the ground.",
            targetMetrics: ["thoracic_extension", "shoulder_flexibility", "hip_flexion"],
            bodyPart: "upper_body",
            difficulty: .beginner
        ),
        AssessmentExercise(
            id: "cobra",
            name: "Cobra",
            description: "Assess thoracic extension and shoulder mobility",
            instructions: "Lie face down with hands under shoulders. Press up to lift your chest while keeping your pelvis on the ground.",
            targetMetrics: ["thoracic_extension", "shoulder_angle", "core_stability"],
            bodyPart: "upper_body",
            difficulty: .beginner
        ),
        AssessmentExercise(
            id: "standing_hinge_wide",
            name: "Standing Hinge: Wide Stance",
            description: "Assess hip mobility and posterior chain flexibility",
            instructions: "Stand with feet wide apart. Hinge at the hips to reach down toward your feet while keeping your legs straight.",
            targetMetrics: ["hip_angle", "hamstring_flexibility", "core_stability"],
            bodyPart: "lower_body",
            difficulty: .intermediate
        ),
        AssessmentExercise(
            id: "standing_hinge_normal",
            name: "Standing Hinge: Normal Stance",
            description: "Assess hip mobility and posterior chain flexibility",
            instructions: "Stand with feet shoulder-width apart. Hinge at the hips to reach down toward your feet while keeping your legs straight.",
            targetMetrics: ["hip_angle", "hamstring_flexibility", "core_stability"],
            bodyPart: "lower_body",
            difficulty: .intermediate
        ),
        AssessmentExercise(
            id: "cervical_mobility_test",
            name: "Cervical Mobility Test",
            description: "Assess neck mobility and range of motion",
            instructions: "Sit or stand with your back straight. Slowly rotate your head to look over each shoulder as far as possible.",
            targetMetrics: ["cervical_rotation", "cervical_flexion", "cervical_extension"],
            bodyPart: "upper_body",
            difficulty: .beginner
        ),
        AssessmentExercise(
            id: "pvc_arm_raise",
            name: "PVC Arm Raise",
            description: "Assess shoulder mobility and thoracic extension",
            instructions: "Hold a PVC pipe with a wide grip. Raise the pipe overhead as far as possible while keeping your arms straight.",
            targetMetrics: ["shoulder_angle", "thoracic_extension", "core_stability"],
            bodyPart: "upper_body",
            difficulty: .beginner
        )
    ]
} 