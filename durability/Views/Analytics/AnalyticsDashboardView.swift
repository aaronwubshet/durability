import SwiftUI
import Charts

struct AnalyticsDashboardView: View {
    @ObservedObject var appState: AppState
    @State private var selectedTimeRange: AnalyticsTimeRange = .month
    @State private var selectedMetric: AnalyticsMetric = .durabilityScore
    @State private var showingDetailedChart = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Time range selector
                    AnalyticsTimeRangeSelector(selectedRange: $selectedTimeRange)
                    
                    // Main metric card
                    MainMetricCard(
                        metric: selectedMetric,
                        value: getCurrentValue(for: selectedMetric),
                        trend: getTrend(for: selectedMetric),
                        timeRange: selectedTimeRange
                    )
                    
                    // Super metrics radar chart
                    SuperMetricsRadarChart(superMetrics: getSuperMetrics())
                    
                    // Progress charts
                    ProgressChartsView(
                        timeRange: selectedTimeRange,
                        selectedMetric: $selectedMetric,
                        appState: appState
                    )
                    
                    // Insights
                    InsightsView(insights: generateInsights())
                    
                    // Recommendations
                    RecommendationsView(recommendations: generateRecommendations())
                }
                .padding()
            }
            .background(Color.durabilityBackground)
            .navigationTitle("Analytics")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Export") {
                        // Export analytics data
                    }
                }
            }
        }
        .sheet(isPresented: $showingDetailedChart) {
            DetailedChartView(
                metric: selectedMetric,
                timeRange: selectedTimeRange,
                data: getChartData(for: selectedMetric)
            )
        }
    }
    
    private func getCurrentValue(for metric: AnalyticsMetric) -> Double {
        // Simulate data based on metric
        switch metric {
        case .durabilityScore:
            return appState.currentUser?.durabilityScore ?? 75.0
        case .rangeOfMotion:
            return (appState.currentUser?.superMetrics?.rangeOfMotion ?? 0.8) * 100
        case .flexibility:
            return (appState.currentUser?.superMetrics?.flexibility ?? 0.7) * 100
        case .mobility:
            return (appState.currentUser?.superMetrics?.mobility ?? 0.8) * 100
        case .functionalStrength:
            return (appState.currentUser?.superMetrics?.functionalStrength ?? 0.75) * 100
        case .aerobicCapacity:
            return (appState.currentUser?.superMetrics?.aerobicCapacity ?? 0.7) * 100
        }
    }
    
    private func getTrend(for metric: AnalyticsMetric) -> Double {
        // Simulate trend data
        return Double.random(in: -0.05...0.15)
    }
    
    private func getSuperMetrics() -> SuperMetricScores {
        return appState.currentUser?.superMetrics ?? SuperMetricScores()
    }
    
    private func generateInsights() -> [AnalyticsInsight] {
        return [
            AnalyticsInsight(
                title: "Improving Range of Motion",
                description: "Your shoulder mobility has increased by 12% this month. Keep up the great work!",
                type: .positive,
                icon: "arrow.up.circle.fill"
            ),
            AnalyticsInsight(
                title: "Recovery Focus Needed",
                description: "Your flexibility score has decreased slightly. Consider adding more stretching to your routine.",
                type: .warning,
                icon: "exclamationmark.triangle.fill"
            ),
            AnalyticsInsight(
                title: "Consistency Achievement",
                description: "You've completed 85% of your planned workouts this month. Excellent consistency!",
                type: .positive,
                icon: "checkmark.circle.fill"
            )
        ]
    }
    
    private func generateRecommendations() -> [AnalyticsRecommendation] {
        return [
            AnalyticsRecommendation(
                title: "Add Mobility Work",
                description: "Your thoracic mobility could improve. Try adding 10 minutes of thoracic extension exercises.",
                priority: .medium,
                category: .mobility
            ),
            AnalyticsRecommendation(
                title: "Increase Recovery Sessions",
                description: "Your recovery metrics suggest you could benefit from more active recovery sessions.",
                priority: .high,
                category: .recovery
            ),
            AnalyticsRecommendation(
                title: "Progressive Overload",
                description: "Your strength metrics are plateauing. Consider increasing resistance in your workouts.",
                priority: .medium,
                category: .strength
            )
        ]
    }
    
    private func getChartData(for metric: AnalyticsMetric) -> [ChartDataPoint] {
        guard let user = appState.currentUser else { return [] }
        
        // Use real assessment data if available
        let assessments = user.assessmentResults.sorted { $0.date < $1.date }
        
        if !assessments.isEmpty {
            return assessments.map { assessment in
                let value: Double
                switch metric {
                case .durabilityScore:
                    value = assessment.durabilityScore
                case .rangeOfMotion:
                    value = assessment.superMetrics.rangeOfMotion * 100
                case .flexibility:
                    value = assessment.superMetrics.flexibility * 100
                case .mobility:
                    value = assessment.superMetrics.mobility * 100
                case .functionalStrength:
                    value = assessment.superMetrics.functionalStrength * 100
                case .aerobicCapacity:
                    value = assessment.superMetrics.aerobicCapacity * 100
                }
                
                return ChartDataPoint(
                    date: assessment.date,
                    value: value
                )
            }
        }
        
        // Generate simulated data with proper randomization for the selected time range
        let days = selectedTimeRange.days
        return (0..<days).map { day in
            let date = Calendar.current.date(byAdding: .day, value: -day, to: Date()) ?? Date()
            let value = generateRandomValue(for: metric, date: date)
            
            return ChartDataPoint(
                date: date,
                value: value
            )
        }.reversed()
    }
    
    private func generateRandomValue(for metric: AnalyticsMetric, date: Date) -> Double {
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        let weekOfYear = calendar.component(.weekOfYear, from: date)
        let dayOfWeek = calendar.component(.weekday, from: date)
        let month = calendar.component(.month, from: date)
        let dayOfMonth = calendar.component(.day, from: date)
        
        // Create metric-specific base values and variations
        let baseValue: Double
        let variationRange: Double
        
        switch metric {
        case .durabilityScore:
            baseValue = 75.0
            variationRange = 25.0
        case .rangeOfMotion:
            baseValue = 80.0
            variationRange = 20.0
        case .flexibility:
            baseValue = 70.0
            variationRange = 30.0
        case .mobility:
            baseValue = 75.0
            variationRange = 25.0
        case .functionalStrength:
            baseValue = 65.0
            variationRange = 35.0
        case .aerobicCapacity:
            baseValue = 60.0
            variationRange = 40.0
        }
        
        // Generate completely new random patterns using multiple mathematical functions
        let dayOfYearDouble = Double(dayOfYear)
        let weekOfYearDouble = Double(weekOfYear)
        let dayOfWeekDouble = Double(dayOfWeek)
        let monthDouble = Double(month)
        let dayOfMonthDouble = Double(dayOfMonth)
        let metricSeed = Double(metric.hashValue)
        
        // Multiple random patterns combined
        let pattern1 = sin(dayOfYearDouble * 0.3 + metricSeed * 0.5) * 0.4
        let pattern2 = cos(weekOfYearDouble * 0.8 + metricSeed * 0.3) * 0.3
        let pattern3 = sin(dayOfWeekDouble * 1.2 + metricSeed * 0.7) * 0.25
        let pattern4 = cos(monthDouble * 0.6 + metricSeed * 0.2) * 0.2
        let pattern5 = sin(dayOfMonthDouble * 0.15 + metricSeed * 0.4) * 0.15
        
        // Complex combined patterns
        let complexPattern1 = sin(dayOfYearDouble * 0.15 + weekOfYearDouble * 0.4 + metricSeed) * 0.3
        let complexPattern2 = cos(dayOfYearDouble * 0.08 + monthDouble * 0.3 + metricSeed * 0.6) * 0.25
        
        // Noise pattern
        let noiseSeed = dayOfYearDouble + weekOfYearDouble * 7.0 + dayOfWeekDouble * 3.0 + monthDouble * 30.0 + metricSeed
        let noisePattern = sin(noiseSeed * 0.2) * 0.2
        
        // Combine all patterns
        let totalVariation = (pattern1 + pattern2 + pattern3 + pattern4 + pattern5 + complexPattern1 + complexPattern2 + noisePattern) * variationRange
        
        return max(0, min(100, baseValue + totalVariation))
    }
}

