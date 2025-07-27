import SwiftUI

struct RecoveryModulesView: View {
    @ObservedObject var appState: AppState
    @State private var searchText = ""
    @State private var selectedFilter: RecoveryFilter = .all
    @State private var showingModuleDetail: RecoveryModule?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search and filter
                VStack(spacing: 16) {
                    SearchBar(text: $searchText)
                    
                    FilterScrollView(selectedFilter: $selectedFilter)
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Recovery modules list
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredModules) { module in
                            RecoveryModuleCard(
                                module: module,
                                isActive: appState.activeRecoveryModule?.id == module.id,
                                progress: appState.recoveryModuleProgress[module.id] ?? 0
                            ) {
                                showingModuleDetail = module
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical)
                }
            }
            .background(Color.durabilityBackground)
            .navigationTitle("Recovery Modules")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(item: $showingModuleDetail) { module in
            RecoveryModuleDetailView(module: module, appState: appState)
        }
    }
    
    private var filteredModules: [RecoveryModule] {
        let modules = RecoveryModule.allModules
        
        let filtered = modules.filter { module in
            switch selectedFilter {
            case .all:
                return true
            case .active:
                return appState.activeRecoveryModule?.id == module.id
            case .completed:
                return appState.recoveryModuleProgress[module.id] ?? 0 >= module.durationWeeks
            case .beginner:
                return module.difficulty == .beginner
            case .intermediate:
                return module.difficulty == .intermediate
            case .advanced:
                return module.difficulty == .advanced
            }
        }
        
        if searchText.isEmpty {
            return filtered
        } else {
            return filtered.filter { module in
                module.title.localizedCaseInsensitiveContains(searchText) ||
                module.description.localizedCaseInsensitiveContains(searchText) ||
                module.recommendedFor.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
    }
}

// MARK: - Search and Filter Components

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.durabilitySecondaryText)
            
            TextField("Search recovery modules...", text: $text)
                .foregroundColor(.durabilityPrimaryText)
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.durabilitySecondaryText)
                }
            }
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(12)
    }
}

struct FilterScrollView: View {
    @Binding var selectedFilter: RecoveryFilter
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(RecoveryFilter.allCases, id: \.self) { filter in
                    FilterChip(
                        title: filter.displayName,
                        isSelected: selectedFilter == filter
                    ) {
                        selectedFilter = filter
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .black : .durabilityPrimaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.durabilityPrimaryAccent : Color.durabilityCardBackground)
                .cornerRadius(20)
        }
    }
}

struct RecoveryModuleCard: View {
    let module: RecoveryModule
    let isActive: Bool
    let progress: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(module.title)
                            .font(.headline)
                            .foregroundColor(.durabilityPrimaryText)
                        
                        Text(module.description)
                            .font(.subheadline)
                            .foregroundColor(.durabilitySecondaryText)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        if isActive {
                            Text("ACTIVE")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.durabilityPrimaryAccent)
                        }
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.durabilitySecondaryText)
                    }
                }
                
                // Progress indicator
                if isActive && progress > 0 {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Week \(progress) of \(module.durationWeeks)")
                                .font(.caption)
                                .foregroundColor(.durabilitySecondaryText)
                            
                            Spacer()
                            
                            Text("\(Int((Double(progress) / Double(module.durationWeeks)) * 100))%")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.durabilityPrimaryAccent)
                        }
                        
                        ProgressView(value: Double(progress), total: Double(module.durationWeeks))
                            .progressViewStyle(LinearProgressViewStyle(tint: .durabilityPrimaryAccent))
                    }
                }
                
                // Tags
                HStack(spacing: 8) {
                    DifficultyBadge(difficulty: module.difficulty.rawValue)
                    
                    Text("\(module.durationWeeks) weeks")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.durabilitySecondaryAccent.opacity(0.2))
                        .foregroundColor(.durabilitySecondaryAccent)
                        .cornerRadius(8)
                    
                    Text("\(module.uniqueMovementsCount) movements")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.durabilityTertiaryAccent.opacity(0.2))
                        .foregroundColor(.durabilityTertiaryAccent)
                        .cornerRadius(8)
                }
                
                // Recommended for
                if !module.recommendedFor.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Recommended for:")
                            .font(.caption)
                            .foregroundColor(.durabilitySecondaryText)
                        
                        FlowLayout(spacing: 8) {
                            ForEach(module.recommendedFor, id: \.self) { recommendation in
                                Text(recommendation)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.durabilityCardBackground)
                                    .foregroundColor(.durabilitySecondaryText)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color.durabilityCardBackground)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isActive ? Color.durabilityPrimaryAccent : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RecoveryModuleDetailView: View {
    let module: RecoveryModule
    @ObservedObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPhaseIndex = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 12) {
                        Text(module.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.durabilityPrimaryText)
                        
                        Text(module.description)
                            .font(.body)
                            .foregroundColor(.durabilitySecondaryText)
                        
                        HStack(spacing: 12) {
                            DifficultyBadge(difficulty: module.difficulty.rawValue)
                            
                            Text("\(module.durationWeeks) weeks")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.durabilitySecondaryAccent)
                            
                            Text("\(module.uniqueMovementsCount) movements")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(.durabilityTertiaryAccent)
                        }
                    }
                    
                    // Progress section
                    if appState.activeRecoveryModule?.id == module.id {
                        ProgressSection(module: module, appState: appState)
                    }
                    
                    // Phases
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Program Phases")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.durabilityPrimaryText)
                        
                        ForEach(Array(module.phases.enumerated()), id: \.element.id) { index, phase in
                            PhaseCard(
                                phase: phase,
                                isActive: isPhaseActive(index),
                                isCompleted: isPhaseCompleted(index)
                            )
                        }
                    }
                    
                    // Start/Continue button
                    if appState.activeRecoveryModule?.id != module.id {
                        Button(action: {
                            appState.startRecoveryModule(module)
                            dismiss()
                        }) {
                            Text("Start Program")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.durabilityPrimaryAccent)
                                .cornerRadius(16)
                        }
                    } else {
                        Button(action: {
                            appState.advanceRecoveryModule()
                        }) {
                            Text("Continue Program")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.durabilityPrimaryAccent)
                                .cornerRadius(16)
                        }
                    }
                }
                .padding()
            }
            .background(Color.durabilityBackground)
            .navigationTitle("Recovery Program")
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
    
    private func isPhaseActive(_ index: Int) -> Bool {
        guard let currentWeek = appState.recoveryModuleProgress[module.id] else { return false }
        var weekCount = 0
        for (i, phase) in module.phases.enumerated() {
            if i == index {
                return weekCount < currentWeek && currentWeek <= weekCount + phase.duration
            }
            weekCount += phase.duration
        }
        return false
    }
    
    private func isPhaseCompleted(_ index: Int) -> Bool {
        guard let currentWeek = appState.recoveryModuleProgress[module.id] else { return false }
        var weekCount = 0
        for (i, phase) in module.phases.enumerated() {
            if i == index {
                return currentWeek > weekCount + phase.duration
            }
            weekCount += phase.duration
        }
        return false
    }
}

