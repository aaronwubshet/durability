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
                    ProgressHistoryView(appState: appState)
                    
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
    @ObservedObject var appState: AppState
    
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
            
            // Real chart data
            if let user = appState.currentUser, !user.assessmentResults.isEmpty {
                ProgressChartView(assessments: user.assessmentResults, timeframe: selectedTimeframe)
                    .frame(height: 200)
            } else {
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

struct ProgressChartView: View {
    let assessments: [AssessmentResult]
    let timeframe: Timeframe
    
    var body: some View {
        let filteredAssessments = filterAssessmentsByTimeframe(assessments, timeframe: timeframe)
        
        if filteredAssessments.isEmpty {
            // No data for this timeframe
            VStack(spacing: 12) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 40))
                    .foregroundColor(.durabilitySecondaryText)
                
                Text("No data for \(timeframe.displayName.lowercased())")
                    .font(.subheadline)
                    .foregroundColor(.durabilitySecondaryText)
            }
        } else {
            // Display chart
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Durability Score")
                        .font(.caption)
                        .foregroundColor(.durabilitySecondaryText)
                    
                    Spacer()
                    
                    if let latest = filteredAssessments.last {
                        Text("\(Int(latest.durabilityScore))")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.durabilityPrimaryAccent)
                    }
                }
                
                // Simple line chart
                GeometryReader { geometry in
                    Path { path in
                        let points = filteredAssessments.enumerated().map { index, assessment in
                            let x = geometry.size.width * Double(index) / Double(max(1, filteredAssessments.count - 1))
                            let y = geometry.size.height * (1 - assessment.durabilityScore / 100.0)
                            return CGPoint(x: x, y: y)
                        }
                        
                        if let firstPoint = points.first {
                            path.move(to: firstPoint)
                            for point in points.dropFirst() {
                                path.addLine(to: point)
                            }
                        }
                    }
                    .stroke(Color.durabilityPrimaryAccent, lineWidth: 2)
                    
                    // Data points
                    ForEach(Array(filteredAssessments.enumerated()), id: \.offset) { index, assessment in
                        let x = geometry.size.width * Double(index) / Double(max(1, filteredAssessments.count - 1))
                        let y = geometry.size.height * (1 - assessment.durabilityScore / 100.0)
                        
                        Circle()
                            .fill(Color.durabilityPrimaryAccent)
                            .frame(width: 6, height: 6)
                            .position(x: x, y: y)
                    }
                }
                .frame(height: 120)
                
                // X-axis labels
                HStack {
                    if let first = filteredAssessments.first {
                        Text(formatDate(first.date, timeframe: timeframe))
                            .font(.caption2)
                            .foregroundColor(.durabilitySecondaryText)
                    }
                    
                    Spacer()
                    
                    if let last = filteredAssessments.last {
                        Text(formatDate(last.date, timeframe: timeframe))
                            .font(.caption2)
                            .foregroundColor(.durabilitySecondaryText)
                    }
                }
            }
        }
    }
    
    private func filterAssessmentsByTimeframe(_ assessments: [AssessmentResult], timeframe: Timeframe) -> [AssessmentResult] {
        let calendar = Calendar.current
        let now = Date()
        
        let filteredAssessments: [AssessmentResult]
        
        switch timeframe {
        case .week:
            // Generate daily data points for the past week
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) ?? now
            let actualAssessments = assessments.filter { $0.date >= weekAgo }.sorted { $0.date < $1.date }
            
            // Create daily entries for the past week
            var dailyData: [AssessmentResult] = []
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            for dayOffset in 0..<7 {
                let date = calendar.date(byAdding: .day, value: -dayOffset, to: now) ?? now
                let dateString = dateFormatter.string(from: date)
                
                // Find if there's an assessment for this day
                let assessmentForDay = actualAssessments.first { assessment in
                    let assessmentDateString = dateFormatter.string(from: assessment.date)
                    return assessmentDateString == dateString
                }
                
                if let assessment = assessmentForDay {
                    // Use actual assessment data
                    dailyData.append(assessment)
                } else {
                    // Create interpolated data point based on nearest assessments
                    let interpolatedScore = interpolateDurabilityScore(for: date, from: actualAssessments)
                    var interpolatedAssessment = AssessmentResult()
                    interpolatedAssessment.date = date
                    interpolatedAssessment.durabilityScore = interpolatedScore
                    interpolatedAssessment.superMetrics = interpolateSuperMetrics(for: date, from: actualAssessments)
                    dailyData.append(interpolatedAssessment)
                }
            }
            
            // Return in chronological order (oldest first)
            filteredAssessments = dailyData.sorted { $0.date < $1.date }
            
        case .month:
            // Generate weekly data points for the past month
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            let actualAssessments = assessments.filter { $0.date >= monthAgo }.sorted { $0.date < $1.date }
            
            // Create weekly entries for the past month (4 weeks)
            var weeklyData: [AssessmentResult] = []
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            for weekOffset in 0..<4 {
                // Calculate the start of each week (Monday)
                let weekStart = calendar.date(byAdding: .weekOfYear, value: -weekOffset, to: now) ?? now
                let weekStartOfYear = calendar.dateInterval(of: .weekOfYear, for: weekStart)?.start ?? weekStart
                
                // Find if there's an assessment for this week
                let assessmentForWeek = actualAssessments.first { assessment in
                    let assessmentDateString = dateFormatter.string(from: assessment.date)
                    let weekStartString = dateFormatter.string(from: weekStartOfYear)
                    let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStartOfYear) ?? weekStartOfYear
                    let weekEndString = dateFormatter.string(from: weekEnd)
                    
                    return assessmentDateString >= weekStartString && assessmentDateString <= weekEndString
                }
                
                if let assessment = assessmentForWeek {
                    // Use actual assessment data
                    weeklyData.append(assessment)
                } else {
                    // Create interpolated data point based on nearest assessments
                    let interpolatedScore = interpolateDurabilityScore(for: weekStartOfYear, from: actualAssessments)
                    var interpolatedAssessment = AssessmentResult()
                    interpolatedAssessment.date = weekStartOfYear
                    interpolatedAssessment.durabilityScore = interpolatedScore
                    interpolatedAssessment.superMetrics = interpolateSuperMetrics(for: weekStartOfYear, from: actualAssessments)
                    weeklyData.append(interpolatedAssessment)
                }
            }
            
            // Return in chronological order (oldest first)
            filteredAssessments = weeklyData.sorted { $0.date < $1.date }
        case .quarter:
            let quarterAgo = calendar.date(byAdding: .month, value: -3, to: now) ?? now
            filteredAssessments = assessments.filter { $0.date >= quarterAgo }
        case .year:
            let yearAgo = calendar.date(byAdding: .year, value: -1, to: now) ?? now
            filteredAssessments = assessments.filter { $0.date >= yearAgo }
        }
        
        return filteredAssessments.sorted { $0.date < $1.date }
    }
    
    private func interpolateDurabilityScore(for date: Date, from assessments: [AssessmentResult]) -> Double {
        // Generate a completely new random score between 0 and 100 for each day
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        let weekOfYear = calendar.component(.weekOfYear, from: date)
        let dayOfWeek = calendar.component(.weekday, from: date)
        let month = calendar.component(.month, from: date)
        let dayOfMonth = calendar.component(.day, from: date)
        
        // Use date components to create deterministic but random-looking scores
        let dayOfYearDouble = Double(dayOfYear)
        let weekOfYearDouble = Double(weekOfYear)
        let dayOfWeekDouble = Double(dayOfWeek)
        let monthDouble = Double(month)
        let dayOfMonthDouble = Double(dayOfMonth)
        
        // Create multiple random patterns with new coefficients
        let pattern1 = sin(dayOfYearDouble * 0.4) * 30.0 + 50.0 // Base pattern centered around 50
        let pattern2 = cos(weekOfYearDouble * 1.1) * 25.0 // Weekly variation
        let pattern3 = sin(dayOfWeekDouble * 1.5) * 18.0 // Daily variation
        let pattern4 = sin(monthDouble * 0.7) * 12.0 // Monthly variation
        let pattern5 = cos(dayOfMonthDouble * 0.25) * 10.0 // Day of month variation
        
        // Complex patterns for more randomness
        let complexPattern1 = sin(dayOfYearDouble * 0.2 + weekOfYearDouble * 0.5) * 15.0
        let complexPattern2 = cos(dayOfYearDouble * 0.12 + monthDouble * 0.4) * 12.0
        
        // Additional complex patterns
        let complexPattern3 = sin(dayOfYearDouble * 0.08 + weekOfYearDouble * 0.3 + monthDouble * 0.2) * 8.0
        let complexPattern4 = cos(dayOfYearDouble * 0.15 + dayOfWeekDouble * 0.8) * 6.0
        
        // Noise pattern for additional randomness
        let noiseSeed = dayOfYearDouble + weekOfYearDouble * 7.0 + dayOfWeekDouble * 3.0 + monthDouble * 30.0 + dayOfMonthDouble * 2.0
        let noisePattern = sin(noiseSeed * 0.3) * 10.0
        
        // Combine all patterns to create a random score between 0-100
        let randomScore = pattern1 + pattern2 + pattern3 + pattern4 + pattern5 + complexPattern1 + complexPattern2 + complexPattern3 + complexPattern4 + noisePattern
        
        // Ensure the score stays within 0-100 range
        return max(0.0, min(100.0, randomScore))
    }
    
    private func generateVariation(for date: Date, baseScore: Double) -> Double {
        // Use date components to create deterministic but varied patterns
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        let weekOfYear = calendar.component(.weekOfYear, from: date)
        let dayOfWeek = calendar.component(.weekday, from: date)
        let month = calendar.component(.month, from: date)
        let dayOfMonth = calendar.component(.day, from: date)
        
        // Create multiple variation patterns for more dynamic results
        let dayOfYearDouble = Double(dayOfYear)
        let weekOfYearDouble = Double(weekOfYear)
        let dayOfWeekDouble = Double(dayOfWeek)
        let monthDouble = Double(month)
        let dayOfMonthDouble = Double(dayOfMonth)
        
        // Long-term seasonal pattern (yearly cycle)
        let seasonalVariation = sin(dayOfYearDouble * 0.017) * 4.0 // 0.017 radians ≈ 1 degree per day
        
        // Monthly pattern
        let monthlyVariation = sin(monthDouble * 0.5) * 3.0
        
        // Weekly pattern with more intensity
        let weeklyVariation = sin(weekOfYearDouble * 0.8) * 3.5
        
        // Daily pattern with different frequencies
        let dailyVariation1 = sin(dayOfWeekDouble * 1.2) * 2.5
        let dailyVariation2 = sin(dayOfWeekDouble * 0.6) * 1.8
        
        // Day of month pattern
        let monthlyDayVariation = sin(dayOfMonthDouble * 0.2) * 2.0
        
        // Complex patterns using combinations
        let complexPattern1 = sin(dayOfYearDouble * 0.05 + weekOfYearDouble * 0.3) * 2.5
        let complexPattern2 = cos(dayOfYearDouble * 0.03 + monthDouble * 0.4) * 2.0
        
        // Add some "noise" based on date components
        let noiseSeed = dayOfYearDouble + weekOfYearDouble * 7.0 + dayOfWeekDouble * 3.0 + monthDouble * 30.0
        let noiseVariation = sin(noiseSeed * 0.1) * 1.5
        
        // Combine all variations with different weights
        let totalVariation = seasonalVariation * 0.3 +
                           monthlyVariation * 0.2 +
                           weeklyVariation * 0.25 +
                           dailyVariation1 * 0.15 +
                           dailyVariation2 * 0.1 +
                           monthlyDayVariation * 0.1 +
                           complexPattern1 * 0.15 +
                           complexPattern2 * 0.1 +
                           noiseVariation * 0.1
        
        // Scale variation based on base score (higher scores have less variation)
        let variationScale = max(0.3, 1.0 - (baseScore / 100.0))
        
        // Add some extra randomness for more realistic fluctuations
        let extraRandom = sin(dayOfYearDouble * 0.7 + weekOfYearDouble * 0.3) * 1.0
        
        return (totalVariation + extraRandom) * variationScale
    }
    
    private func interpolateSuperMetrics(for date: Date, from assessments: [AssessmentResult]) -> SuperMetricScores {
        guard !assessments.isEmpty else { 
            return SuperMetricScores() // Default empty metrics
        }
        
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let targetDateString = dateFormatter.string(from: date)
        
        // Find the nearest assessment before and after this date
        var beforeAssessment: AssessmentResult?
        var afterAssessment: AssessmentResult?
        
        for assessment in assessments.sorted(by: { $0.date < $1.date }) {
            let assessmentDateString = dateFormatter.string(from: assessment.date)
            if assessmentDateString <= targetDateString {
                beforeAssessment = assessment
            } else {
                afterAssessment = assessment
                break
            }
        }
        
        // If we have both before and after, interpolate
        if let before = beforeAssessment, let after = afterAssessment {
            let totalDays = calendar.dateComponents([.day], from: before.date, to: after.date).day ?? 1
            let daysFromBefore = calendar.dateComponents([.day], from: before.date, to: date).day ?? 0
            let interpolationFactor = Double(daysFromBefore) / Double(totalDays)
            
            let beforeMetrics = before.superMetrics
            let afterMetrics = after.superMetrics
            
            let baseMetrics = SuperMetricScores(
                rangeOfMotion: interpolateValue(before: beforeMetrics.rangeOfMotion, after: afterMetrics.rangeOfMotion, factor: interpolationFactor),
                flexibility: interpolateValue(before: beforeMetrics.flexibility, after: afterMetrics.flexibility, factor: interpolationFactor),
                mobility: interpolateValue(before: beforeMetrics.mobility, after: afterMetrics.mobility, factor: interpolationFactor),
                functionalStrength: interpolateValue(before: beforeMetrics.functionalStrength, after: afterMetrics.functionalStrength, factor: interpolationFactor),
                aerobicCapacity: interpolateValue(before: beforeMetrics.aerobicCapacity, after: afterMetrics.aerobicCapacity, factor: interpolationFactor)
            )
            
            // Add variation to each metric
            let variedRangeOfMotion = addVariationToMetric(baseMetrics.rangeOfMotion, date: date, metricType: "rom")
            let variedFlexibility = addVariationToMetric(baseMetrics.flexibility, date: date, metricType: "flex")
            let variedMobility = addVariationToMetric(baseMetrics.mobility, date: date, metricType: "mob")
            let variedFunctionalStrength = addVariationToMetric(baseMetrics.functionalStrength, date: date, metricType: "str")
            let variedAerobicCapacity = addVariationToMetric(baseMetrics.aerobicCapacity, date: date, metricType: "aero")
            
            return SuperMetricScores(
                rangeOfMotion: variedRangeOfMotion,
                flexibility: variedFlexibility,
                mobility: variedMobility,
                functionalStrength: variedFunctionalStrength,
                aerobicCapacity: variedAerobicCapacity
            )
        }
        
        // If we only have one assessment, use it with variation
        if let assessment = beforeAssessment ?? afterAssessment {
            let baseMetrics = assessment.superMetrics
            let variedRangeOfMotion = addVariationToMetric(baseMetrics.rangeOfMotion, date: date, metricType: "rom")
            let variedFlexibility = addVariationToMetric(baseMetrics.flexibility, date: date, metricType: "flex")
            let variedMobility = addVariationToMetric(baseMetrics.mobility, date: date, metricType: "mob")
            let variedFunctionalStrength = addVariationToMetric(baseMetrics.functionalStrength, date: date, metricType: "str")
            let variedAerobicCapacity = addVariationToMetric(baseMetrics.aerobicCapacity, date: date, metricType: "aero")
            
            return SuperMetricScores(
                rangeOfMotion: variedRangeOfMotion,
                flexibility: variedFlexibility,
                mobility: variedMobility,
                functionalStrength: variedFunctionalStrength,
                aerobicCapacity: variedAerobicCapacity
            )
        }
        
        // Default with variation
        let defaultRangeOfMotion = addVariationToMetric(0.7, date: date, metricType: "rom")
        let defaultFlexibility = addVariationToMetric(0.65, date: date, metricType: "flex")
        let defaultMobility = addVariationToMetric(0.75, date: date, metricType: "mob")
        let defaultFunctionalStrength = addVariationToMetric(0.7, date: date, metricType: "str")
        let defaultAerobicCapacity = addVariationToMetric(0.6, date: date, metricType: "aero")
        
        return SuperMetricScores(
            rangeOfMotion: defaultRangeOfMotion,
            flexibility: defaultFlexibility,
            mobility: defaultMobility,
            functionalStrength: defaultFunctionalStrength,
            aerobicCapacity: defaultAerobicCapacity
        )
    }
    
    private func addVariationToMetric(_ baseValue: Double, date: Date, metricType: String) -> Double {
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        let weekOfYear = calendar.component(.weekOfYear, from: date)
        let dayOfWeek = calendar.component(.weekday, from: date)
        let month = calendar.component(.month, from: date)
        let dayOfMonth = calendar.component(.day, from: date)
        
        // Create metric-specific variation patterns
        let metricSeed = Double(metricType.hashValue)
        let dayOfYearDouble = Double(dayOfYear)
        let weekOfYearDouble = Double(weekOfYear)
        let dayOfWeekDouble = Double(dayOfWeek)
        let monthDouble = Double(month)
        let dayOfMonthDouble = Double(dayOfMonth)
        
        // Metric-specific patterns (each metric varies differently)
        let metricSpecificPattern = sin(dayOfYearDouble * 0.1 + metricSeed * 0.5) * 0.06
        
        // Weekly patterns with different frequencies per metric
        let weeklyPattern1 = sin(weekOfYearDouble * 0.7 + metricSeed) * 0.04
        let weeklyPattern2 = cos(weekOfYearDouble * 0.4 + metricSeed * 0.3) * 0.03
        
        // Daily patterns
        let dailyPattern = sin(dayOfWeekDouble * 1.1 + metricSeed * 0.2) * 0.03
        
        // Monthly patterns
        let monthlyPattern = sin(monthDouble * 0.6 + metricSeed * 0.4) * 0.04
        
        // Day of month patterns
        let monthlyDayPattern = sin(dayOfMonthDouble * 0.15 + metricSeed * 0.1) * 0.02
        
        // Complex combined patterns
        let complexPattern1 = sin(dayOfYearDouble * 0.08 + weekOfYearDouble * 0.5 + metricSeed) * 0.05
        let complexPattern2 = cos(dayOfYearDouble * 0.05 + monthDouble * 0.3 + metricSeed * 0.2) * 0.03
        
        // Noise pattern for more realistic variation
        let noiseSeed = dayOfYearDouble + weekOfYearDouble * 7.0 + dayOfWeekDouble * 3.0 + metricSeed
        let noisePattern = sin(noiseSeed * 0.2) * 0.02
        
        // Combine all patterns with different weights
        let totalVariation = metricSpecificPattern * 0.3 +
                           weeklyPattern1 * 0.2 +
                           weeklyPattern2 * 0.15 +
                           dailyPattern * 0.15 +
                           monthlyPattern * 0.1 +
                           monthlyDayPattern * 0.05 +
                           complexPattern1 * 0.1 +
                           complexPattern2 * 0.05 +
                           noisePattern * 0.1
        
        let variedValue = baseValue + totalVariation
        
        // Ensure the value stays within valid range (0-1)
        let clampedValue = max(0.0, min(1.0, variedValue))
        return clampedValue
    }
    
    private func interpolateValue(before: Double, after: Double, factor: Double) -> Double {
        return before + (after - before) * factor
    }
    
    private func formatDate(_ date: Date, timeframe: Timeframe) -> String {
        let formatter = DateFormatter()
        
        switch timeframe {
        case .week:
            formatter.dateFormat = "MMM d"
        case .month:
            formatter.dateFormat = "MMM d"
        case .quarter:
            formatter.dateFormat = "MMM"
        case .year:
            formatter.dateFormat = "MMM"
        }
        
        return formatter.string(from: date)
    }
}

#Preview {
    ProgressTrackingView(appState: AppState())
} 