struct AnalyticsTimeRangeSelector: View {
    @Binding var selectedRange: AnalyticsTimeRange
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(AnalyticsTimeRange.allCases, id: \.self) { range in
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

struct MainMetricCard: View {
    let metric: AnalyticsMetric
    let value: Double
    let trend: Double
    let timeRange: AnalyticsTimeRange
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(metric.displayName)
                        .font(.headline)
                        .foregroundColor(.durabilityPrimaryText)
                    
                    Text("Last \(timeRange.displayName.lowercased())")
                        .font(.caption)
                        .foregroundColor(.durabilitySecondaryText)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(String(format: "%.1f", value))
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.durabilityPrimaryAccent)
                    
                    HStack(spacing: 4) {
                        Image(systemName: trend >= 0 ? "arrow.up" : "arrow.down")
                            .font(.caption)
                            .foregroundColor(trend >= 0 ? .green : .red)
                        
                        Text(String(format: "%.1f%%", abs(trend * 100)))
                            .font(.caption)
                            .foregroundColor(trend >= 0 ? .green : .red)
                    }
                }
            }
            
            // Mini chart
            MiniChartView(data: generateMiniChartData())
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(16)
    }
    
    private func generateMiniChartData() -> [Double] {
        return (0..<7).map { _ in Double.random(in: 60...90) }
    }
}

