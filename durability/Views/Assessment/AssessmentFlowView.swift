import SwiftUI
import AVFoundation

struct AssessmentFlowView: View {
    @ObservedObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var currentExerciseIndex = 0
    @State private var showingVideoRecording = false
    @State private var showingResults = false
    @State private var assessmentResults: [ExerciseResult] = []
    @State private var isRecording = false
    @State private var recordingTime: TimeInterval = 0
    @State private var timer: Timer?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Progress indicator
                AssessmentProgressView(
                    currentIndex: currentExerciseIndex,
                    totalExercises: appState.assessmentExercises.count
                )
                .padding()
                
                if currentExerciseIndex < appState.assessmentExercises.count {
                    // Current exercise view
                    CurrentExerciseView(
                        exercise: appState.assessmentExercises[currentExerciseIndex],
                        isRecording: $isRecording,
                        recordingTime: $recordingTime,
                        onStartRecording: startRecording,
                        onStopRecording: stopRecording,
                        onSkip: skipExercise,
                        onComplete: completeExercise
                    )
                } else {
                    // Assessment complete
                    AssessmentCompleteView(
                        results: assessmentResults,
                        onViewResults: {
                            showingResults = true
                        },
                        onFinish: {
                            appState.completeAssessment()
                            dismiss()
                        }
                    )
                }
            }
            .background(Color.durabilityBackground)
            .navigationTitle("Movement Assessment")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingVideoRecording) {
            VideoRecordingView(
                exercise: appState.assessmentExercises[currentExerciseIndex],
                onComplete: { videoURL in
                    showingVideoRecording = false
                    // Handle video completion
                }
            )
        }
        .sheet(isPresented: $showingResults) {
            AssessmentResultsView(results: assessmentResults)
        }
    }
    
    private func startRecording() {
        isRecording = true
        recordingTime = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            recordingTime += 1
        }
    }
    
    private func stopRecording() {
        isRecording = false
        timer?.invalidate()
        timer = nil
        
        // Create exercise result
        let exercise = appState.assessmentExercises[currentExerciseIndex]
        var result = ExerciseResult(exerciseName: exercise.name)
        result.isCompleted = true
        result.videoURL = "demo_video_\(exercise.id)"
        
        // Add some sample metrics
        result.metrics = [
            ExerciseMetric(name: "Range of Motion", value: Double.random(in: 0.6...1.0), unit: "degrees"),
            ExerciseMetric(name: "Stability", value: Double.random(in: 0.5...0.9), unit: "score"),
            ExerciseMetric(name: "Quality", value: Double.random(in: 0.7...1.0), unit: "score")
        ]
        
        assessmentResults.append(result)
        
        // Move to next exercise
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            currentExerciseIndex += 1
        }
    }
    
    private func skipExercise() {
        let exercise = appState.assessmentExercises[currentExerciseIndex]
        var result = ExerciseResult(exerciseName: exercise.name)
        result.isCompleted = false
        result.notes = "Skipped by user"
        assessmentResults.append(result)
        
        currentExerciseIndex += 1
    }
    
    private func completeExercise() {
        // This would typically involve video analysis
        showingVideoRecording = true
    }
}

struct AssessmentProgressView: View {
    let currentIndex: Int
    let totalExercises: Int
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Exercise \(currentIndex + 1) of \(totalExercises)")
                    .font(.subheadline)
                    .foregroundColor(.durabilitySecondaryText)
                
                Spacer()
                
                Text("\(Int((Double(currentIndex) / Double(totalExercises)) * 100))%")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.durabilityPrimaryAccent)
            }
            
            ProgressView(value: Double(currentIndex), total: Double(totalExercises))
                .progressViewStyle(LinearProgressViewStyle(tint: .durabilityPrimaryAccent))
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(12)
    }
}

