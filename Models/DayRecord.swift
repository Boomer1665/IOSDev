//
//  DayRecord.swift
//  DailyHabitTracker
//
//  Created by Kian Hirani on 4/5/2026.
//


import Foundation
// Immutable snapshot of a single past day, stored for analytics.
struct DayRecord: Identifiable, Codable {
    var id = UUID()
    var dateKey: String    // "yyyy-MM-dd" string identifying the day
    var completedCount: Int    // How many habits were ticked off
    var totalCount: Int    // Total habits that existed that day
    var waterML: Double    // Water consumed (ml) by end of day

    var allDone: Bool {    // True when every habit was completed
        totalCount > 0 && completedCount >= totalCount
    }
}
