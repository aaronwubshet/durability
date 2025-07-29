import SwiftUI

struct ProgressTrackingView: View {
    @ObservedObject var appState: AppState
    @State private var selectedTimeframe: Timeframe = .month
    @State private var showingAnalytics = false
    @State private var showingReAssessment = false
    @State private var reassessStep: OnboardingStep = .movementAssessment
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Durability Score Card
                    DurabilityScoreCard(score: appState.currentUser?.durabilityScore ?? 0)
                    
                    // Super Metrics Radar Chart
                    ProgressSuperMetricsRadarChart(superMetrics: appState.currentUser?.superMetrics ?? SuperMetricScores())
                    
                    // Progress History
                    ProgressHistoryView()
                    
                    // Recent Assessments
                    RecentAssessmentsView(assessments: appState.currentUser?.assessmentResults ?? [])
                    
                    // Analytics button
                    Button(action: {
                        showingAnalytics = true
                    }) {
                        HStack {
                            Image(systemName: "chart.bar.fill")
                            Text("View Detailed Analytics")
                        }
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color.durabilityPrimaryAccent)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical)
            }
            .background(Color.durabilityBackground)
            .navigationTitle("Progress Tracking")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Re-Assess") {
                        showingReAssessment = true
                    }
                    .foregroundColor(.durabilityPrimaryAccent)
                }
            }
        }
        .sheet(isPresented: $showingAnalytics) {
            AnalyticsDashboardView(appState: appState)
        }
        .sheet(isPresented: $showingReAssessment) {
            MovementAssessmentView(appState: appState, currentStep: $reassessStep)
        }
    }
}

// MARK: - Durability Score Card

struct DurabilityScoreCard: View {
    let score: Double
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Durability Score")
                        .font(.headline)
                        .foregroundColor(.durabilityPrimaryText)
                    
                    Text("Your overall fitness and injury resilience")
                        .font(.caption)
                        .foregroundColor(.durabilitySecondaryText)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(Int(score))")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.durabilityPrimaryAccent)
                    
                    Text("/ 100")
                        .font(.caption)
                        .foregroundColor(.durabilitySecondaryText)
                }
            }
            
            // Progress bar
            VStack(spacing: 8) {
                ProgressView(value: score / 100)
                    .progressViewStyle(LinearProgressViewStyle(tint: .durabilityPrimaryAccent))
                    .background(Color.durabilityCardBackground)
                    .cornerRadius(4)
                
                HStack {
                    Text(scoreDescription)
                        .font(.caption)
                        .foregroundColor(.durabilitySecondaryText)
                    
                    Spacer()
                    
                    Text("\(Int(score))%")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.durabilityPrimaryAccent)
                }
            }
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(16)
    }
    
    private var scoreDescription: String {
        switch score {
        case 80...100:
            return "Excellent"
        case 60..<80:
            return "Good"
        case 40..<60:
            return "Fair"
        default:
            return "Needs Work"
        }
    }
}

// MARK: - Super Metrics Radar Chart

struct ProgressSuperMetricsRadarChart: View {
    let superMetrics: SuperMetricScores
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Super Metrics")
                .font(.headline)
                .foregroundColor(.durabilityPrimaryText)
            
            // Simple radar chart representation
            ZStack {
                // Background circles
                ForEach(1...5, id: \.self) { level in
                    Circle()
                        .stroke(Color.durabilitySecondaryText.opacity(0.2), lineWidth: 1)
                        .frame(width: CGFloat(level * 40), height: CGFloat(level * 40))
                }
                
                // Radar chart polygon
                RadarChartPolygon(superMetrics: superMetrics)
                    .fill(Color.durabilityPrimaryAccent.opacity(0.3))
                    .stroke(Color.durabilityPrimaryAccent, lineWidth: 2)
            }
            .frame(height: 200)
            