struct CurrentExerciseView: View {
    let exercise: AssessmentExercise
    @Binding var isRecording: Bool
    @Binding var recordingTime: TimeInterval
    let onStartRecording: () -> Void
    let onStopRecording: () -> Void
    let onSkip: () -> Void
    let onComplete: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Exercise info
                VStack(alignment: .leading, spacing: 16) {
                    Text(exercise.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.durabilityPrimaryText)
                    
                    Text(exercise.description)
                        .font(.body)
                        .foregroundColor(.durabilitySecondaryText)
                    
                    HStack(spacing: 12) {
                        DifficultyBadge(difficulty: exercise.difficulty.rawValue)
                        
                        Text(exercise.bodyPart.replacingOccurrences(of: "_", with: " ").capitalized)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.durabilitySecondaryAccent)
                    }
                }
                
                // Video placeholder
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.durabilityCardBackground)
                    .frame(height: 300)
                    .overlay(
                        VStack(spacing: 16) {
                            if isRecording {
                                VStack(spacing: 8) {
                                    Image(systemName: "record.circle.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.red)
                                    
                                    Text(timeString(from: recordingTime))
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.durabilityPrimaryText)
                                }
                            } else {
                                VStack(spacing: 12) {
                                    Image(systemName: "video.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.durabilitySecondaryText)
                                    
                                    Text("Ready to record")
                                        .font(.subheadline)
                                        .foregroundColor(.durabilitySecondaryText)
                                }
                            }
                        }
                    )
                
                // Instructions
                VStack(alignment: .leading, spacing: 12) {
                    Text("Instructions")
                        .font(.headline)
                        .foregroundColor(.durabilityPrimaryText)
                    
                    Text(exercise.instructions)
                        .font(.body)
                        .foregroundColor(.durabilitySecondaryText)
                        .lineLimit(nil)
                }
                
                // Target metrics
                VStack(alignment: .leading, spacing: 12) {
                    Text("What we're measuring")
                        .font(.headline)
                        .foregroundColor(.durabilityPrimaryText)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(exercise.targetMetrics, id: \.self) { metric in
                            Text(metric.replacingOccurrences(of: "_", with: " ").capitalized)
                                .font(.caption)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.durabilityPrimaryAccent.opacity(0.2))
                                .foregroundColor(.durabilityPrimaryAccent)
                                .cornerRadius(8)
                        }
                    }
                }
                
                // Action buttons
                VStack(spacing: 12) {
                    if isRecording {
                        Button(action: onStopRecording) {
                            HStack {
                                Image(systemName: "stop.fill")
                                Text("Stop Recording")
                            }
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.red)
                            .cornerRadius(16)
                        }
                    } else {
                        Button(action: onStartRecording) {
                            HStack {
                                Image(systemName: "record.circle")
                                Text("Start Recording")
                            }
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.durabilityPrimaryAccent)
                            .cornerRadius(16)
                        }
                    }
                    
                    Button(action: onSkip) {
                        Text("Skip Exercise")
                            .font(.subheadline)
                            .foregroundColor(.durabilitySecondaryText)
                    }
                }
            }
            .padding()
        }
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct AssessmentCompleteView: View {
    let results: [ExerciseResult]
    let onViewResults: () -> Void
    let onFinish: () -> Void
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Success icon
            VStack(spacing: 16) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.durabilityPrimaryAccent)
                
                Text("Assessment Complete!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.durabilityPrimaryText)
                
                Text("Great job! We've analyzed your movement patterns and are ready to create your personalized program.")
                    .font(.body)
                    .foregroundColor(.durabilitySecondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // Summary
            VStack(spacing: 16) {
                Text("Summary")
                    .font(.headline)
                    .foregroundColor(.durabilityPrimaryText)
                
                HStack(spacing: 24) {
                    SummaryCard(
                        title: "Completed",
                        value: "\(results.filter { $0.isCompleted }.count)",
                        total: "\(results.count)",
                        color: .durabilityPrimaryAccent
                    )
                    
                    SummaryCard(
                        title: "Skipped",
                        value: "\(results.filter { !$0.isCompleted }.count)",
                        total: "\(results.count)",
                        color: .durabilitySecondaryText
                    )
                }
            }
            
            Spacer()
            
            // Action buttons
            VStack(spacing: 12) {
                Button(action: onViewResults) {
                    Text("View Results")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.durabilityPrimaryAccent)
                        .cornerRadius(16)
                }
                
                Button(action: onFinish) {
                    Text("Continue to App")
                        .font(.subheadline)
                        .foregroundColor(.durabilitySecondaryText)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .padding()
    }
}

struct SummaryCard: View {
    let title: String
    let value: String
    let total: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.durabilitySecondaryText)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text("of \(total)")
                .font(.caption)
                .foregroundColor(.durabilitySecondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(12)
    }
}

struct VideoRecordingView: View {
    let exercise: AssessmentExercise
    let onComplete: (String) -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Video Recording")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.durabilityPrimaryText)
                
                Text("This would integrate with camera and video analysis")
                    .font(.body)
                    .foregroundColor(.durabilitySecondaryText)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Button("Complete") {
                    onComplete("demo_video_url")
                    dismiss()
                }
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.durabilityPrimaryAccent)
                .cornerRadius(16)
                .padding()
            }
            .background(Color.durabilityBackground)
            .navigationTitle("Recording")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AssessmentResultsView: View {
    let results: [ExerciseResult]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(results) { result in
                        ExerciseResultCard(result: result)
                    }
                }
                .padding()
            }
            .background(Color.durabilityBackground)
            .navigationTitle("Assessment Results")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ExerciseResultCard: View {
    let result: ExerciseResult
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(result.exerciseName)
                        .font(.headline)
                        .foregroundColor(.durabilityPrimaryText)
                    
                    Text(result.isCompleted ? "Completed" : "Skipped")
                        .font(.subheadline)
                        .foregroundColor(result.isCompleted ? .durabilityPrimaryAccent : .durabilitySecondaryText)
                }
                
                Spacer()
                
                Image(systemName: result.isCompleted ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(result.isCompleted ? .durabilityPrimaryAccent : .durabilitySecondaryText)
            }
            
            if result.isCompleted && !result.metrics.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Metrics")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.durabilityPrimaryText)
                    
                    ForEach(result.metrics) { metric in
                        HStack {
                            Text(metric.name)
                                .font(.caption)
                                .foregroundColor(.durabilitySecondaryText)
                            
                            Spacer()
                            
                            Text("\(String(format: "%.1f", metric.value)) \(metric.unit)")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(metric.isOptimal ? .durabilityPrimaryAccent : .durabilitySecondaryText)
                        }
                    }
                }
            }
            
            if let notes = result.notes {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(.durabilitySecondaryText)
                    .italic()
            }
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(12)
    }
}

#Preview {
    AssessmentFlowView(appState: AppState())
} 