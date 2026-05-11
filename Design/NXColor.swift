//
//  NXColor.swift
//  HabitMate
//
//  Created by Kian Hirani on 7/5/2026.
//


import SwiftUI
// Central colour palette in which all dark-mode greys are defined in one place so views stay consistent.
enum NXColor {
    static let bg = Color(white: 0.05)    // Near-black app background
    static let sheetBg = Color(white: 0.07)    // Slightly lighter for modal sheets
    static let surface = Color(white: 0.11)    // Card/tile background
    static let surface2 = Color(white: 0.16)    // Elevated surface (buttons, inner rows)
    static let subtle = Color(white: 0.50)    // Muted label / secondary text
}
