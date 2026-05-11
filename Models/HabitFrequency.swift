//
//  HabitFrequency.swift
//  HabitMate
//
//  Created by Kian Hirani on 4/5/2026.
//


import Foundation
// Defines how often a habit is expected and is used for display labels and future scheduling logic.
enum HabitFrequency: String, Codable, CaseIterable {
    case daily = "Daily"
    case threeAWeek = "3x Week"
}
