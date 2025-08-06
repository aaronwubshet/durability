import SwiftUI

struct OnboardingView: View {
    @ObservedObject var appState: AppState
    @State private var currentStep: OnboardingStep = .welcome
    
    var body: some View {
        ZStack {
            // Background
            Color.durabilityBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress indicator
                OnboardingProgressView(currentStep: currentStep)
                    .padding(.horizontal)
                    .padding(.top)
                
                // Content
                TabView(selection: $currentStep) {
                    WelcomeView(appState: appState, currentStep: $currentStep)
                        .tag(OnboardingStep.welcome)
                    
                    AccountCreationView(appState: appState, currentStep: $currentStep)
                        .tag(OnboardingStep.accountCreation)
                    
                    ProfileSurveyView(appState: appState, currentStep: $currentStep)
                        .tag(OnboardingStep.profileSurvey)
                    
                    MovementAssessmentView(appState: appState, currentStep: $currentStep)
                        .tag(OnboardingStep.movementAssessment)
                    
                    HealthKitIntegrationView(appState: appState, currentStep: $currentStep)
                        .tag(OnboardingStep.healthKitIntegration)
                    
                    PersonalizedProgrammingView(appState: appState, currentStep: $currentStep)
                        .tag(OnboardingStep.personalizedProgramming)
                    
                    OnboardingCompleteView(appState: appState)
                        .tag(OnboardingStep.complete)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentStep)
            }
        }
        .onAppear {
            currentStep = appState.onboardingStep
        }
        .onChange(of: currentStep) { _, newStep in
            appState.onboardingStep = newStep
        }
    }
}

// MARK: - Progress Indicator

struct OnboardingProgressView: View {
    let currentStep: OnboardingStep
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                ForEach(OnboardingStep.allCases, id: \.self) { step in
                    Circle()
                        .fill(step.rawValue <= currentStep.rawValue ? Color.durabilityPrimaryAccent : Color.durabilitySecondaryText)
                        .frame(width: 8, height: 8)
                    
                    if step != OnboardingStep.allCases.last {
                        Rectangle()
                            .fill(step.rawValue < currentStep.rawValue ? Color.durabilityPrimaryAccent : Color.durabilitySecondaryText)
                            .frame(height: 2)
                    }
                }
            }
            
            Text("Step \(currentStep.rawValue + 1) of \(OnboardingStep.allCases.count)")
                .font(.caption)
                .foregroundColor(.durabilitySecondaryText)
        }
    }
}

// MARK: - Welcome View

struct WelcomeView: View {
    @ObservedObject var appState: AppState
    @Binding var currentStep: OnboardingStep
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Logo and title
            VStack(spacing: 20) {
                Image(systemName: "figure.walk")
                    .font(.system(size: 80))
                    .foregroundColor(.durabilityPrimaryAccent)
                
                Text("durability")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.durabilityPrimaryText)
                
