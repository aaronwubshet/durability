import SwiftUI

struct OnboardingCompleteView: View {
    @ObservedObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Success animation and message
            VStack(spacing: 24) {
                // Success checkmark animation
                ZStack {
                    Circle()
                        .fill(Color.durabilityPrimaryAccent)
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.black)
                }
                .scaleEffect(1.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: true)
                
                VStack(spacing: 16) {
                    Text("Welcome to durability!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.durabilityPrimaryText)
                    
                    Text("Your personalized fitness journey begins now")
                        .font(.title3)
                        .foregroundColor(.durabilitySecondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            
            // What's next
            VStack(spacing: 20) {
                Text("What's next?")
                    .font(.headline)
                    .foregroundColor(.durabilityPrimaryText)
                
                VStack(spacing: 16) {
                    NextStepRow(
                        icon: "list.bullet",
                        title: "Movement Library",
                        description: "Browse exercises and build your routine"
                    )
                    
                    NextStepRow(
                        icon: "chart.bar",
                        title: "Track Progress",
                        description: "Monitor your super metrics and durability score"
                    )
                    
                    NextStepRow(
                        icon: "figure.walk",
                        title: "Start Training",
                        description: "Follow your personalized program"
                    )
                    
                    NextStepRow(
                        icon: "heart.fill",
                        title: "Recovery Programs",
                        description: "Access specialized injury recovery modules"
                    )
                }
            }
            .padding()
            .background(Color.durabilityCardBackground)
            .cornerRadius(16)
            .padding(.horizontal)
            
            Spacer()
            
            // Get started button
            Button(action: {
                completeOnboarding()
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
    
    private func completeOnboarding() {
        // Mark onboarding as complete and transition to main app
        appState.isAuthenticated = true
    }
}

struct NextStepRow: View {
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

#Preview {
    OnboardingCompleteView(appState: AppState())
} 