//
//  DateHelpers.swift
//  HabitMate
//
//  Created by Kian Hirani on 7/5/2026.
//


import Foundation
// Returns the full weekday name for today, e.g. "Monday"    
func weekdayName() -> String {
    let f = DateFormatter()
    f.dateFormat = "EEEE"
    return f.string(from: Date())
}
// Returns a short formatted date for today, e.g. "May 10"
func shortDate() -> String {
    let f = DateFormatter()
    f.dateFormat = "MMM d"
    return f.string(from: Date())
}
