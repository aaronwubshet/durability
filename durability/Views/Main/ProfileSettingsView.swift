import SwiftUI

struct ProfileSettingsView: View {
    @ObservedObject var appState: AppState
    @State private var showingEditProfile = false
    @State private var showingReAssessment = false
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    ProfileHeaderView(user: appState.currentUser)
                    
                    // Quick Actions
                    QuickActionsSection(
                        showingEditProfile: $showingEditProfile,
                        showingReAssessment: $showingReAssessment
                    )
                    
                    // Settings
                    SettingsSection()
                    
                    // Account
                    AccountSection(showingLogoutAlert: $showingLogoutAlert)
                }
                .padding(.horizontal)
                .padding(.vertical)
            }
            .background(Color.durabilityBackground)
            .navigationTitle("Profile & Settings")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView(user: appState.currentUser)
            }
            .sheet(isPresented: $showingReAssessment) {
                ReAssessmentView()
            }
            .alert("Sign Out", isPresented: $showingLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    appState.signOut()
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
    }
}

// MARK: - Profile Header View

struct ProfileHeaderView: View {
    let user: UserProfile?
    
    var body: some View {
        VStack(spacing: 16) {
            // Profile Picture
            ZStack {
                Circle()
                    .fill(Color.durabilityPrimaryAccent)
                    .frame(width: 80, height: 80)
                
                Image(systemName: "person.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.black)
            }
            
            VStack(spacing: 4) {
                Text(user?.firstName ?? "User")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.durabilityPrimaryText)
                
                Text(user?.email ?? "user@example.com")
                    .font(.subheadline)
                    .foregroundColor(.durabilitySecondaryText)
            }
            
            // Durability Score
            if let durabilityScore = user?.durabilityScore {
                HStack(spacing: 8) {
                    Text("Durability Score:")
                        .font(.subheadline)
                        .foregroundColor(.durabilitySecondaryText)
                    
                    Text("\(Int(durabilityScore))")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.durabilityPrimaryAccent)
                }
            }
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(16)
    }
}

// MARK: - Quick Actions Section

struct QuickActionsSection: View {
    @Binding var showingEditProfile: Bool
    @Binding var showingReAssessment: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.headline)
                .foregroundColor(.durabilityPrimaryText)
            
            VStack(spacing: 12) {
                QuickActionRow(
                    icon: "person.crop.circle",
                    title: "Edit Profile",
                    subtitle: "Update your information"
                ) {
                    showingEditProfile = true
                }
                
                QuickActionRow(
                    icon: "arrow.triangle.2.circlepath",
                    title: "Re-Assess",
                    subtitle: "Take a new movement assessment"
                ) {
                    showingReAssessment = true
                }
                
                QuickActionRow(
                    icon: "chart.radar",
                    title: "View Progress",
                    subtitle: "See your fitness journey"
                ) {
                    // Navigate to progress tracking
                }
            }
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(16)
    }
}

struct QuickActionRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.durabilityPrimaryAccent)
                    .frame(width: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.durabilityPrimaryText)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.durabilitySecondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.durabilitySecondaryText)
            }
            .padding()
            .background(Color.durabilitySecondaryBackground)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Settings Section

struct SettingsSection: View {
    @State private var darkModeEnabled = true
    @State private var notificationsEnabled = true
    @State private var healthKitEnabled = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.headline)
                .foregroundColor(.durabilityPrimaryText)
            
            VStack(spacing: 12) {
                SettingsRow(
                    icon: "moon.fill",
                    title: "Dark Mode",
                    subtitle: "Use dark theme"
                ) {
                    Toggle("", isOn: $darkModeEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: .durabilityPrimaryAccent))
                }
                
                SettingsRow(
                    icon: "bell.fill",
                    title: "Notifications",
                    subtitle: "Get workout reminders"
                ) {
                    Toggle("", isOn: $notificationsEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: .durabilityPrimaryAccent))
                }
                
                SettingsRow(
                    icon: "heart.fill",
                    title: "HealthKit",
                    subtitle: "Sync with Apple Health"
                ) {
                    Toggle("", isOn: $healthKitEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: .durabilityPrimaryAccent))
                }
            }
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(16)
    }
}

struct SettingsRow<Content: View>: View {
    let icon: String
    let title: String
    let subtitle: String
    let content: Content
    
    init(icon: String, title: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.durabilityPrimaryAccent)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.durabilityPrimaryText)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.durabilitySecondaryText)
            }
            
            Spacer()
            
            content
        }
        .padding()
        .background(Color.durabilitySecondaryBackground)
        .cornerRadius(12)
    }
}

// MARK: - Account Section

