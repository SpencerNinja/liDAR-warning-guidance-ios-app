//
//  ProximitySensorViewModel.swift
//  Sonar
//
//  Created by Spencer Hurd on 11/15/24.
//

import Foundation
import Combine
import UIKit
import ARKit
import AVFoundation
import CoreHaptics

class ProximitySensorViewModel: ObservableObject {
    
    @Published var distance: Float = .greatestFiniteMagnitude
    @Published var warningDistance: Float = 2.0
    private let lidarManager = LiDARManager()
    private let audioManager = AudioFeedbackManager()
    private let hapticManager = HapticFeedbackManager()
    
    @Published var sonarIsActive: Bool = false
    
    @Published var currentSettingsPage: Int = 0
    
    @Published var proximityBeepsAreEnabled: Bool = true
    @Published var proximityHapticsAreEnabled: Bool = true
    @Published var vocalInstructionsAreEnabled: Bool = true
    
    init() {
        lidarManager.onDistanceUpdate = { [weak self] distance in
            DispatchQueue.main.async {
                self?.distance = distance
                self?.handleAudioHapticFeedback(for: distance)
            }
        }
    }
    
    func startMonitoring() {
        let configuration = ARWorldTrackingConfiguration()
        lidarManager.startSession(with: configuration)
        print("startMonitoring(),- LiDAR monitoring started.")
    }
    
    func stopMonitoring() {
        // Stop audio and haptic feedback
        audioManager.stopTone()
        hapticManager.stopHapticFeedback()
        
        // Stop receiving distance updates
        lidarManager.onDistanceUpdate = nil
        
        // Pause the LiDAR session
        lidarManager.stopSession()
        
        // Reset the distance to an initial state
        distance = .greatestFiniteMagnitude
        
        // Update state to reflect that the sonar is no longer active
        print("stopMonitoring(),- LiDAR monitoring stopped.")
    }

    private func handleAudioHapticFeedback(for distance: Float) {
        // Ensure sonar is active before handling feedback
        guard sonarIsActive else {
            audioManager.stopTone()
            hapticManager.stopHapticFeedback()
            return
        }

        let distanceInFeet = distance * 3.28084

        if distanceInFeet < warningDistance {
            if proximityBeepsAreEnabled {
                // Audio feedback (closer = louder)
                let normalizedVolume = max(0.1, min(1.0, 1.0 - (distanceInFeet / warningDistance))) // Volume: 0.1 to 1.0
                audioManager.playTone(frequency: 440, volume: normalizedVolume) // A4 tone (440 Hz)
                print("handleAudioHapticFeedback(),- Playing audio feedback for distance: \(distanceInFeet) feet.")
            }

            if proximityHapticsAreEnabled {
                // Haptic feedback (closer = stronger vibration)
                let intensity = Float(1.0 - (distanceInFeet / warningDistance))
                hapticManager.playHapticFeedback(intensity: intensity)
                print("handleAudioHapticFeedback(),- Playing haptic feedback for distance: \(distanceInFeet) feet.")
            }

        } else {
            if proximityBeepsAreEnabled {
                audioManager.stopTone()
                print("handleAudioHapticFeedback(),- Stopping audio feedback.")
            }
            if proximityHapticsAreEnabled {
                hapticManager.stopHapticFeedback()
                print("handleAudioHapticFeedback(),- Stopping haptic feedback.")
            }
        }
    }
    
}
