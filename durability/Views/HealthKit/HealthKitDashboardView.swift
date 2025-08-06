import SwiftUI
import HealthKit

struct HealthKitDashboardView: View {
    @ObservedObject var appState: AppState
    @State private var healthData: HealthData = HealthData()
    @State private var isAuthorized = false
    @State private var healthKitError: String? = nil
    @State private var selectedTimeRange: TimeRange = .week
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Authorization status
                    AuthorizationStatusCard(
                        isAuthorized: isAuthorized,
                        onRequestAccess: requestHealthKitAccess
                    )
                    
                    if let error = healthKitError {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    if isAuthorized {
                        // Time range selector
                        TimeRangeSelector(selectedRange: $selectedTimeRange)
                        
                        // Health metrics
                        HealthMetricsGrid(healthData: healthData, timeRange: selectedTimeRange)
                        
                        // Activity rings
                        ActivityRingsView(healthData: healthData)
                        
                        // Workout history
                        WorkoutHistoryView(healthData: healthData)
                        
                        // Sleep data
                        SleepDataView(healthData: healthData)
                        
                        // Heart rate trends
                        HeartRateTrendView(healthData: healthData)
                    }
                }
                .padding()
            }
            .background(Color.durabilityBackground)
            .navigationTitle("Health Data")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            checkHealthKitAuthorization()
        }
    }
    
    private func checkHealthKitAuthorization() {
        healthKitError = nil
        
        if HealthKitManager.shared.checkAvailability() {
            Task { @MainActor in
                do {
                    let success = try await HealthKitManager.shared.requestAuthorization()
                    self.isAuthorized = success
                    if success {
                        self.loadHealthData()
                    } else {
                        self.healthKitError = "HealthKit authorization denied."
                    }
                } catch {
                    self.healthKitError = error.localizedDescription
                }
            }
        } else {
            healthKitError = "HealthKit is not available on this device."
        }
    }
    
    private func requestHealthKitAccess() {
        checkHealthKitAuthorization()
    }
    
    private func loadHealthData() {
        // Example: Fetch steps
        Task { @MainActor in
            let steps = await HealthKitManager.shared.fetchSteps()
            healthData.steps = Int(steps)
            // TODO: Fetch other metrics using HealthKitManager
        }
    }
}

struct AuthorizationStatusCard: View {
    let isAuthorized: Bool
    let onRequestAccess: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: isAuthorized ? "heart.fill" : "heart")
                    .font(.title2)
                    .foregroundColor(isAuthorized ? .durabilityPrimaryAccent : .durabilitySecondaryText)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(isAuthorized ? "Health Data Connected" : "Connect Health Data")
                        .font(.headline)
                        .foregroundColor(.durabilityPrimaryText)
                    
                    Text(isAuthorized ? "Your health data is syncing with durability" : "Connect Apple Health to enhance your experience")
                        .font(.subheadline)
                        .foregroundColor(.durabilitySecondaryText)
                }
                
                Spacer()
            }
            
            if !isAuthorized {
                Button(action: onRequestAccess) {
                    Text("Connect Health")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color.durabilityPrimaryAccent)
                        .cornerRadius(12)
                }
            }
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(16)
    }
}

struct TimeRangeSelector: View {
    @Binding var selectedRange: TimeRange
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(TimeRange.allCases, id: \.self) { range in
                Button(action: {
                    selectedRange = range
                }) {
                    Text(range.displayName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(selectedRange == range ? .black : .durabilityPrimaryText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedRange == range ? Color.durabilityPrimaryAccent : Color.durabilityCardBackground)
                        .cornerRadius(20)
                }
            }
        }
    }
}

struct HealthMetricsGrid: View {
    let healthData: HealthData
    let timeRange: TimeRange
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
            MetricCard(
                title: "Steps",
                value: "\(healthData.steps)",
                unit: "steps",
                icon: "figure.walk",
                color: .durabilityPrimaryAccent
            )
            
            MetricCard(
                title: "Active Calories",
                value: "\(healthData.activeCalories)",
                unit: "cal",
                icon: "flame.fill",
                color: .orange
            )
            