struct MiniChartView: View {
    let data: [Double]
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 2) {
            ForEach(Array(data.enumerated()), id: \.offset) { index, value in
                RoundedRectangle(cornerRadius: 1)
                    .fill(Color.durabilityPrimaryAccent)
                    .frame(width: 8, height: max(4, value / 10))
            }
        }
        .frame(height: 40)
    }
}

struct SuperMetricsRadarChart: View {
    let superMetrics: SuperMetricScores
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Super Metrics Overview")
                .font(.headline)
                .foregroundColor(.durabilityPrimaryText)
            
            // Simple radar chart representation
            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    MetricIndicator(name: "ROM", value: superMetrics.rangeOfMotion, color: .durabilityPrimaryAccent)
                    MetricIndicator(name: "Flex", value: superMetrics.flexibility, color: .durabilitySecondaryAccent)
                }
                
                HStack(spacing: 20) {
                    MetricIndicator(name: "Mob", value: superMetrics.mobility, color: .durabilityTertiaryAccent)
                    MetricIndicator(name: "Strength", value: superMetrics.functionalStrength, color: .orange)
                    MetricIndicator(name: "Aerobic", value: superMetrics.aerobicCapacity, color: .red)
                }
            }
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(16)
    }
}

struct MetricIndicator: View {
    let name: String
    let value: Double
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.3), lineWidth: 8)
                    .frame(width: 60, height: 60)
                
                Circle()
                    .trim(from: 0, to: value)
                    .stroke(color, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(-90))
                
                Text("\(Int(value * 100))")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.durabilityPrimaryText)
            }
            
            Text(name)
                .font(.caption)
                .foregroundColor(.durabilitySecondaryText)
        }
    }
}

struct ProgressChartsView: View {
    let timeRange: AnalyticsTimeRange
    @Binding var selectedMetric: AnalyticsMetric
    @ObservedObject var appState: AppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Progress Trends")
                .font(.headline)
                .foregroundColor(.durabilityPrimaryText)
            
