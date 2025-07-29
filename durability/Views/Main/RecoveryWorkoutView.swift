import SwiftUI

struct RecoveryWorkoutView: View {
    @ObservedObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var currentExerciseIndex = 0
    @State private var showingExerciseDetail = false
    @State private var workoutNotes = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if let session = appState.currentRecoverySession,
                   let module = RecoveryModule.allModules.first(where: { $0.id == session.moduleId }),
                   let workout = session.workouts.first {
                    
                    // Header
                    WorkoutHeaderView(module: module, session: session)
                    
                    // Progress indicator
                    ProgressIndicatorView(
                        currentExercise: currentExerciseIndex + 1,
                        totalExercises: workout.exercises.count
                    )
                    
                    // Exercise list
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(Array(workout.exercises.enumerated()), id: \.element.id) { index, exercise in
                                ExerciseCardView(
                                    exercise: exercise,
                                    isActive: index == currentExerciseIndex,
                                    onTap: {
                                        currentExerciseIndex = index
                                        showingExerciseDetail = true
                                    }
                                )
                            }
                        }
                        .padding()
                    }
                    
                    // Notes section
                    NotesSectionView(notes: $workoutNotes)
                    
                    // Action buttons
                    ActionButtonsView(
                        onComplete: {
                            appState.completeRecoveryWorkout()
                            dismiss()
                        },
                        onPause: {
                            appState.pauseRecoveryWorkout()
                            dismiss()
                        }
                    )
                } else {
                    // No active session
                    NoActiveSessionView()
                }
            }
            .background(Color.durabilityBackground)
            .navigationTitle("Recovery Workout")
            .navigationBarTitleDisplayMode(.large)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Close") {
                    dismiss()
                }
            }
        }
        .sheet(isPresented: $showingExerciseDetail) {
            if let session = appState.currentRecoverySession,
               let workout = session.workouts.first,
               currentExerciseIndex < workout.exercises.count {
                ExerciseDetailView(
                    exercise: Binding(
                        get: { workout.exercises[currentExerciseIndex] },
                        set: { newValue in
                            if var session = appState.currentRecoverySession,
                               var workout = session.workouts.first {
                                workout.exercises[currentExerciseIndex] = newValue
                                session.workouts[0] = workout
                                appState.currentRecoverySession = session
                            }
                        }
                    ),
                    onComplete: {
                        showingExerciseDetail = false
                    }
                )
            }
        }
    }
}

// MARK: - Supporting Views

struct WorkoutHeaderView: View {
    let module: RecoveryModule
    let session: RecoveryWorkoutSession
    
    var body: some View {
        VStack(spacing: 16) {
            // Module info
            VStack(alignment: .leading, spacing: 8) {
                Text(module.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.durabilityPrimaryText)
                
                Text("Week \(session.weekNumber) • Phase \(session.phaseIndex + 1)")
                    .font(.subheadline)
                    .foregroundColor(.durabilitySecondaryText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Session timer
            SessionTimerView(startTime: session.startTime)
        }
        .padding()
        .background(Color.durabilityCardBackground)
    }
}

struct SessionTimerView: View {
    let startTime: Date
    @State private var elapsedTime: TimeInterval = 0
    
    var body: some View {
        HStack {
            Image(systemName: "clock")
                .foregroundColor(.durabilityPrimaryAccent)
            
            Text(timeString(from: elapsedTime))
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.durabilityPrimaryText)
            
            Spacer()
        }
        .onAppear {
            updateTimer()
        }
        .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
            updateTimer()
        }
    }
    
    private func updateTimer() {
        elapsedTime = Date().timeIntervalSince(startTime)
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60
        let seconds = Int(timeInterval) % 60
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

struct ProgressIndicatorView: View {
    let currentExercise: Int
    let totalExercises: Int
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Exercise \(currentExercise) of \(totalExercises)")
                    .font(.subheadline)
                    .foregroundColor(.durabilitySecondaryText)
                
                Spacer()
                
                Text("\(Int((Double(currentExercise) / Double(totalExercises)) * 100))%")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.durabilityPrimaryAccent)
            }
            
            ProgressView(value: Double(currentExercise), total: Double(totalExercises))
                .progressViewStyle(LinearProgressViewStyle(tint: .durabilityPrimaryAccent))
        }
        .padding(.horizontal)
        .padding(.top)
    }
}

struct ExerciseCardView: View {
    let exercise: RecoveryExercise
    let isActive: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(exercise.name)
                            .font(.headline)
                            .foregroundColor(.durabilityPrimaryText)
                        
