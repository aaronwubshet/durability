import SwiftUI

struct MainTabView: View {
    @ObservedObject var appState: AppState
    @State private var showingProfile = false
    
    var body: some View {
        TabView(selection: $appState.selectedTab) {
            MovementLibraryView()
                .tabItem {
                    Label("Library", systemImage: "list.bullet")
                }
                .tag(0)
            
                            ProgressTrackingView(appState: appState)
                .tabItem {
                    Label("Progress", systemImage: "chart.bar")
                }
                .tag(1)
            
            RecoveryModulesView(appState: appState)
                .tabItem {
                    Label("Recovery", systemImage: "heart.fill")
                }
                .tag(2)
            
            WorkoutLogView(appState: appState)
                .tabItem {
                    Label("Workout", systemImage: "figure.walk")
                }
                .tag(3)
            
            ProfileSettingsView(appState: appState)
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
                .tag(4)
        }
        .accentColor(.durabilityPrimaryAccent)
        .sheet(isPresented: $showingProfile) {
            ProfileSettingsView(appState: appState)
        }
    }
}

// MARK: - Movement Library View

struct MovementLibraryView: View {
    @State private var searchText = ""
    @State private var selectedFilter: MovementFilter = .all
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search and filter
                VStack(spacing: 16) {
                    MovementSearchBar(text: $searchText)
                    
                    MovementFilterScrollView(selectedFilter: $selectedFilter)
                }
                .padding(.horizontal)
                .padding(.top)
                
                // Movement list
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredMovements) { movement in
                            MovementCard(movement: movement)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical)
                }
            }
            .background(Color.durabilityBackground)
            .navigationTitle("Movement Library")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var filteredMovements: [Movement] {
        let movements = Movement.sampleMovements
        
        let filtered = movements.filter { movement in
            switch selectedFilter {
            case .all:
                return true
            case .upperBody:
                return movement.bodyPart == "upper_body"
            case .lowerBody:
                return movement.bodyPart == "lower_body"
            case .core:
                return movement.bodyPart == "core"
            case .mobility:
                return movement.category == "mobility"
            case .strength:
                return movement.category == "strength"
            }
        }
        
        if searchText.isEmpty {
            return filtered
        } else {
            return filtered.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

struct MovementSearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.durabilitySecondaryText)
            
            TextField("Search movements...", text: $text)
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

struct MovementFilterScrollView: View {
    @Binding var selectedFilter: MovementFilter
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(MovementFilter.allCases, id: \.self) { filter in
                    MovementFilterChip(
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

struct MovementFilterChip: View {
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

struct MovementCard: View {
    let movement: Movement
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: {
            showingDetail = true
        }) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(movement.name)
                            .font(.headline)
                            .foregroundColor(.durabilityPrimaryText)
                        
                        Text(movement.description)
                            .font(.subheadline)
                            .foregroundColor(.durabilitySecondaryText)
                            .lineLimit(2)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.durabilitySecondaryText)
                }
                
                HStack(spacing: 8) {
                    CategoryBadge(category: movement.category)
                    BodyPartBadge(bodyPart: movement.bodyPart)
                    DifficultyBadge(difficulty: movement.difficulty)
                }
            }
            .padding()
            .background(Color.durabilityCardBackground)
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            MovementDetailView(movement: movement)
        }
    }
}

struct CategoryBadge: View {
    let category: String
    
    var body: some View {
        Text(category.capitalized)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.durabilityPrimaryAccent.opacity(0.2))
            .foregroundColor(.durabilityPrimaryAccent)
            .cornerRadius(8)
    }
}

struct BodyPartBadge: View {
    let bodyPart: String
    
    var body: some View {
        Text(bodyPart.replacingOccurrences(of: "_", with: " ").capitalized)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.durabilitySecondaryAccent.opacity(0.2))
            .foregroundColor(.durabilitySecondaryAccent)
            .cornerRadius(8)
    }
}

struct DifficultyBadge: View {
    let difficulty: String
    
    var body: some View {
        Text(difficulty.capitalized)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(difficultyColor.opacity(0.2))
            .foregroundColor(difficultyColor)
            .cornerRadius(8)
    }
    
    private var difficultyColor: Color {
        switch difficulty {
        case "beginner":
            return .green
        case "intermediate":
            return .orange
        case "advanced":
            return .red
        default:
            return .durabilitySecondaryText
        }
    }
}

// MARK: - Movement Models

struct Movement: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let category: String
    let bodyPart: String
    let difficulty: String
    let instructions: String
    let videoURL: String?
}

extension Movement {
    static let sampleMovements: [Movement] = [
        Movement(
            name: "Squat",
            description: "A fundamental lower body exercise that targets multiple muscle groups",
            category: "strength",
            bodyPart: "lower_body",
            difficulty: "beginner",
            instructions: "Stand with feet shoulder-width apart, lower your body as if sitting back into a chair",
            videoURL: nil
        ),
        Movement(
            name: "Push-up",
            description: "A compound upper body exercise that builds chest, shoulder, and tricep strength",
            category: "strength",
            bodyPart: "upper_body",
            difficulty: "intermediate",
            instructions: "Start in a plank position, lower your body until your chest nearly touches the ground",
            videoURL: nil
        ),
        Movement(
            name: "Hip Mobility Flow",
            description: "A series of movements to improve hip flexibility and range of motion",
            category: "mobility",
            bodyPart: "lower_body",
            difficulty: "beginner",
            instructions: "Perform a sequence of hip circles, leg swings, and deep squats",
            videoURL: nil
        ),
        Movement(
            name: "Thoracic Extension",
            description: "Improves upper back mobility and posture",
            category: "mobility",
            bodyPart: "upper_body",
            difficulty: "beginner",
            instructions: "Sit or stand tall, gently arch your upper back while keeping your lower back stable",
            videoURL: nil
        )
    ]
}

enum MovementFilter: CaseIterable {
    case all, upperBody, lowerBody, core, mobility, strength
    
    var displayName: String {
        switch self {
        case .all:
            return "All"
        case .upperBody:
            return "Upper Body"
        case .lowerBody:
            return "Lower Body"
        case .core:
            return "Core"
        case .mobility:
            return "Mobility"
        case .strength:
            return "Strength"
        }
    }
}

// MARK: - Movement Detail View

struct MovementDetailView: View {
    let movement: Movement
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Video placeholder
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.durabilityCardBackground)
                        .frame(height: 250)
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
                    
                    // Instructions
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Instructions")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.durabilityPrimaryText)
                        
                        Text(movement.instructions)
                            .font(.body)
                            .foregroundColor(.durabilitySecondaryText)
                            .lineLimit(nil)
                    }
                    
                    // Categories
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Categories")
                            .font(.headline)
                            .foregroundColor(.durabilityPrimaryText)
                        
                        HStack(spacing: 8) {
                            CategoryBadge(category: movement.category)
                            BodyPartBadge(bodyPart: movement.bodyPart)
                            DifficultyBadge(difficulty: movement.difficulty)
                        }
                    }
                }
                .padding()
            }
            .background(Color.durabilityBackground)
            .navigationTitle(movement.name)
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

#Preview {
    MainTabView(appState: AppState())
} 