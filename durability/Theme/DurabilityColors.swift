import SwiftUI

// MARK: - Durability App Color Theme

struct DurabilityColors {
    // Background colors
    static let background = Color(red: 0.212, green: 0.208, blue: 0.204)
    static let secondaryBackground = Color(red: 0.157, green: 0.153, blue: 0.149)
    static let cardBackground = Color(red: 0.267, green: 0.263, blue: 0.259)
    
    // Primary accent color - Electric Green (#0bd800)
    static let primaryAccent = Color(red: 0.043, green: 0.847, blue: 0.000)
    
    // Secondary accent colors (complementary to electric green)
    static let secondaryAccent = Color(red: 0.000, green: 0.600, blue: 0.000) // Darker green
    static let tertiaryAccent = Color(red: 0.200, green: 0.800, blue: 0.200) // Lighter green
    
    // Text colors
    static let primaryText = Color.white
    static let secondaryText = Color(red: 0.800, green: 0.796, blue: 0.792)
    static let accentText = primaryAccent
    
    // Status colors
    static let success = Color(red: 0.043, green: 0.847, blue: 0.000) // Electric green
    static let warning = Color(red: 0.847, green: 0.600, blue: 0.000) // Orange-yellow
    static let error = Color(red: 0.847, green: 0.243, blue: 0.243) // Red
    static let info = primaryAccent
    
    // Progress colors
    static let progressBackground = Color(red: 0.157, green: 0.153, blue: 0.149)
    static let progressFill = primaryAccent
    
    // Chart colors (electric green palette)
    static let chartColors: [Color] = [
        primaryAccent, // Electric green
        secondaryAccent, // Darker green
        tertiaryAccent, // Lighter green
        Color(red: 0.000, green: 0.400, blue: 0.000), // Forest green
        Color(red: 0.400, green: 0.900, blue: 0.400)  // Bright green
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
        colors: [DurabilityColors.primaryAccent, DurabilityColors.secondaryAccent],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let durabilityGradientAccent = LinearGradient(
        colors: [DurabilityColors.primaryAccent, DurabilityColors.tertiaryAccent],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
} 