            // Metric selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(AnalyticsMetric.allCases, id: \.self) { metric in
                        Button(action: {
                            selectedMetric = metric
                        }) {
                            Text(metric.displayName)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(selectedMetric == metric ? .black : .durabilityPrimaryText)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(selectedMetric == metric ? Color.durabilityPrimaryAccent : Color.durabilityCardBackground)
                                .cornerRadius(12)
                        }
                    }
                }
            }
            
            // Real chart with data
            let chartData = getChartData(for: selectedMetric)
            if !chartData.isEmpty {
                ChartView(data: chartData, metric: selectedMetric)
                    .frame(height: 200)
            } else {
                // Fallback placeholder
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.durabilityCardBackground)
                    .frame(height: 200)
                    .overlay(
                        VStack(spacing: 12) {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.system(size: 40))
                                .foregroundColor(.durabilitySecondaryText)
                            
                            Text("No data available")
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
    
    private func getChartData(for metric: AnalyticsMetric) -> [ChartDataPoint] {
        guard let user = appState.currentUser else { return [] }
        
        // Use real assessment data if available
        let assessments = user.assessmentResults.sorted { $0.date < $1.date }
        
        if !assessments.isEmpty {
            return assessments.map { assessment in
                let value: Double
                switch metric {
                case .durabilityScore:
                    value = assessment.durabilityScore
                case .rangeOfMotion:
                    value = assessment.superMetrics.rangeOfMotion * 100
                case .flexibility:
                    value = assessment.superMetrics.flexibility * 100
                case .mobility:
                    value = assessment.superMetrics.mobility * 100
                case .functionalStrength:
                    value = assessment.superMetrics.functionalStrength * 100
                case .aerobicCapacity:
                    value = assessment.superMetrics.aerobicCapacity * 100
                }
                
                return ChartDataPoint(
                    date: assessment.date,
                    value: value
                )
            }
        }
        
        // Generate simulated data for the selected time range
        let days = timeRange.days
        return (0..<days).map { day in
            let date = Calendar.current.date(byAdding: .day, value: -day, to: Date()) ?? Date()
            let value = generateRandomValue(for: metric, date: date)
            
            return ChartDataPoint(
                date: date,
                value: value
            )
        }.reversed()
    }
    
    private func generateRandomValue(for metric: AnalyticsMetric, date: Date) -> Double {
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date) ?? 1
        let weekOfYear = calendar.component(.weekOfYear, from: date)
        let dayOfWeek = calendar.component(.weekday, from: date)
        let month = calendar.component(.month, from: date)
        let dayOfMonth = calendar.component(.day, from: date)
        
        // Create metric-specific base values and variations
        let baseValue: Double
        let variationRange: Double
        
        switch metric {
        case .durabilityScore:
            baseValue = 75.0
            variationRange = 25.0
        case .rangeOfMotion:
            baseValue = 80.0
            variationRange = 20.0
        case .flexibility:
            baseValue = 70.0
            variationRange = 30.0
        case .mobility:
            baseValue = 75.0
            variationRange = 25.0
        case .functionalStrength:
            baseValue = 65.0
            variationRange = 35.0
        case .aerobicCapacity:
            baseValue = 60.0
            variationRange = 40.0
        }
        
        // Generate completely new random patterns using multiple mathematical functions
        let dayOfYearDouble = Double(dayOfYear)
        let weekOfYearDouble = Double(weekOfYear)
        let dayOfWeekDouble = Double(dayOfWeek)
        let monthDouble = Double(month)
        let dayOfMonthDouble = Double(dayOfMonth)
        let metricSeed = Double(metric.hashValue)
        
        // Multiple random patterns combined
        let pattern1 = sin(dayOfYearDouble * 0.3 + metricSeed * 0.5) * 0.4
        let pattern2 = cos(weekOfYearDouble * 0.8 + metricSeed * 0.3) * 0.3
        let pattern3 = sin(dayOfWeekDouble * 1.2 + metricSeed * 0.7) * 0.25
        let pattern4 = cos(monthDouble * 0.6 + metricSeed * 0.2) * 0.2
        let pattern5 = sin(dayOfMonthDouble * 0.15 + metricSeed * 0.4) * 0.15
        
        // Complex combined patterns
        let complexPattern1 = sin(dayOfYearDouble * 0.15 + weekOfYearDouble * 0.4 + metricSeed) * 0.3
        let complexPattern2 = cos(dayOfYearDouble * 0.08 + monthDouble * 0.3 + metricSeed * 0.6) * 0.25
        
        // Noise pattern
        let noiseSeed = dayOfYearDouble + weekOfYearDouble * 7.0 + dayOfWeekDouble * 3.0 + monthDouble * 30.0 + metricSeed
        let noisePattern = sin(noiseSeed * 0.2) * 0.2
        
        // Combine all patterns
        let totalVariation = (pattern1 + pattern2 + pattern3 + pattern4 + pattern5 + complexPattern1 + complexPattern2 + noisePattern) * variationRange
        
        return max(0, min(100, baseValue + totalVariation))
    }
}

