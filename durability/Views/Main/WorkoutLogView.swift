import SwiftUI

struct WorkoutLogView: View {
    @ObservedObject var appState: AppState
    @State private var showingWorkoutOptions = false
    @State private var showingLogMovement = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Quick Actions
                    QuickActionsView(
                        showingWorkoutOptions: $showingWorkoutOptions,
                        showingLogMovement: $showingLogMovement
                    )
                    
                    // Today's Plan
                    TodaysPlanView()
                    
                    // Recent Workouts
                    RecentWorkoutsView()
                    
                    // Recovery Modules
                    RecoveryModulesSection(appState: appState)
                }
                .padding(.horizontal)
                .padding(.vertical)
            }
            .background(Color.durabilityBackground)
            .navigationTitle("Workout & Log")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingWorkoutOptions) {
                WorkoutOptionsView()
            }
            .sheet(isPresented: $showingLogMovement) {
                LogMovementView()
            }
        }
    }
}

// MARK: - Quick Actions View

struct QuickActionsView: View {
    @Binding var showingWorkoutOptions: Bool
    @Binding var showingLogMovement: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Quick Actions")
                .font(.headline)
                .foregroundColor(.durabilityPrimaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 16) {
                QuickActionButton(
                    title: "Start Workout",
                    icon: "play.fill",
                    color: .durabilityPrimaryAccent
                ) {
                    showingWorkoutOptions = true
                }
                
                QuickActionButton(
                    title: "Log Movement",
                    icon: "plus.circle.fill",
                    color: .durabilitySecondaryAccent
                ) {
                    showingLogMovement = true
                }
            }
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(16)
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundColor(color)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.durabilityPrimaryText)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(Color.durabilitySecondaryBackground)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Today's Plan View

struct TodaysPlanView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Today's Plan")
                    .font(.headline)
                    .foregroundColor(.durabilityPrimaryText)
                
                Spacer()
                
                Button("Edit") {
                    // Edit today's plan
                }
                .font(.subheadline)
                .foregroundColor(.durabilityPrimaryAccent)
            }
            
            VStack(spacing: 12) {
                WorkoutPlanItem(
                    exercise: "Mobility Flow",
                    sets: "1",
                    reps: "10 min",
                    completed: true
                )
                
                WorkoutPlanItem(
                    exercise: "Squats",
                    sets: "3",
                    reps: "8-10",
                    completed: false
                )
                
                WorkoutPlanItem(
                    exercise: "Push-ups",
                    sets: "3",
                    reps: "8-12",
                    completed: false
                )
                
                WorkoutPlanItem(
                    exercise: "Hip Mobility",
                    sets: "1",
                    reps: "5 min",
                    completed: false
                )
            }
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(16)
    }
}

struct WorkoutPlanItem: View {
    let exercise: String
    let sets: String
    let reps: String
    let completed: Bool
    
    var body: some View {
        HStack {
            Button(action: {
                // Toggle completion
            }) {
                Image(systemName: completed ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(completed ? .durabilityPrimaryAccent : .durabilitySecondaryText)
                    .font(.title3)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(exercise)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(completed ? .durabilitySecondaryText : .durabilityPrimaryText)
                    .strikethrough(completed)
                
                Text("\(sets) sets × \(reps)")
                    .font(.caption)
                    .foregroundColor(.durabilitySecondaryText)
            }
            
            Spacer()
        }
    }
}

// MARK: - Recent Workouts View

struct RecentWorkoutsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Workouts")
                .font(.headline)
                .foregroundColor(.durabilityPrimaryText)
            
            VStack(spacing: 12) {
                WorkoutHistoryItem(
                    date: "Today",
                    workout: "Upper Body Strength",
                    duration: "45 min",
                    exercises: 6
                )
                
                WorkoutHistoryItem(
                    date: "Yesterday",
                    workout: "Mobility Flow",
                    duration: "20 min",
                    exercises: 4
                )
                
                WorkoutHistoryItem(
                    date: "2 days ago",
                    workout: "Lower Body Power",
                    duration: "60 min",
                    exercises: 8
                )
            }
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(16)
    }
}