struct ProgressSection: View {
    let module: RecoveryModule
    @ObservedObject var appState: AppState
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Progress")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.durabilityPrimaryText)
            
            let currentWeek = appState.recoveryModuleProgress[module.id] ?? 0
            let progressPercentage = Double(currentWeek) / Double(module.durationWeeks)
            
            VStack(spacing: 12) {
                HStack {
                    Text("Week \(currentWeek) of \(module.durationWeeks)")
                        .font(.subheadline)
                        .foregroundColor(.durabilitySecondaryText)
                    
                    Spacer()
                    
                    Text("\(Int(progressPercentage * 100))%")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.durabilityPrimaryAccent)
                }
                
                ProgressView(value: progressPercentage)
                    .progressViewStyle(LinearProgressViewStyle(tint: .durabilityPrimaryAccent))
            }
            .padding()
            .background(Color.durabilityCardBackground)
            .cornerRadius(12)
        }
    }
}

struct PhaseCard: View {
    let phase: RecoveryPhase
    let isActive: Bool
    let isCompleted: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(phase.title)
                        .font(.headline)
                        .foregroundColor(.durabilityPrimaryText)
                    
                    Text(phase.description)
                        .font(.subheadline)
                        .foregroundColor(.durabilitySecondaryText)
                }
                
                Spacer()
                
                // Status indicator
                ZStack {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 24, height: 24)
                    
                    if isCompleted {
                        Image(systemName: "checkmark")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    } else if isActive {
                        Image(systemName: "play.fill")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                }
            }
            
            // Goals
            if !phase.goals.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Goals:")
                        .font(.caption)
                        .foregroundColor(.durabilitySecondaryText)
                    
                    ForEach(phase.goals, id: \.self) { goal in
                        HStack(spacing: 8) {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 4))
                                .foregroundColor(.durabilityPrimaryAccent)
                            
                            Text(goal)
                                .font(.caption)
                                .foregroundColor(.durabilitySecondaryText)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isActive ? Color.durabilityPrimaryAccent : Color.clear, lineWidth: 2)
        )
    }
    
    private var statusColor: Color {
        if isCompleted {
            return .durabilityPrimaryAccent
        } else if isActive {
            return .durabilitySecondaryAccent
        } else {
            return .durabilitySecondaryText
        }
    }
}

enum RecoveryFilter: CaseIterable {
    case all, active, completed, beginner, intermediate, advanced
    
    var displayName: String {
        switch self {
        case .all:
            return "All"
        case .active:
            return "Active"
        case .completed:
            return "Completed"
        case .beginner:
            return "Beginner"
        case .intermediate:
            return "Intermediate"
        case .advanced:
            return "Advanced"
        }
    }
}

// MARK: - FlowLayout for tags

struct FlowLayout: Layout {
    let spacing: CGFloat
    
    init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x, y: bounds.minY + result.positions[index].y), proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        let positions: [CGPoint]
        let size: CGSize
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var positions: [CGPoint] = []
            var currentPosition = CGPoint.zero
            var lineHeight: CGFloat = 0
            var maxWidth = maxWidth
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if currentPosition.x + size.width > maxWidth && currentPosition.x > 0 {
                    currentPosition.x = 0
                    currentPosition.y += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(currentPosition)
                currentPosition.x += size.width + spacing
                lineHeight = max(lineHeight, size.height)
            }
            
            self.positions = positions
            self.size = CGSize(width: maxWidth, height: currentPosition.y + lineHeight)
        }
    }
}

#Preview {
    RecoveryModulesView(appState: AppState())
} 