struct ChartView: View {
    let data: [ChartDataPoint]
    let metric: AnalyticsMetric
    
    var body: some View {
        VStack(spacing: 8) {
            // Chart area
            GeometryReader { geometry in
                ZStack {
                    // Grid lines
                    ChartGridLines(geometry: geometry)
                    
                    // Chart line
                    Path { path in
                        guard !data.isEmpty else { return }
                        
                        let points = data.enumerated().map { index, point in
                            let x = geometry.size.width * Double(index) / Double(max(1, data.count - 1))
                            let y = geometry.size.height * (1 - point.value / 100.0)
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
                    ForEach(Array(data.enumerated()), id: \.offset) { index, point in
                        let x = geometry.size.width * Double(index) / Double(max(1, data.count - 1))
                        let y = geometry.size.height * (1 - point.value / 100.0)
                        
                        Circle()
                            .fill(Color.durabilityPrimaryAccent)
                            .frame(width: 6, height: 6)
                            .position(x: x, y: y)
                    }
                }
            }
            .frame(height: 160)
            .background(Color.durabilityCardBackground)
            .cornerRadius(12)
            
            // X-axis labels (dates)
            if !data.isEmpty {
                HStack {
                    ForEach(Array(data.enumerated()), id: \.offset) { index, point in
                        if index % max(1, data.count / 5) == 0 || index == data.count - 1 {
                            Text(formatDate(point.date))
                                .font(.caption2)
                                .foregroundColor(.durabilitySecondaryText)
                                .frame(maxWidth: .infinity)
                        } else {
                            Spacer()
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

struct ChartGridLines: View {
    let geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            // Horizontal grid lines
            ForEach(0..<5, id: \.self) { i in
                let y = geometry.size.height * Double(i) / 4.0
                Path { path in
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
                .stroke(Color.durabilitySecondaryText.opacity(0.2), lineWidth: 0.5)
            }
            
            // Y-axis labels
            ForEach(0..<5, id: \.self) { i in
                let y = geometry.size.height * Double(i) / 4.0
                let value = 100 - (Double(i) * 25)
                
                Text("\(Int(value))")
                    .font(.caption2)
                    .foregroundColor(.durabilitySecondaryText)
                    .position(x: 20, y: y)
            }
        }
    }
}

struct InsightsView: View {
    let insights: [AnalyticsInsight]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Insights")
                .font(.headline)
                .foregroundColor(.durabilityPrimaryText)
            
            ForEach(insights) { insight in
                InsightRow(insight: insight)
            }
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(16)
    }
}

struct InsightRow: View {
    let insight: AnalyticsInsight
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: insight.icon)
                .font(.title3)
                .foregroundColor(insight.type.color)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(insight.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.durabilityPrimaryText)
                
                Text(insight.description)
                    .font(.caption)
                    .foregroundColor(.durabilitySecondaryText)
                    .lineLimit(2)
            }
            
            Spacer()
        }
    }
}

struct RecommendationsView: View {
    let recommendations: [AnalyticsRecommendation]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recommendations")
                .font(.headline)
                .foregroundColor(.durabilityPrimaryText)
            
            ForEach(recommendations) { recommendation in
                RecommendationRow(recommendation: recommendation)
            }
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(16)
    }
}

struct RecommendationRow: View {
    let recommendation: AnalyticsRecommendation
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: recommendation.category.icon)
                .font(.title3)
                .foregroundColor(recommendation.priority.color)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(recommendation.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.durabilityPrimaryText)
                    
                    Spacer()
                    
                    Text(recommendation.priority.displayName)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(recommendation.priority.color.opacity(0.2))
                        .foregroundColor(recommendation.priority.color)
                        .cornerRadius(8)
                }
                
