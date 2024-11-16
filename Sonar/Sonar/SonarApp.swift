//
//  SonarApp.swift
//  Sonic BAT
//
//  Created by Spencer Hurd on 11/15/24.
//

import SwiftUI
import AVFoundation

@main
struct SonarApp: App {
    
    @State private var isShowingLaunchScreen = true // Control the visibility of the launch screen
    
    var body: some Scene {
        WindowGroup {
            if isShowingLaunchScreen {
                LaunchScreenView()
                    .onAppear {
                        DispatchQueue.global(qos: .userInitiated).async {
                            // Perform heavy initializations here
                            initializeComponents()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                withAnimation {
                                    isShowingLaunchScreen = false
                                }
                            }
                        }
                    }
            } else {
                ProximityFeedbackView()
            }
        }
    }
    
    // Perform heavy initialization tasks in the background.
    private func initializeComponents() {
        // Preload speech synthesizer
        let _ = AVSpeechSynthesizer()
        
        // TODO: Add any additional heavy initializations here, such as loading resources or setting up managers
        print("Initialization tasks completed.")
    }
}
