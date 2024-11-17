//
//  ProximitySensorViewModel.swift
//  Sonic BAT
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
    
    @Published var isShowingAndTellingFirstInstructions: Bool = true
    private let speechSynthesizer = AVSpeechSynthesizer()
    @Published var showAndTellInstructionMessage: String = """
    Welcome to Sonic Bat! This app is designed to assist individuals with visual impairments in safely navigating their surroundings.

    To get started:  
    Tap anywhere on the screen to dismiss this message.  
    Tap the **top half** of the screen to cycle through settings.  
    Tap the **bottom half** of the screen to activate the Sonic Bat experience.

    **Important Notes:**  
    Ensure that the LiDAR sensors and camera are not obstructed while holding your phone. Point your phone's camera at about a 45 degree angle towards the ground in front of you. 
    The app provides audible feedback: a series of beeps that get louder as you approach the default warning distance of 2 feet.  
    You can disable the beeps and adjust the warning distance in the settings.
    
    **Disclaimer:** Sonic Bat is not a replacement for vision but a tool to complement your other senses and devices to aid in navigation.

    Enjoy exploring with Sonic Bat!
    """
    @Published var messageToSpeak: String = ""
    
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
        lidarManager.onDistanceUpdate = { [weak self] distance in
            DispatchQueue.main.async {
                self?.distance = distance
                self?.handleAudioHapticFeedback(for: distance)
            }
        }
        print("startMonitoring() - LiDAR monitoring started.")
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
        guard sonarIsActive else {
            audioManager.stopTone()
            hapticManager.stopHapticFeedback()
            return
        }

        let distanceInFeet = distance * 3.28084

        if distanceInFeet < warningDistance {
            if proximityBeepsAreEnabled {
                let normalizedVolume = max(0.1, min(1.0, 1.0 - (distanceInFeet / warningDistance)))
                audioManager.playTone(frequency: 440, volume: normalizedVolume)
                print("Audio feedback: Distance \(distanceInFeet) feet, Volume \(normalizedVolume).")
            }

            if proximityHapticsAreEnabled {
                let intensity = Float(1.0 - (distanceInFeet / warningDistance))
                hapticManager.playHapticFeedback(intensity: intensity)
                print("Haptic feedback: Distance \(distanceInFeet) feet, Intensity \(intensity).")
            }
        } else {
            if proximityBeepsAreEnabled {
                audioManager.stopTone()
            }
            if proximityHapticsAreEnabled {
                hapticManager.stopHapticFeedback()
            }
            print("Feedback stopped: No object within warning distance.")
        }
    }

    
    func speakMessage() {
        stopSpeaking()
        if vocalInstructionsAreEnabled == true {
            let utterance = AVSpeechUtterance(string: messageToSpeak)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = 0.5
            speechSynthesizer.speak(utterance)
        }
    }
    
    func stopSpeaking() {
        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
    }
    
}
