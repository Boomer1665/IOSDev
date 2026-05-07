//
//  AppSettings.swift
//  DailyHabitTracker
//
//  Created by Kian Hirani on 7/5/2026.
//


import Foundation

struct AppSettings: Codable {
    var waterGoalML: Double = 2500
    var activeStartHour: Int = 8
    var activeEndHour: Int = 22
    var hasCompletedOnboarding: Bool = false
    var lastResetDateKey: String = ""
}