                Text(recommendation.description)
                    .font(.caption)
                    .foregroundColor(.durabilitySecondaryText)
                    .lineLimit(2)
            }
        }
    }
}

struct DetailedChartView: View {
    let metric: AnalyticsMetric
    let timeRange: AnalyticsTimeRange
    let data: [ChartDataPoint]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Chart
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.durabilityCardBackground)
                    .frame(height: 300)
                    .overlay(
                        VStack(spacing: 12) {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.system(size: 40))
                                .foregroundColor(.durabilitySecondaryText)
                            
                            Text("Detailed \(metric.displayName) Chart")
                                .font(.subheadline)
                                .foregroundColor(.durabilitySecondaryText)
                        }
                    )
                
                // Data points
                VStack(alignment: .leading, spacing: 12) {
                    Text("Data Points")
                        .font(.headline)
                        .foregroundColor(.durabilityPrimaryText)
                    
                    ForEach(data.prefix(5), id: \.date) { point in
                        HStack {
                            Text(point.date, style: .date)
                                .font(.caption)
                                .foregroundColor(.durabilitySecondaryText)
                            
                            Spacer()
                            
                            Text(String(format: "%.1f", point.value))
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.durabilityPrimaryAccent)
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .background(Color.durabilityBackground)
            .navigationTitle("\(metric.displayName) Details")
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

// MARK: - Data Models

enum AnalyticsTimeRange: CaseIterable {
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
    
    var days: Int {
        switch self {
        case .week:
            return 7
        case .month:
            return 30
        case .quarter:
            return 90
        case .year:
            return 365
        }
    }
}

enum AnalyticsMetric: CaseIterable {
    case durabilityScore, rangeOfMotion, flexibility, mobility, functionalStrength, aerobicCapacity
    
    var displayName: String {
        switch self {
        case .durabilityScore:
            return "Durability Score"
        case .rangeOfMotion:
            return "Range of Motion"
        case .flexibility:
            return "Flexibility"
        case .mobility:
            return "Mobility"
        case .functionalStrength:
            return "Functional Strength"
        case .aerobicCapacity:
            return "Aerobic Capacity"
        }
    }
}

struct AnalyticsInsight: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let type: InsightType
    let icon: String
}

enum InsightType {
    case positive, warning, negative
    
    var color: Color {
        switch self {
        case .positive:
            return .green
        case .warning:
            return .orange
        case .negative:
            return .red
        }
    }
}

struct AnalyticsRecommendation: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let priority: RecommendationPriority
    let category: RecommendationCategory
}

enum RecommendationPriority {
    case low, medium, high
    
    var displayName: String {
        switch self {
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        }
    }
    
    var color: Color {
        switch self {
        case .low:
            return .durabilitySecondaryText
        case .medium:
            return .orange
        case .high:
            return .red
        }
    }
}

enum RecommendationCategory {
    case mobility, strength, recovery, cardio
    
    var icon: String {
        switch self {
        case .mobility:
            return "figure.flexibility"
        case .strength:
            return "dumbbell.fill"
        case .recovery:
            return "heart.fill"
        case .cardio:
            return "heart.circle.fill"
        }
    }
}

struct ChartDataPoint {
    let date: Date
    let value: Double
}

#Preview {
    AnalyticsDashboardView(appState: AppState())
} 