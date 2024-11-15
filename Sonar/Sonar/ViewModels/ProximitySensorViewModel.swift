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
    private let lidarManager = LiDARManager()
    private let audioManager = AudioFeedbackManager()
    private let hapticManager = HapticFeedbackManager()
    
    init() {
        lidarManager.onDistanceUpdate = { [weak self] distance in
            DispatchQueue.main.async {
                self?.distance = distance
                self?.handleAudioFeedback(for: distance)
            }
        }
    }
    
    func startMonitoring() {
        let configuration = ARWorldTrackingConfiguration()
        lidarManager.startSession(with: configuration)
        print("LiDAR monitoring started.")
    }
    
    private func handleAudioFeedback(for distance: Float) {
        let distanceInFeet = distance * 3.28084

        if distanceInFeet < 2.0 {
            
            // Audio feedback (closer = louder)
            let normalizedVolume = max(0.1, min(1.0, 1.0 - (distanceInFeet / 2.0))) // Volume: 0.1 to 1.0
            audioManager.playTone(frequency: 440, volume: normalizedVolume) // A4 tone (440 Hz)
            
            // Haptic feedback (closer = stronger vibration)
            let intensity = Float(1.0 - (distanceInFeet / 2.0))
            hapticManager.playHapticFeedback(intensity: intensity)
            
        } else {
            audioManager.stopTone()
            hapticManager.stopHapticFeedback()
        }
    }
    
}











//class ProximitySensorViewModel: ObservableObject {
//    @Published var distance: Float = .greatestFiniteMagnitude
//    private let lidarManager = LiDARManager()
//    private let audioFeedbackManager = AudioFeedbackManager()
//    private let hapticFeedbackManager = AdvancedHapticsManager()
//    init() {
//        lidarManager.onDistanceUpdate = { [weak self] distance in
//            DispatchQueue.main.async {
//                self?.distance = distance
//                self?.triggerFeedback(for: distance)
//            }
//        }
//    }
//    func startMonitoring() {
//        let configuration = ARWorldTrackingConfiguration()
//        lidarManager.startSession(with: configuration)
//        print("LiDAR monitoring started.")
//    }
//    func stopMonitoring() {
//        lidarManager.stop()
//        print("Monitoring stopped.")
//    }
//    private func triggerFeedback(for distance: Float) {
//        guard distance != .greatestFiniteMagnitude else {
//            print("Invalid distance received.")
//            return
//        }
//        let normalizedDistance = max(0.1, min(1.0, 1.0 - (distance / 5.0))) // Normalize to range [0.1, 1.0]
//        audioFeedbackManager.playTone(forDistance: 50) // Example: Closer object (higher frequency)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.audioFeedbackManager.stopTone() // Stops the tone after 2 seconds
//        }
//        DispatchQueue.global(qos: .userInitiated).async {
//            self.audioFeedbackManager.playTone(forDistance: Int(distance * 100))
//        }
//        DispatchQueue.main.async {
//            self.hapticFeedbackManager.playFeedback(intensity: Float(normalizedDistance))
//        }
//    }
//}