struct WorkoutHistoryItem: View {
    let date: String
    let workout: String
    let duration: String
    let exercises: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(workout)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.durabilityPrimaryText)
                
                Text(date)
                    .font(.caption)
                    .foregroundColor(.durabilitySecondaryText)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(duration)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.durabilityPrimaryAccent)
                
                Text("\(exercises) exercises")
                    .font(.caption)
                    .foregroundColor(.durabilitySecondaryText)
            }
        }
        .padding()
        .background(Color.durabilitySecondaryBackground)
        .cornerRadius(12)
    }
}

// MARK: - Recovery Modules Section

struct RecoveryModulesSection: View {
    @ObservedObject var appState: AppState
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recovery Programs")
                .font(.headline)
                .foregroundColor(.durabilityPrimaryText)
            
            VStack(spacing: 12) {
                ForEach(RecoveryModule.allModules.prefix(3)) { module in
                    WorkoutRecoveryModuleCard(module: module)
                }
            }
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(16)
    }
}

struct WorkoutRecoveryModuleCard: View {
    let module: RecoveryModule
    
    var body: some View {
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
            .fontWeight(.semibold)
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

// MARK: - Workout Options View

struct WorkoutOptionsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Choose Workout Type")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.durabilityPrimaryText)
                
                VStack(spacing: 16) {
                    WorkoutOptionCard(
                        title: "Today's Plan",
                        description: "Follow your personalized program",
                        icon: "list.bullet",
                        color: .durabilityPrimaryAccent
                    )
                    
                    WorkoutOptionCard(
                        title: "Quick Workout",
                        description: "15-30 minute session",
                        icon: "bolt.fill",
                        color: .durabilitySecondaryAccent
                    )
                    
                    WorkoutOptionCard(
                        title: "Recovery Session",
                        description: "Mobility and flexibility focus",
                        icon: "heart.fill",
                        color: .durabilityTertiaryAccent
                    )
                    
                    WorkoutOptionCard(
                        title: "Custom Workout",
                        description: "Build your own session",
                        icon: "plus.circle.fill",
                        color: .orange
                    )
                }
                
                Spacer()
            }
            .padding()
            .background(Color.durabilityBackground)
            .navigationBarTitleDisplayMode(.inline)
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

struct WorkoutOptionCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    
    var body: some View {
        Button(action: {
            // Start selected workout type
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 32)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.durabilityPrimaryText)
                    
                    Text(description)
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
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Log Movement View

struct LogMovementView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMovement = ""
    @State private var sets = ""
    @State private var reps = ""
    @State private var weight = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Log Movement")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.durabilityPrimaryText)
                    
                    VStack(spacing: 16) {
                        TextField("Movement name", text: $selectedMovement)
                            .textFieldStyle(DurabilityTextFieldStyle())
                        
                        HStack(spacing: 16) {
                            TextField("Sets", text: $sets)
                                .textFieldStyle(DurabilityTextFieldStyle())
                                .keyboardType(.numberPad)
                            
                            TextField("Reps", text: $reps)
                                .textFieldStyle(DurabilityTextFieldStyle())
                                .keyboardType(.numberPad)
                        }
                        
                        TextField("Weight (optional)", text: $weight)
                            .textFieldStyle(DurabilityTextFieldStyle())
                            .keyboardType(.decimalPad)
                        
                        TextField("Notes (optional)", text: $notes, axis: .vertical)
                            .textFieldStyle(DurabilityTextFieldStyle())
                            .lineLimit(3...6)
                    }
                    
                    Button("Log Movement") {
                        // Save movement log
                        dismiss()
                    }
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.durabilityPrimaryAccent)
                    .cornerRadius(16)
                }
                .padding()
            }
            .background(Color.durabilityBackground)
            .navigationBarTitleDisplayMode(.inline)
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

#Preview {
    WorkoutLogView(appState: AppState())
} 