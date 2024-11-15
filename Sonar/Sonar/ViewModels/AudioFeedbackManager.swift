//
//  AudioFeedbackManager.swift
//  Sonar
//
//  Created by Spencer Hurd on 11/15/24.
//

import Foundation
import AVFoundation

class AudioFeedbackManager {
    private var audioEngine: AVAudioEngine?
    private var oscillatorNode: AVAudioSourceNode?

    func playTone(frequency: Double, volume: Float) {
        stopTone() // Ensure no overlapping tones
        audioEngine = AVAudioEngine()
        let mainMixer = audioEngine?.mainMixerNode
        mainMixer?.outputVolume = volume

        oscillatorNode = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            let thetaIncrement = 2.0 * .pi * frequency / 44100.0 // 44100 Hz sample rate
            var currentTheta: Double = 0.0

            for frame in 0..<Int(frameCount) {
                let sampleValue = Float(sin(currentTheta)) // Generate sine wave sample
                currentTheta += thetaIncrement
                if currentTheta > 2.0 * .pi {
                    currentTheta -= 2.0 * .pi
                }
                for buffer in ablPointer {
                    let samples = buffer.mData?.assumingMemoryBound(to: Float.self)
                    samples?[frame] = sampleValue
                }
            }
            return noErr
        }

        guard let audioEngine = audioEngine, let oscillatorNode = oscillatorNode else {
            print(",- Failed to initialize audio components.")
            return
        }

        let outputFormat = audioEngine.outputNode.outputFormat(forBus: 0)
        audioEngine.attach(oscillatorNode)
        audioEngine.connect(oscillatorNode, to: audioEngine.outputNode, format: outputFormat)

        do {
            try audioEngine.start()
            print(",- Tone started at frequency: \(frequency) Hz with volume: \(volume)")
        } catch {
            print(",- Failed to start audio engine: \(error)")
        }
    }

    func stopTone() {
        if let audioEngine = audioEngine, audioEngine.isRunning {
            audioEngine.stop()
        }
        audioEngine = nil
        oscillatorNode = nil
    }
}
