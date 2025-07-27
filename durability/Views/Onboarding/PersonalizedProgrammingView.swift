import SwiftUI

struct PersonalizedProgrammingView: View {
    @ObservedObject var appState: AppState
    @Binding var currentStep: OnboardingStep
    
    @State private var isGenerating = true
    @State private var generatedProgram: PersonalizedProgram?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 16) {
                Text("Your Personalized Program")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.durabilityPrimaryText)
                
                Text("Based on your assessment, we've created a program tailored to your needs")
                    .font(.subheadline)
                    .foregroundColor(.durabilitySecondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(.horizontal)
            .padding(.top)
            
            if isGenerating {
                // Loading state
                VStack(spacing: 24) {
                    Spacer()
                    
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .accentColor(.durabilityPrimaryAccent)
                        
                        Text("Generating your program...")
                            .font(.title3)
                            .foregroundColor(.durabilityPrimaryText)
                        
                        Text("Analyzing your movement patterns and creating personalized recommendations")
                            .font(.subheadline)
                            .foregroundColor(.durabilitySecondaryText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                }
            } else if let program = generatedProgram {
                // Program display
                ScrollView {
                    VStack(spacing: 24) {
                        // Durability Score
                        OnboardingDurabilityScoreCard(score: program.durabilityScore)
                        
                        // Super Metrics
                        SuperMetricsCard(superMetrics: program.superMetrics)
                        
                        // Recommendations
                        RecommendationsCard(recommendations: program.recommendations)
                        
                        // Recovery Modules (if applicable)
                        if !program.recommendedModules.isEmpty {
                            RecoveryModulesCard(modules: program.recommendedModules)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical)
                }
            }
            
            // Action buttons
            if !isGenerating {
                VStack(spacing: 16) {
                    Button(action: {
                        completeOnboarding()
                    }) {
                        Text("Start My Program")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.durabilityPrimaryAccent)
                            .cornerRadius(16)
                    }
                    
                    Button(action: {
                        // Show program details or customization options
                    }) {
                        Text("Customize Program")
                            .font(.subheadline)
                            .foregroundColor(.durabilitySecondaryText)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .onAppear {
            generateProgram()
        }
    }
    
    private func generateProgram() {
        // Simulate program generation
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: DispatchWorkItem {
            isGenerating = false
            
            // Generate sample program based on assessment
            let superMetrics = SuperMetricScores(
                rangeOfMotion: 0.75,
                flexibility: 0.65,
                mobility: 0.80,
                functionalStrength: 0.70,
                aerobicCapacity: 0.60
            )
            
            let durabilityScore = (
                superMetrics.rangeOfMotion * 0.25 +
                superMetrics.flexibility * 0.15 +
                superMetrics.mobility * 0.20 +
                superMetrics.functionalStrength * 0.25 +
                superMetrics.aerobicCapacity * 0.15
            ) * 100
            
            generatedProgram = PersonalizedProgram(
                durabilityScore: durabilityScore,
                superMetrics: superMetrics,
                recommendations: [
                    "Add daily mobility routine to improve flexibility",
                    "Focus on hip and thoracic spine mobility",
                    "Include single-leg exercises for stability",
                    "Progress to plyometric training in 4 weeks"
                ],
                recommendedModules: [RecoveryModule.itBandRecoveryModule]
            )
        })
    }
    
    private func completeOnboarding() {
        // Save program to user profile
        if let program = generatedProgram {
            appState.currentUser?.superMetrics = program.superMetrics
            appState.currentUser?.durabilityScore = program.durabilityScore
        }
        
        // Complete onboarding
        withAnimation {
            currentStep = .complete
        }
    }
}

// MARK: - Program Display Components

struct OnboardingDurabilityScoreCard: View {
    let score: Double
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Your Durability Score")
                .font(.headline)
                .foregroundColor(.durabilityPrimaryText)
            
            Text("\(Int(score))")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.durabilityPrimaryAccent)
            
            Text(scoreDescription)
                .font(.subheadline)
                .foregroundColor(.durabilitySecondaryText)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(16)
    }
    
    private var scoreDescription: String {
        switch score {
        case 80...100:
            return "Excellent! You have great overall fitness and durability."
        case 60..<80:
            return "Good! You're on the right track with room for improvement."
        case 40..<60:
            return "Fair. Focus on the recommendations below to improve."
        default:
            return "Needs work. Follow the program to build your durability."
        }
    }
}

struct SuperMetricsCard: View {
    let superMetrics: SuperMetricScores
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Super Metrics")
                .font(.headline)
                .foregroundColor(.durabilityPrimaryText)
            
            VStack(spacing: 12) {
                MetricRow(name: "Range of Motion", value: superMetrics.rangeOfMotion)
                MetricRow(name: "Flexibility", value: superMetrics.flexibility)
                MetricRow(name: "Mobility", value: superMetrics.mobility)
                MetricRow(name: "Functional Strength", value: superMetrics.functionalStrength)
                MetricRow(name: "Aerobic Capacity", value: superMetrics.aerobicCapacity)
            }
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(16)
    }
}

struct MetricRow: View {
    let name: String
    let value: Double
    
    var body: some View {
        HStack {
            Text(name)
                .font(.subheadline)
                .foregroundColor(.durabilityPrimaryText)
            
            Spacer()
            
            Text("\(Int(value * 100))%")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.durabilityPrimaryAccent)
        }
    }
}

struct RecommendationsCard: View {
    let recommendations: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Recommendations")
                .font(.headline)
                .foregroundColor(.durabilityPrimaryText)
            
            VStack(spacing: 12) {
                ForEach(recommendations, id: \.self) { recommendation in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.durabilityPrimaryAccent)
                            .font(.subheadline)
                        
                        Text(recommendation)
                            .font(.subheadline)
                            .foregroundColor(.durabilitySecondaryText)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(16)
    }
}

struct RecoveryModulesCard: View {
    let modules: [RecoveryModule]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recommended Recovery Programs")
                .font(.headline)
                .foregroundColor(.durabilityPrimaryText)
            
            VStack(spacing: 12) {
                ForEach(modules) { module in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(module.title)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.durabilityPrimaryText)
                            
                            Text("\(module.durationWeeks) weeks • \(module.uniqueMovementsCount) exercises")
                                .font(.caption)
                                .foregroundColor(.durabilitySecondaryText)
                        }
                        
                        Spacer()
                        
                        Button("Start") {
                            // Start recovery module
                        }
                        .font(.caption)
                        .foregroundColor(.durabilityPrimaryAccent)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.durabilityPrimaryAccent.opacity(0.2))
                        .cornerRadius(8)
                    }
                    .padding()
                    .background(Color.durabilitySecondaryBackground)
                    .cornerRadius(12)
                }
            }
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(16)
    }
}

// MARK: - Personalized Program Model

struct PersonalizedProgram {
    let durabilityScore: Double
    let superMetrics: SuperMetricScores
    let recommendations: [String]
    let recommendedModules: [RecoveryModule]
}

#Preview {
    PersonalizedProgrammingView(appState: AppState(), currentStep: .constant(.personalizedProgramming))
} 