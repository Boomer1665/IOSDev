//
//  Habit.swift
//  DailyHabitTracker
//
//  Created by Kian Hirani on 7/5/2026.
//


import Foundation
// Single habit entity that history maps date-key strings to completion booleans,
// enabling streak calculation and the 28-day grid.
struct Habit: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var frequency: HabitFrequency = .daily
    var isCompleted: Bool = false    // Todays completion state
    var streak: Int = 0    // Consecutive days completed
    var history: [String: Bool] = [:]    //  is the "yyyy-MM-dd" requirement completed?
}
