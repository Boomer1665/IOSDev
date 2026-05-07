//
//  Habit.swift
//  DailyHabitTracker
//
//  Created by Kian Hirani on 7/5/2026.
//


import Foundation

struct Habit: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var frequency: HabitFrequency = .daily
    var isCompleted: Bool = false
    var streak: Int = 0
    var history: [String: Bool] = [:]
}