            MetricCard(
                title: "Distance",
                value: String(format: "%.1f", healthData.distance),
                unit: "km",
                icon: "location.fill",
                color: .durabilitySecondaryAccent
            )
            
            MetricCard(
                title: "Heart Rate",
                value: "\(healthData.averageHeartRate)",
                unit: "bpm",
                icon: "heart.fill",
                color: .red
            )
        }
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.durabilityPrimaryText)
                
                Text(unit)
                    .font(.caption)
                    .foregroundColor(.durabilitySecondaryText)
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(.durabilitySecondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(16)
    }
}

struct ActivityRingsView: View {
    let healthData: HealthData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Activity Rings")
                .font(.headline)
                .foregroundColor(.durabilityPrimaryText)
            
            HStack(spacing: 20) {
                // Activity rings visualization
                ZStack {
                    // Move ring
                    Circle()
                        .stroke(Color.red.opacity(0.3), lineWidth: 8)
                        .frame(width: 80, height: 80)
                    
                    Circle()
                        .trim(from: 0, to: healthData.moveRingProgress)
                        .stroke(Color.red, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(-90))
                    
                    // Exercise ring
                    Circle()
                        .stroke(Color.green.opacity(0.3), lineWidth: 8)
                        .frame(width: 100, height: 100)
                    
                    Circle()
                        .trim(from: 0, to: healthData.exerciseRingProgress)
                        .stroke(Color.green, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(-90))
                    
                    // Stand ring
                    Circle()
                        .stroke(Color.blue.opacity(0.3), lineWidth: 8)
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .trim(from: 0, to: healthData.standRingProgress)
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 120, height: 120)
                        .rotationEffect(.degrees(-90))
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    RingLegendItem(title: "Move", color: .red, progress: healthData.moveRingProgress)
                    RingLegendItem(title: "Exercise", color: .green, progress: healthData.exerciseRingProgress)
                    RingLegendItem(title: "Stand", color: .blue, progress: healthData.standRingProgress)
                }
            }
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(16)
    }
}

struct RingLegendItem: View {
    let title: String
    let color: Color
    let progress: Double
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.durabilityPrimaryText)
            
            Spacer()
            
            Text("\(Int(progress * 100))%")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.durabilityPrimaryAccent)
        }
    }
}

struct WorkoutHistoryView: View {
    let healthData: HealthData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Workouts")
                .font(.headline)
                .foregroundColor(.durabilityPrimaryText)
            
            ForEach(healthData.recentWorkouts) { workout in
                WorkoutRow(workout: workout)
            }
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(16)
    }
}

struct WorkoutRow: View {
    let workout: Workout
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: workout.icon)
                .font(.title3)
                .foregroundColor(.durabilityPrimaryAccent)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.durabilityPrimaryText)
                
                Text(workout.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.durabilitySecondaryText)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(workout.duration) min")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.durabilityPrimaryAccent)
                
                Text("\(workout.calories) cal")
                    .font(.caption)
                    .foregroundColor(.durabilitySecondaryText)
            }
        }
        .padding(.vertical, 8)
    }
}

struct SleepDataView: View {
    let healthData: HealthData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sleep Analysis")
                .font(.headline)
                .foregroundColor(.durabilityPrimaryText)
            
            HStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text("\(healthData.sleepHours, specifier: "%.1f")")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.durabilityPrimaryAccent)
                    
                    Text("hours")
                        .font(.caption)
                        .foregroundColor(.durabilitySecondaryText)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    SleepQualityIndicator(quality: healthData.sleepQuality)
                    Text("Sleep Quality")
                        .font(.caption)
                        .foregroundColor(.durabilitySecondaryText)
                }
            }
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(16)
    }
}

struct SleepQualityIndicator: View {
    let quality: Double
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<5) { index in
                Circle()
                    .fill(index < Int(quality) ? Color.durabilityPrimaryAccent : Color.durabilitySecondaryText)
                    .frame(width: 8, height: 8)
            }
        }
    }
}

