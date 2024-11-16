//
//  SonarApp.swift
//  Sonic BAT
//
//  Created by Spencer Hurd on 11/15/24.
//

import SwiftUI

@main
struct SonarApp: App {
    
    @State private var isShowingLaunchScreen = true // Control the visibility of the launch screen
    
    var body: some Scene {
//        WindowGroup {
//            ProximityFeedbackView()
//        }
        WindowGroup {
            if isShowingLaunchScreen {
                LaunchScreenView()
                    .onAppear {
                        // Simulate a delay or handle initialization tasks
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation {
                                isShowingLaunchScreen = false
                            }
                        }
                    }
            } else {
                ProximityFeedbackView()
            }
        }
    }
}