            // Metrics legend
            VStack(spacing: 8) {
                ForEach(superMetricsArray, id: \.name) { metric in
                    HStack {
                        Circle()
                            .fill(metric.color)
                            .frame(width: 8, height: 8)
                        
                        Text(metric.name)
                            .font(.caption)
                            .foregroundColor(.durabilityPrimaryText)
                        
                        Spacer()
                        
                        Text("\(Int(metric.value * 100))%")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(metric.color)
                    }
                }
            }
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(16)
    }
    
    private var superMetricsArray: [SuperMetricItem] {
        [
            SuperMetricItem(name: "Range of Motion", value: superMetrics.rangeOfMotion, color: .durabilityPrimaryAccent),
            SuperMetricItem(name: "Flexibility", value: superMetrics.flexibility, color: .durabilitySecondaryAccent),
            SuperMetricItem(name: "Mobility", value: superMetrics.mobility, color: .durabilityTertiaryAccent),
            SuperMetricItem(name: "Functional Strength", value: superMetrics.functionalStrength, color: .orange),
            SuperMetricItem(name: "Aerobic Capacity", value: superMetrics.aerobicCapacity, color: .yellow)
        ]
    }
}

struct SuperMetricItem {
    let name: String
    let value: Double
    let color: Color
}

struct RadarChartPolygon: Shape {
    let superMetrics: SuperMetricScores
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 - 20
        
        let metrics = [
            superMetrics.rangeOfMotion,
            superMetrics.flexibility,
            superMetrics.mobility,
            superMetrics.functionalStrength,
            superMetrics.aerobicCapacity
        ]
        
        var path = Path()
        
        for (index, metric) in metrics.enumerated() {
            let angle = (2 * .pi * Double(index)) / Double(metrics.count) - .pi / 2
            let distance = radius * metric
            let point = CGPoint(
                x: center.x + distance * cos(angle),
                y: center.y + distance * sin(angle)
            )
            
            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        
        path.closeSubpath()
        return path
    }
}

// MARK: - Progress History View

struct ProgressHistoryView: View {
    @State private var selectedTimeframe: Timeframe = .month
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Progress History")
                    .font(.headline)
                    .foregroundColor(.durabilityPrimaryText)
                
                Spacer()
                
                Picker("Timeframe", selection: $selectedTimeframe) {
                    ForEach(Timeframe.allCases, id: \.self) { timeframe in
                        Text(timeframe.displayName).tag(timeframe)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 200)
            }
            
            // Chart placeholder
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.durabilityCardBackground)
                .frame(height: 200)
                .overlay(
                    VStack(spacing: 12) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 40))
                            .foregroundColor(.durabilitySecondaryText)
                        
                        Text("Progress Chart")
                            .font(.subheadline)
                            .foregroundColor(.durabilitySecondaryText)
                    }
                )
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(16)
    }
}

enum Timeframe: CaseIterable {
    case week, month, quarter, year
    
    var displayName: String {
        switch self {
        case .week:
            return "Week"
        case .month:
            return "Month"
        case .quarter:
            return "Quarter"
        case .year:
            return "Year"
        }
    }
}

// MARK: - Recent Assessments View

struct RecentAssessmentsView: View {
    let assessments: [AssessmentResult]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Assessments")
                .font(.headline)
                .foregroundColor(.durabilityPrimaryText)
            
            if assessments.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "chart.radar")
                        .font(.system(size: 40))
                        .foregroundColor(.durabilitySecondaryText)
                    
                    Text("No assessments yet")
                        .font(.subheadline)
                        .foregroundColor(.durabilitySecondaryText)
                    
                    Text("Complete your first movement assessment to see your progress")
                        .font(.caption)
                        .foregroundColor(.durabilitySecondaryText)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.durabilitySecondaryBackground)
                .cornerRadius(12)
            } else {
                VStack(spacing: 12) {
                    ForEach(assessments.prefix(3)) { assessment in
                        AssessmentRow(assessment: assessment)
                    }
                }
            }
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(16)
    }
}

struct AssessmentRow: View {
    let assessment: AssessmentResult
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Assessment #\(assessment.id.uuidString.prefix(8))")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.durabilityPrimaryText)
                
                Text(assessment.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.durabilitySecondaryText)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(Int(assessment.durabilityScore))")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.durabilityPrimaryAccent)
                
                Text("Durability Score")
                    .font(.caption)
                    .foregroundColor(.durabilitySecondaryText)
            }
        }
        .padding()
        .background(Color.durabilitySecondaryBackground)
        .cornerRadius(12)
    }
}

#Preview {
    ProgressTrackingView(appState: AppState())
} 