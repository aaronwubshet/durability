import SwiftUI
import HealthKit

struct HealthKitIntegrationView: View {
    @ObservedObject var appState: AppState
    @Binding var currentStep: OnboardingStep
    
    @State private var healthKitEnabled = false
    @State private var healthKitError: String? = nil
    
    var body: some View {
        VStack(spacing: 30) {
            // Header
            VStack(spacing: 16) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.durabilityPrimaryAccent)
                
                Text("Connect Your Health Data")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.durabilityPrimaryText)
                
                Text("Get more personalized insights by connecting your existing health and fitness data")
                    .font(.subheadline)
                    .foregroundColor(.durabilitySecondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // Benefits
            VStack(spacing: 20) {
                BenefitRow(
                    icon: "heart.fill",
                    title: "Heart Rate Data",
                    description: "Track your cardiovascular fitness and recovery"
                )
                
                BenefitRow(
                    icon: "figure.walk",
                    title: "Activity Tracking",
                    description: "Monitor your daily movement and exercise patterns"
                )
                
                BenefitRow(
                    icon: "bed.double.fill",
                    title: "Sleep Analysis",
                    description: "Understand your recovery and sleep quality"
                )
                
                BenefitRow(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Progress Tracking",
                    description: "See how your fitness improves over time"
                )
            }
            .padding(.horizontal)
            
            // Privacy notice
            VStack(spacing: 12) {
                Text("Privacy & Security")
                    .font(.headline)
                    .foregroundColor(.durabilityPrimaryText)
                
                Text("Your health data is encrypted and stored securely. We only access the data you explicitly grant permission for.")
                    .font(.caption)
                    .foregroundColor(.durabilitySecondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
            .background(Color.durabilityCardBackground)
            .cornerRadius(12)
            .padding(.horizontal)
            
            Spacer()
            
            // Action buttons
            VStack(spacing: 16) {
                Button(action: {
                    requestHealthKitPermission()
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "heart.fill")
                            .font(.title3)
                        
                        Text("Connect Health Data")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.durabilityPrimaryAccent)
                    .cornerRadius(16)
                }
                
                Button(action: {
                    skipHealthKit()
                }) {
                    Text("Skip for now")
                        .font(.subheadline)
                        .foregroundColor(.durabilitySecondaryText)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            if let error = healthKitError {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .onAppear {
            // Optionally, check if already authorized
            healthKitEnabled = false
        }
    }
    
    private func requestHealthKitPermission() {
        // Reset error state
        healthKitError = nil
        
        if HealthKitManager.shared.checkAvailability() {
            HealthKitManager.shared.requestAuthorization { success, error in
                DispatchQueue.main.async {
                    if success {
                        self.healthKitEnabled = true
                        self.appState.onboardingData.healthKitEnabled = true
                        self.proceedToNextStep()
                    } else {
                        self.healthKitError = error?.localizedDescription ?? "HealthKit authorization denied."
                    }
                }
            }
        } else {
            healthKitError = "HealthKit is not available on this device."
        }
    }
    
    private func skipHealthKit() {
        healthKitEnabled = false
        appState.onboardingData.healthKitEnabled = false
        proceedToNextStep()
    }
    
    private func proceedToNextStep() {
        withAnimation {
            currentStep = .personalizedProgramming
        }
    }
}

struct BenefitRow: View {
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
    HealthKitIntegrationView(appState: AppState(), currentStep: .constant(.healthKitIntegration))
} 