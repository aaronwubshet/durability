import SwiftUI

struct ProfileSurveyView: View {
    @ObservedObject var appState: AppState
    @Binding var currentStep: OnboardingStep
    
    @State private var currentQuestionIndex = 0
    @State private var injuryHistory = ""
    @State private var trainingHistory = ""
    @State private var competitionHistory = ""
    @State private var currentRegimen = ""
    @State private var currentInjuries = ""
    @State private var goals = ""
    @State private var fatigueLevel: Double = 5
    @State private var soreness = ""
    @State private var motivation = ""
    @FocusState private var isTextFieldFocused: Bool
    
    private let questions = [
        SurveyQuestion(
            id: "injury_history",
            title: "Tell us about your injury history",
            description: "Describe any past injuries, surgeries, or chronic conditions that might affect your training.",
            placeholder: "e.g., ACL tear in 2022, shoulder surgery in 2021...",
            type: .textArea
        ),
        SurveyQuestion(
            id: "training_history",
            title: "What's your training background?",
            description: "Tell us about your experience with fitness, sports, and training programs.",
            placeholder: "e.g., 5 years of weightlifting, former college athlete...",
            type: .textArea
        ),
        SurveyQuestion(
            id: "competition_history",
            title: "Do you compete in any sports?",
            description: "Tell us about your competitive experience, if any.",
            placeholder: "e.g., recreational basketball, local 5K races...",
            type: .textArea
        ),
        SurveyQuestion(
            id: "current_regimen",
            title: "What's your current training routine?",
            description: "Describe your current workout schedule, if you have one.",
            placeholder: "e.g., 3x per week strength training, daily running...",
            type: .textArea
        ),
        SurveyQuestion(
            id: "current_injuries",
            title: "Any current injuries or pain?",
            description: "Tell us about any active injuries, pain, or limitations you're experiencing.",
            placeholder: "e.g., knee pain when squatting, shoulder stiffness...",
            type: .textArea
        ),
        SurveyQuestion(
            id: "goals",
            title: "What are your fitness goals?",
            description: "What do you want to achieve with your training?",
            placeholder: "e.g., return to basketball, improve mobility, prevent injuries...",
            type: .textArea
        ),
        SurveyQuestion(
            id: "fatigue_level",
            title: "How are you feeling today?",
            description: "Rate your current fatigue level on a scale of 1-10.",
            placeholder: "",
            type: .slider
        ),
        SurveyQuestion(
            id: "soreness",
            title: "Any specific soreness or discomfort?",
            description: "Tell us about any areas of soreness or discomfort.",
            placeholder: "e.g., tight hamstrings, sore lower back...",
            type: .textArea
        ),
        SurveyQuestion(
            id: "motivation",
            title: "What motivates you to train?",
            description: "Tell us what drives you to stay active and improve.",
            placeholder: "e.g., staying healthy, competing, feeling strong...",
            type: .textArea
        )
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 16) {
                Text("Tell us about yourself")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.durabilityPrimaryText)
                
                Text("This helps us personalize your experience")
                    .font(.subheadline)
                    .foregroundColor(.durabilitySecondaryText)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Question content
            ScrollView {
                VStack(spacing: 24) {
                    if currentQuestionIndex < questions.count {
                        let question = questions[currentQuestionIndex]
                        
                        VStack(alignment: .leading, spacing: 16) {
                            // Tap to dismiss keyboard
                            Color.clear
                                .frame(height: 1)
                                .onTapGesture {
                                    isTextFieldFocused = false
                                }
                            Text(question.title)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.durabilityPrimaryText)
                            
                            Text(question.description)
                                .font(.subheadline)
                                .foregroundColor(.durabilitySecondaryText)
                            
                            switch question.type {
                            case .textArea:
                                TextEditor(text: getBindingForQuestion(question.id))
                                    .frame(minHeight: 120)
                                    .padding()
                                    .background(Color.durabilityCardBackground)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.durabilitySecondaryText.opacity(0.3), lineWidth: 1)
                                    )
                                    .foregroundColor(.durabilityPrimaryText)
                                    .focused($isTextFieldFocused)
                                
                            case .slider:
                                VStack(spacing: 12) {
                                    HStack {
                                        Text("1")
                                            .font(.caption)
                                            .foregroundColor(.durabilitySecondaryText)
                                        
                                        Slider(value: $fatigueLevel, in: 1...10, step: 1)
                                            .accentColor(.durabilityPrimaryAccent)
                                        
                                        Text("10")
                                            .font(.caption)
                                            .foregroundColor(.durabilitySecondaryText)
                                    }
                                    
                                    Text("Fatigue Level: \(Int(fatigueLevel))")
                                        .font(.headline)
                                        .foregroundColor(.durabilityPrimaryAccent)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            
            // Navigation buttons
            HStack(spacing: 16) {
                if currentQuestionIndex > 0 {
                                    Button("Back") {
                    isTextFieldFocused = false
                    withAnimation {
                        currentQuestionIndex -= 1
                    }
                }
                    .foregroundColor(.durabilitySecondaryText)
                }
                
                Spacer()
                
                Button(currentQuestionIndex == questions.count - 1 ? "Complete" : "Next") {
                    isTextFieldFocused = false
                    if currentQuestionIndex == questions.count - 1 {
                        // Save data and move to next step
                        saveSurveyData()
                        withAnimation {
                            currentStep = .movementAssessment
                        }
                    } else {
                        withAnimation {
                            currentQuestionIndex += 1
                        }
                    }
                }
                .font(.headline)
                .foregroundColor(.black)
                .padding(.horizontal, 32)
                .padding(.vertical, 12)
                .background(Color.durabilityPrimaryAccent)
                .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
    
    private func getBindingForQuestion(_ questionId: String) -> Binding<String> {
        switch questionId {
        case "injury_history":
            return $injuryHistory
        case "training_history":
            return $trainingHistory
        case "competition_history":
            return $competitionHistory
        case "current_regimen":
            return $currentRegimen
        case "current_injuries":
            return $currentInjuries
        case "goals":
            return $goals
        case "soreness":
            return $soreness
        case "motivation":
            return $motivation
        default:
            return .constant("")
        }
    }
    
    private func saveSurveyData() {
        appState.onboardingData.injuryHistory = injuryHistory
        appState.onboardingData.trainingHistory = trainingHistory
        appState.onboardingData.competitionHistory = competitionHistory
        appState.onboardingData.currentRegimen = currentRegimen
        appState.onboardingData.currentInjuries = currentInjuries
        appState.onboardingData.goals = goals
        appState.onboardingData.fatigueLevel = Int(fatigueLevel)
        appState.onboardingData.soreness = soreness
        appState.onboardingData.motivation = motivation
    }
}

// MARK: - Survey Question Model

struct SurveyQuestion {
    let id: String
    let title: String
    let description: String
    let placeholder: String
    let type: QuestionType
}

enum QuestionType {
    case textArea
    case slider
}

#Preview {
    ProfileSurveyView(appState: AppState(), currentStep: .constant(.profileSurvey))
} 