struct AccountSection: View {
    @Binding var showingLogoutAlert: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Account")
                .font(.headline)
                .foregroundColor(.durabilityPrimaryText)
            
            VStack(spacing: 12) {
                AccountRow(
                    icon: "doc.text",
                    title: "Privacy Policy",
                    subtitle: "Read our privacy policy"
                ) {
                    // Show privacy policy
                }
                
                AccountRow(
                    icon: "doc.text",
                    title: "Terms of Service",
                    subtitle: "Read our terms of service"
                ) {
                    // Show terms of service
                }
                
                AccountRow(
                    icon: "questionmark.circle",
                    title: "Help & Support",
                    subtitle: "Get help with the app"
                ) {
                    // Show help and support
                }
                
                AccountRow(
                    icon: "arrow.right.square",
                    title: "Sign Out",
                    subtitle: "Sign out of your account",
                    isDestructive: true
                ) {
                    showingLogoutAlert = true
                }
            }
        }
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(16)
    }
}

struct AccountRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let isDestructive: Bool
    let action: () -> Void
    
    init(icon: String, title: String, subtitle: String, isDestructive: Bool = false, action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.isDestructive = isDestructive
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(isDestructive ? .red : .durabilityPrimaryAccent)
                    .frame(width: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(isDestructive ? .red : .durabilityPrimaryText)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.durabilitySecondaryText)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.durabilitySecondaryText)
            }
            .padding()
            .background(Color.durabilitySecondaryBackground)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Edit Profile View

struct EditProfileView: View {
    let user: UserProfile?
    @Environment(\.dismiss) private var dismiss
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var height = ""
    @State private var weight = ""
    @State private var age = ""
    @State private var selectedSex: Sex = .preferNotToSay
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Edit Profile")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.durabilityPrimaryText)
                    
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            TextField("First Name", text: $firstName)
                                .textFieldStyle(DurabilityTextFieldStyle())
                            
                            TextField("Last Name", text: $lastName)
                                .textFieldStyle(DurabilityTextFieldStyle())
                        }
                        
                        HStack(spacing: 16) {
                            TextField("Height (cm)", text: $height)
                                .textFieldStyle(DurabilityTextFieldStyle())
                                .keyboardType(.numberPad)
                            
                            TextField("Weight (kg)", text: $weight)
                                .textFieldStyle(DurabilityTextFieldStyle())
                                .keyboardType(.decimalPad)
                        }
                        
                        HStack(spacing: 16) {
                            TextField("Age", text: $age)
                                .textFieldStyle(DurabilityTextFieldStyle())
                                .keyboardType(.numberPad)
                            
                            Picker("Sex", selection: $selectedSex) {
                                ForEach(Sex.allCases, id: \.self) { sex in
                                    Text(sex.displayName).tag(sex)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.durabilityCardBackground)
                            .cornerRadius(12)
                        }
                    }
                    
                    Button("Save Changes") {
                        // Save profile changes
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
        .onAppear {
            firstName = user?.firstName ?? ""
            lastName = user?.lastName ?? ""
            if let userHeight = user?.height {
                height = String(format: "%.0f", userHeight)
            }
            if let userWeight = user?.weight {
                weight = String(format: "%.1f", userWeight)
            }
            if let userAge = user?.age {
                age = String(userAge)
            }
            selectedSex = user?.sex ?? .preferNotToSay
        }
    }
}

// MARK: - Re-Assessment View

struct ReAssessmentView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Re-Assess Your Movement")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.durabilityPrimaryText)
                
                VStack(spacing: 16) {
                    Text("Take a new movement assessment to update your durability score and get fresh recommendations.")
                        .font(.subheadline)
                        .foregroundColor(.durabilitySecondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    VStack(spacing: 12) {
                        AssessmentFeatureRow(
                            icon: "chart.radar",
                            title: "Updated Super Metrics",
                            description: "See how your fitness has changed"
                        )
                        
                        AssessmentFeatureRow(
                            icon: "arrow.triangle.2.circlepath",
                            title: "Fresh Recommendations",
                            description: "Get new personalized programming"
                        )
                        
                        AssessmentFeatureRow(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Progress Tracking",
                            description: "Compare with previous assessments"
                        )
                    }
                }
                
                Spacer()
                
                Button("Start Assessment") {
                    // Start new assessment
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

struct AssessmentFeatureRow: View {
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
        .padding()
        .background(Color.durabilityCardBackground)
        .cornerRadius(12)
    }
}

// MARK: - Sex Extension

extension Sex {
    var displayName: String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        case .other:
            return "Other"
        case .preferNotToSay:
            return "Prefer not to say"
        }
    }
}

#Preview {
    ProfileSettingsView(appState: AppState())
} 