//
//  WaterTankView.swift
//  HabitMate
//
//  Created by Kian Hirani on 1/5/2026.
//
import SwiftUI
import Combine

struct WaterTankView: View {
    @EnvironmentObject var store: HabitStore
    @State private var phase1: Double = 0
    @State private var phase2: Double = .pi
    private let ticker = Timer.publish(every: 0.033, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 14) {
            HStack {
                Label("Water", systemImage: "drop.fill")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(store.waterColor, .white)
                Spacer()
                Text(waterLabel)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.65))
            }

            // Tank
            ZStack {
                RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.05)).frame(height: 118)

                ZStack {
                    WaveShape(fill: 0, progress: store.waterProgress, phase: phase1)
                        .fill(store.waterColor.opacity(0.45))
                    WaveShape(fill: 0, progress: store.waterProgress, phase: phase2)
                        .fill(store.waterColor.opacity(0.25))
                }
                .frame(height: 118)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Text(String(format: "%.0f%%", store.waterProgress * 100))
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.35), radius: 6)
            }
            .onReceive(ticker) { _ in phase1 += 0.028; phase2 += 0.022 }

            HStack(spacing: 10) {
                waterBtn("+250 ml", ml: 250)
                waterBtn("+500 ml", ml: 500)
            }
        }
        .padding(18)
        .background(NXColor.surface)
        .cornerRadius(24)
    }

    private var waterLabel: String {
        "\(fmtML(store.currentWaterML)) / \(fmtML(store.settings.waterGoalML))"
    }
    private func fmtML(_ v: Double) -> String {
        v >= 1000 ? String(format: "%.1f L", v / 1000) : String(format: "%.0f ml", v)
    }

    private func waterBtn(_ label: String, ml: Double) -> some View {
        let subtitle = ml == 250 ? "≈ 1 cup" : "≈ 1 bottle"

        return Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                store.incrementWater(ml: ml)
            }
        } label: {
            VStack(spacing: 3) {
                Text(label)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                Text(subtitle)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.65))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(store.waterColor.opacity(0.18))
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(store.waterColor.opacity(0.3), lineWidth: 1)
            )
        }
    }
}
