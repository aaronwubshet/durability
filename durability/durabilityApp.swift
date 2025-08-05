//
//  durabilityApp.swift
//  durability
//
//  Created by Aaron Wubshet on 7/27/25.
//

import SwiftUI

@main
struct durabilityApp: App {
    init() {
        // Configure navigation bar appearance for white text on dark background
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.durabilityBackground)
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        // Configure toolbar button tint color
        UINavigationBar.appearance().tintColor = UIColor(Color.durabilityPrimaryAccent)
        
        // Configure tab bar appearance for dark theme
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(Color.durabilityCardBackground)
        
        // Configure tab bar item appearance
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor(Color.durabilitySecondaryText)
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.durabilitySecondaryText)
        ]
        
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = UIColor(Color.durabilityPrimaryAccent)
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.durabilityPrimaryAccent)
        ]
        
        // Apply tab bar appearance
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
