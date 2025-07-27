//
//  ContentView.swift
//  durability
//
//  Created by Aaron Wubshet on 7/27/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState()
    
    var body: some View {
        ZStack {
            // Background
            Color.durabilityBackground
                .ignoresSafeArea()
            
            if appState.isLoading {
                // Loading state
                VStack(spacing: 24) {
                    ProgressView()
                        .scaleEffect(1.5)
                        .accentColor(.durabilityPrimaryAccent)
                    
                    Text("Loading durability...")
                        .font(.title3)
                        .foregroundColor(.durabilityPrimaryText)
                }
            } else if appState.isAuthenticated {
                // Main app
                MainTabView(appState: appState)
            } else {
                // Onboarding
                OnboardingView(appState: appState)
            }
        }
    }
}

#Preview {
    ContentView()
}
