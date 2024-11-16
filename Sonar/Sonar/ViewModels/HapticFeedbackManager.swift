//
//  HapticFeedbackManager.swift
//  Sonic BAT
//
//  Created by Spencer Hurd on 11/15/24.
//

import Foundation
import CoreHaptics

class HapticFeedbackManager {
    private var hapticEngine: CHHapticEngine?
    private var isHapticActive: Bool = false

    init() {
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
            print(",- Haptic engine started.")
        } catch {
            print(",- Failed to start haptic engine: \(error)")
        }
    }

    func playHapticFeedback(intensity: Float) {
        guard let hapticEngine = hapticEngine, !isHapticActive else { return }
        isHapticActive = true

        do {
            let hapticEvent = CHHapticEvent(
                eventType: .hapticContinuous,
                parameters: [
                    CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                    CHHapticEventParameter(parameterID: .hapticSharpness, value: intensity)
                ],
                relativeTime: 0,
                duration: 0.5 // Short vibration burst
            )
            let pattern = try CHHapticPattern(events: [hapticEvent], parameters: [])
            let player = try hapticEngine.makePlayer(with: pattern)
            try player.start(atTime: 0)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isHapticActive = false // Reset the flag after the burst
            }
        } catch {
            print(",- Failed to play haptic feedback: \(error)")
        }
    }

    func stopHapticFeedback() {
        isHapticActive = false
    }
}