                        Spacer()
                        
                        if exercise.isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.durabilityPrimaryAccent)
                        } else if isActive {
                            Image(systemName: "play.circle.fill")
                                .foregroundColor(.durabilitySecondaryAccent)
                        }
                    }
                    
                    Text("\(exercise.sets.count) sets")
                        .font(.subheadline)
                        .foregroundColor(.durabilitySecondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.durabilitySecondaryText)
            }
            .padding()
            .background(Color.durabilityCardBackground)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isActive ? Color.durabilityPrimaryAccent : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct NotesSectionView: View {
    @Binding var notes: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Workout Notes")
                .font(.headline)
                .foregroundColor(.durabilityPrimaryText)
            
            TextField("Add notes about your workout...", text: $notes, axis: .vertical)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .lineLimit(3...6)
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

struct ActionButtonsView: View {
    let onComplete: () -> Void
    let onPause: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Button(action: onComplete) {
                Text("Complete Workout")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.durabilityPrimaryAccent)
                    .cornerRadius(16)
            }
            
            Button(action: onPause) {
                Text("Pause & Save")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.durabilityPrimaryText)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.durabilityCardBackground)
                    .cornerRadius(16)
            }
        }
        .padding()
    }
}

struct NoActiveSessionView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "figure.walk")
                .font(.system(size: 64))
                .foregroundColor(.durabilitySecondaryText)
            
            VStack(spacing: 12) {
                Text("No Active Workout")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.durabilityPrimaryText)
                
                Text("Start a recovery module to begin tracking your workout.")
                    .font(.body)
                    .foregroundColor(.durabilitySecondaryText)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }
}

// MARK: - Exercise Detail View

struct ExerciseDetailView: View {
    @Binding var exercise: RecoveryExercise
    let onComplete: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var exerciseNotes = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Exercise header
                    VStack(alignment: .leading, spacing: 12) {
                        Text(exercise.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.durabilityPrimaryText)
                        
                        Text("Complete all sets to finish this exercise")
                            .font(.subheadline)
                            .foregroundColor(.durabilitySecondaryText)
                    }
                    
                    // Sets
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Sets")
                            .font(.headline)
                            .foregroundColor(.durabilityPrimaryText)
                        
                        ForEach(Array(exercise.sets.enumerated()), id: \.element.id) { index, set in
                            SetRowView(
                                set: $exercise.sets[index],
                                setNumber: index + 1
                            )
                        }
                    }
                    
                    // Notes
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Exercise Notes")
                            .font(.headline)
                            .foregroundColor(.durabilityPrimaryText)
                        
                        TextField("Add notes about this exercise...", text: $exerciseNotes, axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .lineLimit(3...6)
                    }
                    
                    // Complete button
                    Button(action: {
                        exercise.isCompleted = true
                        exercise.notes = exerciseNotes
                        onComplete()
                        dismiss()
                    }) {
                        Text("Complete Exercise")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.durabilityPrimaryAccent)
                            .cornerRadius(16)
                    }
                    .disabled(!exercise.sets.allSatisfy { $0.isCompleted })
                }
                .padding()
            }
            .background(Color.durabilityBackground)
            .navigationTitle("Exercise")
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

struct SetRowView: View {
    @Binding var set: RecoverySet
    let setNumber: Int
    
    var body: some View {
        HStack {
            Text("Set \(setNumber)")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.durabilityPrimaryText)
                .frame(width: 60, alignment: .leading)
            
            // Reps
            HStack {
                Text("Reps:")
                    .font(.caption)
                    .foregroundColor(.durabilitySecondaryText)
                
                TextField("0", value: $set.reps, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 60)
            }
            
            // Weight
            HStack {
                Text("Weight:")
                    .font(.caption)
                    .foregroundColor(.durabilitySecondaryText)
                
                TextField("0", value: $set.weight, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 60)
            }
            
            // Duration
            HStack {
                Text("Time:")
                    .font(.caption)
                    .foregroundColor(.durabilitySecondaryText)
                
                TextField("0", value: $set.duration, format: .number)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 60)
            }
            
            Spacer()
            
            // Complete checkbox
            Button(action: {
                set.isCompleted.toggle()
            }) {
                Image(systemName: set.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(set.isCompleted ? .durabilityPrimaryAccent : .durabilitySecondaryText)
                    .font(.title2)
            }
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(12)
    }
}

#Preview {
    RecoveryWorkoutView(appState: AppState())
} 