struct HeartRateTrendView: View {
    let healthData: HealthData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Heart Rate Trends")
                .font(.headline)
                .foregroundColor(.durabilityPrimaryText)
            
            // Simple heart rate chart
            HStack(alignment: .bottom, spacing: 4) {
                ForEach(healthData.heartRateData, id: \.self) { rate in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.red)
                        .frame(width: 8, height: max(4, rate / 2))
                }
            }
            .frame(height: 60)
            
            HStack {
                Text("Resting: \(healthData.restingHeartRate) bpm")
                    .font(.caption)
                    .foregroundColor(.durabilitySecondaryText)
                
                Spacer()
                
                Text("Max: \(healthData.maxHeartRate) bpm")
                    .font(.caption)
                    .foregroundColor(.durabilitySecondaryText)
            }
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(16)
    }
}

struct HealthKitAuthorizationView: View {
    let onAuthorized: () -> Void
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                Spacer()
                
                VStack(spacing: 20) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.durabilityPrimaryAccent)
                    
                    Text("Connect Apple Health")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.durabilityPrimaryText)
                    
                    Text("Connect your Apple Health data to get personalized insights and track your progress with durability.")
                        .font(.body)
                        .foregroundColor(.durabilitySecondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                VStack(spacing: 16) {
                    FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Track Progress", description: "Monitor your fitness metrics over time")
                    FeatureRow(icon: "figure.walk", title: "Activity Data", description: "Sync steps, workouts, and activity rings")
                    FeatureRow(icon: "heart.fill", title: "Health Metrics", description: "Access heart rate, sleep, and other health data")
                }
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button(action: {
                        onAuthorized()
                        dismiss()
                    }) {
                        Text("Connect Health")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.durabilityPrimaryAccent)
                            .cornerRadius(16)
                    }
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Skip for now")
                            .font(.subheadline)
                            .foregroundColor(.durabilitySecondaryText)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .background(Color.durabilityBackground)
            .navigationTitle("Health Integration")
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

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.durabilityPrimaryAccent)
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
        }
    }
}

// MARK: - Data Models

struct HealthData {
    var steps: Int = 0
    var activeCalories: Int = 0
    var distance: Double = 0.0
    var averageHeartRate: Int = 0
    var restingHeartRate: Int = 0
    var maxHeartRate: Int = 0
    var moveRingProgress: Double = 0.0
    var exerciseRingProgress: Double = 0.0
    var standRingProgress: Double = 0.0
    var sleepHours: Double = 0.0
    var sleepQuality: Double = 0.0
    var recentWorkouts: [Workout] = []
    var heartRateData: [Double] = []
    
    static let sampleData = HealthData(
        steps: 8420,
        activeCalories: 450,
        distance: 6.2,
        averageHeartRate: 72,
        restingHeartRate: 58,
        maxHeartRate: 165,
        moveRingProgress: 0.85,
        exerciseRingProgress: 0.92,
        standRingProgress: 0.78,
        sleepHours: 7.5,
        sleepQuality: 4.0,
        recentWorkouts: [
            Workout(name: "Running", icon: "figure.run", duration: 45, calories: 320, date: Date().addingTimeInterval(-86400)),
            Workout(name: "Strength Training", icon: "dumbbell.fill", duration: 60, calories: 280, date: Date().addingTimeInterval(-172800)),
            Workout(name: "Yoga", icon: "figure.mind.and.body", duration: 30, calories: 120, date: Date().addingTimeInterval(-259200))
        ],
        heartRateData: [65, 68, 72, 75, 78, 82, 85, 88, 92, 95, 98, 102, 105, 108, 112, 115, 118, 122, 125, 128, 132, 135, 138, 142, 145, 148, 152, 155, 158, 162]
    )
}

struct Workout: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let duration: Int
    let calories: Int
    let date: Date
}

enum TimeRange: CaseIterable {
    case day, week, month, year
    
    var displayName: String {
        switch self {
        case .day:
            return "Day"
        case .week:
            return "Week"
        case .month:
            return "Month"
        case .year:
            return "Year"
        }
    }
}

#Preview {
    HealthKitDashboardView(appState: AppState())
} 