                Text("Your personalized fitness and recovery companion")
                    .font(.title3)
                    .foregroundColor(.durabilitySecondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // Features
            VStack(spacing: 16) {
                OnboardingFeatureRow(icon: "brain.head.profile", title: "AI-Powered Assessment", description: "Get personalized insights from your movement patterns")
                OnboardingFeatureRow(icon: "chart.bar", title: "Super Metrics", description: "Track 5 key fitness dimensions with precision")
                OnboardingFeatureRow(icon: "heart.fill", title: "Recovery Focused", description: "Specialized programs for injury recovery and prevention")
                OnboardingFeatureRow(icon: "arrow.triangle.2.circlepath", title: "Adaptive Programming", description: "Your training evolves with your progress")
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Get started button
            Button(action: {
                withAnimation {
                    currentStep = .accountCreation
                }
            }) {
                Text("Get Started")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.durabilityPrimaryAccent)
                    .cornerRadius(16)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}

struct OnboardingFeatureRow: View {
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

// MARK: - Account Creation View

struct AccountCreationView: View {
    @ObservedObject var appState: AppState
    @Binding var currentStep: OnboardingStep
    @StateObject private var authManager = AuthenticationManager.shared
    @State private var email = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var password = ""
    @State private var isSignUp = true
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 16) {
                Text(isSignUp ? "Create Account" : "Sign In")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.durabilityPrimaryText)
                
                Text(isSignUp ? "Join durability to start your personalized fitness journey" : "Welcome back to durability")
                    .font(.subheadline)
                    .foregroundColor(.durabilitySecondaryText)
                    .multilineTextAlignment(.center)
            }
            
            // Apple Sign In Button
            VStack(spacing: 16) {
                Button(action: {
                    Task {
                        await authManager.signInWithApple()
                    }
                }) {
                    HStack {
                        Image(systemName: "applelogo")
                            .font(.title2)
                        
                        Text("Sign in with Apple")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.black)
                    .cornerRadius(16)
                }
                .disabled(authManager.isLoading)
                
                if authManager.isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                        .accentColor(.durabilityPrimaryAccent)
                }
                
                if let errorMessage = authManager.errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.durabilityCardBackground.opacity(0.5))
                        .cornerRadius(8)
                }
                
                // Divider
                HStack {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.durabilitySecondaryText.opacity(0.3))
                    
                    Text("or")
                        .font(.caption)
                        .foregroundColor(.durabilitySecondaryText)
                        .padding(.horizontal, 16)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.durabilitySecondaryText.opacity(0.3))
                }
            }
            
            VStack(spacing: 20) {
                if isSignUp {
                    CustomPlaceholderTextField(placeholder: "First Name", text: $firstName)
                    CustomPlaceholderTextField(placeholder: "Last Name", text: $lastName)
                }
                
                CustomPlaceholderTextField(placeholder: "Email address", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                CustomPlaceholderSecureField(placeholder: "Password", text: $password)
            }
            
            Spacer()
            
            VStack(spacing: 16) {
                Button(action: {
                    if isSignUp {
                        appState.signUp(email: email, firstName: firstName, lastName: lastName, password: password)
                    } else {
                        appState.signIn(email: email, password: password)
                    }
                    
                    withAnimation {
                        currentStep = .profileSurvey
                    }
                }) {
                    Text(isSignUp ? "Create Account" : "Sign In")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.durabilityPrimaryAccent)
                        .cornerRadius(16)
                }
                .disabled(email.isEmpty || password.isEmpty || (isSignUp && (firstName.isEmpty || lastName.isEmpty)))
                
                Button(action: {
                    withAnimation {
                        isSignUp.toggle()
                    }
                }) {
                    Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                        .font(.subheadline)
                        .foregroundColor(.durabilityPrimaryAccent)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .padding(.horizontal)
    }
    
    private func signInWithApple() async {
        await authManager.signInWithApple()
        
        // If Apple Sign In was successful, update AppState and continue
        if authManager.errorMessage == nil {
            // Create a user profile for the AppState
            let user = UserProfile(
                email: "apple.user@durability.com", // Will be updated with actual email
                firstName: "Apple",
                lastName: "User"
            )
            
            appState.currentUser = user
            appState.isAuthenticated = true
            
            // Continue to the next onboarding step
            withAnimation {
                currentStep = .profileSurvey
            }
        }
    }
}

// MARK: - Placeholder Style Modifier

struct PlaceholderStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.durabilityPrimaryAccent.opacity(0.8))
            .italic()
    }
}

extension View {
    func placeholderStyle() -> some View {
        self.modifier(PlaceholderStyle())
    }
}

// MARK: - Custom Text Field Components

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.durabilityPrimaryAccent)
                    .italic()
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
            }
            
            TextField("", text: $text)
                .padding()
                .background(Color.durabilityCardBackground)
                .cornerRadius(12)
                .foregroundColor(.durabilityPrimaryText)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.durabilitySecondaryText.opacity(0.3), lineWidth: 1)
                )
                .accentColor(.durabilityPrimaryAccent)
        }
    }
}

struct CustomSecureField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.durabilityPrimaryAccent)
                    .italic()
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
            }
            
            SecureField("", text: $text)
                .padding()
                .background(Color.durabilityCardBackground)
                .cornerRadius(12)
                .foregroundColor(.durabilityPrimaryText)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.durabilitySecondaryText.opacity(0.3), lineWidth: 1)
                )
                .accentColor(.durabilityPrimaryAccent)
        }
    }
}

// MARK: - Custom Placeholder Text Field Components

struct CustomPlaceholderTextField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.durabilityCardBackground)
            .cornerRadius(12)
            .foregroundColor(.durabilityPrimaryText)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.durabilitySecondaryText.opacity(0.3), lineWidth: 1)
            )
            .accentColor(.durabilityPrimaryAccent)
    }
}

struct CustomPlaceholderSecureField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        SecureField(placeholder, text: $text)
            .padding()
            .background(Color.durabilityCardBackground)
            .cornerRadius(12)
            .foregroundColor(.durabilityPrimaryText)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.durabilitySecondaryText.opacity(0.3), lineWidth: 1)
            )
            .accentColor(.durabilityPrimaryAccent)
    }
}

#Preview {
    OnboardingView(appState: AppState())
} 