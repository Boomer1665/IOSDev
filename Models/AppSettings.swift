//
//  AppSettings.swift
//  HabitMate
//
//  Created by Kian Hirani on 6/5/2026.
//


import Foundation
// User configurable settings that survive between launches via JSON encoding in UserDefaults.
struct AppSettings: Codable {
    var waterGoalML: Double = 2500    // Daily water target in millilitres
    var activeStartHour: Int = 8    // Earliest hour for notification delivery
    var activeEndHour: Int = 22    // Latest hour for notification delivery
    var hasCompletedOnboarding: Bool = false    // Guards the onboarding flow
    var lastResetDateKey: String = ""    // Tracks which calendar day was last reset
}
