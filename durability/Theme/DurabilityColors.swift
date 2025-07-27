import SwiftUI

// MARK: - Durability App Color Theme

struct DurabilityColors {
    // Background colors
    static let background = Color.black
    static let secondaryBackground = Color(red: 0.1, green: 0.1, blue: 0.1)
    static let cardBackground = Color(red: 0.15, green: 0.15, blue: 0.15)
    
    // Electric colors
    static let electricGreen = Color(red: 0.0, green: 1.0, blue: 0.5)
    static let electricBlue = Color(red: 0.0, green: 0.8, blue: 1.0)
    static let electricPurple = Color(red: 0.8, green: 0.0, blue: 1.0)
    
    // Accent colors
    static let primaryAccent = electricGreen
    static let secondaryAccent = electricBlue
    static let tertiaryAccent = electricPurple
    
    // Text colors
    static let primaryText = Color.white
    static let secondaryText = Color.gray
    static let accentText = electricGreen
    
    // Status colors
    static let success = electricGreen
    static let warning = Color.orange
    static let error = Color.red
    static let info = electricBlue
    
    // Progress colors
    static let progressBackground = Color(red: 0.2, green: 0.2, blue: 0.2)
    static let progressFill = electricGreen
    
    // Chart colors
    static let chartColors: [Color] = [
        electricGreen,
        electricBlue,
        electricPurple,
        Color.orange,
        Color.yellow
    ]
}

// MARK: - Color Extensions

extension Color {
    static let durabilityBackground = DurabilityColors.background
    static let durabilitySecondaryBackground = DurabilityColors.secondaryBackground
    static let durabilityCardBackground = DurabilityColors.cardBackground
    static let durabilityPrimaryAccent = DurabilityColors.primaryAccent
    static let durabilitySecondaryAccent = DurabilityColors.secondaryAccent
    static let durabilityTertiaryAccent = DurabilityColors.tertiaryAccent
    static let durabilityPrimaryText = DurabilityColors.primaryText
    static let durabilitySecondaryText = DurabilityColors.secondaryText
    static let durabilityAccentText = DurabilityColors.accentText
}

// MARK: - Gradient Extensions

extension LinearGradient {
    static let durabilityGradient = LinearGradient(
        colors: [DurabilityColors.electricGreen, DurabilityColors.electricBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let durabilityGradientPurple = LinearGradient(
        colors: [DurabilityColors.electricPurple, DurabilityColors.electricBlue],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
} 