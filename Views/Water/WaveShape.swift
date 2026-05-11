//
//  WaveShape.swift
//  HabitMate
//
//  Created by Kian Hirani on 1/5/2026.
//


import SwiftUI

struct WaveShape: Shape {
    var fill: Double
    var progress: Double
    var phase: Double

    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(progress, phase) }
        set {
            progress = newValue.first
            phase = newValue.second
        }
    }

    func path(in rect: CGRect) -> Path {
        var p = Path()

        let w = rect.width
        let h = rect.height

        let wl: CGFloat = w / 1.3
        let wh: CGFloat = progress > 0.97 ? 2 : 7

        let yBase = h * CGFloat(1.0 - progress)

        p.move(to: CGPoint(x: 0, y: yBase))

        var x: CGFloat = 0

        while x <= w {
            let sine = sin(Double(x / wl) * 2 * .pi + phase)

            p.addLine(
                to: CGPoint(
                    x: x,
                    y: yBase + CGFloat(sine) * wh
                )
            )

            x += 1
        }

        p.addLine(to: CGPoint(x: w, y: h))
        p.addLine(to: CGPoint(x: 0, y: h))

        p.closeSubpath()

        return p
    }
}
