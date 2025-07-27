import SwiftUI

struct MovementAssessmentView: View {
    @ObservedObject var appState: AppState
    @Binding var currentStep: OnboardingStep
    
    @State private var currentExerciseIndex = 0
    @State private var isRecording = false
    @State private var isProcessing = false
    @State private var exerciseResults: [ExerciseResult] = []
    @State private var showingInstructions = true
    
    private var currentExercise: AssessmentExercise {
        AssessmentExercise.allExercises[currentExerciseIndex]
    }
    
    private var progress: Double {
        Double(currentExerciseIndex + 1) / Double(AssessmentExercise.allExercises.count)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 16) {
                Text("Movement Assessment")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.durabilityPrimaryText)
                
                Text("We'll analyze your movement patterns to create your personalized program")
                    .font(.subheadline)
                    .foregroundColor(.durabilitySecondaryText)
                    .multilineTextAlignment(.center)
                
                // Progress bar
                VStack(spacing: 8) {
                    HStack {
                        Text("Exercise \(currentExerciseIndex + 1) of \(AssessmentExercise.allExercises.count)")
                            .font(.caption)
                            .foregroundColor(.durabilitySecondaryText)
                        
                        Spacer()
                        
                        Text("\(Int(progress * 100))%")
                            .font(.caption)
                            .foregroundColor(.durabilityPrimaryAccent)
                    }
                    
                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .durabilityPrimaryAccent))
                        .background(Color.durabilityCardBackground)
                        .cornerRadius(4)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Exercise content
            ScrollView {
                VStack(spacing: 24) {
                    // Exercise card
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(currentExercise.name)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.durabilityPrimaryText)
                                
                                Text(currentExercise.description)
                                    .font(.subheadline)
                                    .foregroundColor(.durabilitySecondaryText)
                            }
                            
                            Spacer()
                            
                            // Difficulty badge
                            Text(currentExercise.difficulty.rawValue.capitalized)
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(difficultyColor)
                                .foregroundColor(.black)
                                .cornerRadius(8)
                        }
                        
                        // Instructions
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Instructions")
                                .font(.headline)
                                .foregroundColor(.durabilityPrimaryText)
                            
                            Text(currentExercise.instructions)
                                .font(.body)
                                .foregroundColor(.durabilitySecondaryText)
                                .lineLimit(nil)
                        }
                        
                        // Demo video placeholder
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.durabilityCardBackground)
                            .frame(height: 200)
                            .overlay(
                                VStack(spacing: 12) {
                                    Image(systemName: "video.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.durabilitySecondaryText)
                                    
                                    Text("Demo Video")
                                        .font(.subheadline)
                                        .foregroundColor(.durabilitySecondaryText)
                                }
                            )
                        
                        // Recording area
                        VStack(spacing: 16) {
                            Text("Record your movement")
                                .font(.headline)
                                .foregroundColor(.durabilityPrimaryText)
                            
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.durabilityCardBackground)
                                .frame(height: 300)
                                .overlay(
                                    VStack(spacing: 16) {
                                        if isRecording {
                                            VStack(spacing: 8) {
                                                Circle()
                                                    .fill(Color.red)
                                                    .frame(width: 12, height: 12)
                                                    .scaleEffect(1.2)
                                                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isRecording)
                                                
                                                Text("Recording...")
                                                    .font(.subheadline)
                                                    .foregroundColor(.red)
                                            }
                                        } else {
                                            VStack(spacing: 12) {
                                                Image(systemName: "camera.fill")
                                                    .font(.system(size: 40))
                                                    .foregroundColor(.durabilitySecondaryText)
                                                
                                                Text("Tap to start recording")
                                                    .font(.subheadline)
                                                    .foregroundColor(.durabilitySecondaryText)
                                            }
                                        }
                                    }
                                )
                                .onTapGesture {
                                    if !isRecording && !isProcessing {
                                        startRecording()
                                    }
                                }
                            
                            if isProcessing {
                                HStack(spacing: 12) {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                        .accentColor(.durabilityPrimaryAccent)
                                    
                                    Text("Analyzing movement...")
                                        .font(.subheadline)
                                        .foregroundColor(.durabilitySecondaryText)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color.durabilityCardBackground)
                    .cornerRadius(16)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            
            // Action buttons
            HStack(spacing: 16) {
                Button("Skip") {
                    skipExercise()
                }
                .foregroundColor(.durabilitySecondaryText)
                
                Spacer()
                
                if isRecording {
                    Button("Stop Recording") {
                        stopRecording()
                    }
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.red)
                    .cornerRadius(12)
                } else if isProcessing {
                    Button("Processing...") {
                        // Disabled during processing
                    }
                    .font(.headline)
                    .foregroundColor(.durabilitySecondaryText)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.durabilitySecondaryBackground)
                    .cornerRadius(12)
                    .disabled(true)
                } else {
                    Button("Next Exercise") {
                        nextExercise()
                    }
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.durabilityPrimaryAccent)
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
    
    private var difficultyColor: Color {
        switch currentExercise.difficulty {
        case .beginner:
            return .green
        case .intermediate:
            return .orange
        case .advanced:
            return .red
        }
    }
    
    private func startRecording() {
        isRecording = true
        
        // Simulate recording for 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            stopRecording()
        }
    }
    
    private func stopRecording() {
        isRecording = false
        isProcessing = true
        
        // Simulate processing for 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isProcessing = false
            
            // Simulate successful completion
            let exerciseResult = ExerciseResult(exerciseName: currentExercise.name)
            exerciseResults.append(exerciseResult)
            
            // Auto-progress to next exercise
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                nextExercise()
            }
        }
    }
    
    private func nextExercise() {
        if currentExerciseIndex < AssessmentExercise.allExercises.count - 1 {
            withAnimation {
                currentExerciseIndex += 1
            }
        } else {
            // Assessment complete
            completeAssessment()
        }
    }
    
    private func skipExercise() {
        // Create a failed result for skipped exercise
        let exerciseResult = ExerciseResult(exerciseName: currentExercise.name)
        exerciseResults.append(exerciseResult)
        
        nextExercise()
    }
    
    private func completeAssessment() {
        // Save assessment results
        var assessment = AssessmentResult()
        assessment.exercises = exerciseResults
        appState.currentAssessment = assessment
        
        // Move to next step
        withAnimation {
            currentStep = .healthKitIntegration
        }
    }
}

#Preview {
    MovementAssessmentView(appState: AppState(), currentStep: .constant(.movementAssessment))
} 