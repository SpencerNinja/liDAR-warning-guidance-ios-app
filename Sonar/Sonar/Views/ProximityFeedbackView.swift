//
//  ProximityFeedbackView.swift
//  Sonar
//
//  Created by Spencer Hurd on 11/15/24.
//

import SwiftUI

struct ProximityFeedbackView: View {
    
    @StateObject private var proximityViewModel = ProximitySensorViewModel()
    
    var body: some View {
        ZStack {
            // Background
            backgroundImage
            
            GeometryReader { geo in
                VStack(spacing: 0) {
                    // Settings Button Section
                    settingsPageTurnerButton(geo: geo)
                    
                    // Activate/Deactivate Button Section
                    if proximityViewModel.currentSettingsPage == 0 {
                        if proximityViewModel.sonarIsActive {
                            stopSonarButton(geo: geo)
                        } else {
                            startSonarButton(geo: geo)
                        }
                    } else if proximityViewModel.currentSettingsPage == 1 {
                        settingsPageBeepsButton(geo: geo)
                    } else if proximityViewModel.currentSettingsPage == 2 {
                        settingsPageHapticsButton(geo: geo)
                    } else if proximityViewModel.currentSettingsPage == 3 {
                        settingsPageVocalInstructionsButton(geo: geo)
                    } else if proximityViewModel.currentSettingsPage == 4 {
                        settingsPageAdjustWarningDistanceButtons(geo: geo)
                    }
                }
            }
            .foregroundStyle(Color.white)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .offset(x: -39)
        }
        .onAppear {
            print("Welcome to Sonar. This app is designed to assist the visually impaired with safely navigating a world full of obstacles. Disclaimer: This tool is not meant to replace vision, but is a tool to use along with your other senses and devices to help you navigate.")
        }
    }
}

extension ProximityFeedbackView {
    
    var backgroundImage: some View {
        ZStack(alignment: .topLeading) { // Ensure alignment is explicitly top-left
            // Background image and overlay
            Image("bg2")
                .resizable()
                .aspectRatio(contentMode: .fill)
            
            Rectangle()
                .fill(Color.black.opacity(0.7))
                .ignoresSafeArea() // Ensures overlay fills the screen
            
            // Text logo in the top-left corner
            Text("SONAR")
                .foregroundColor(.white)
                .font(.largeTitle)
                .bold()
                .offset(x: 139, y: 30)
        }
        .ignoresSafeArea() // Ensure the background fills the screen
    }
    
    func settingsPageTurnerButton(geo: GeometryProxy) -> some View {
        Button(action: {
            if proximityViewModel.currentSettingsPage < 4 {
                proximityViewModel.currentSettingsPage += 1
            } else {
                proximityViewModel.currentSettingsPage = 0
            }
            print("Settings button tapped.")
        }) {
            VStack {
                Text("Tap for settings")
                    .font(.largeTitle)
                    .padding(.bottom, 20)
                Text("Beeps enabled: \(proximityViewModel.proximityBeepsAreEnabled ? "Yes" : "No")")
                Text("Haptics enabled: \(proximityViewModel.proximityHapticsAreEnabled ? "Yes" : "No")")
                Text("Voice instructions enabled: \(proximityViewModel.vocalInstructionsAreEnabled ? "Yes" : "No")")
                Text("Warning distance: \(String(format: "%.0f", proximityViewModel.warningDistance)) feet")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color.blue.opacity(0.2))
            .cornerRadius(10)
        }
        .frame(width: geo.size.width, height: geo.size.height / 2)
    }
    
    func settingsPageBeepsButton(geo: GeometryProxy) -> some View {
        Button(action: {
            proximityViewModel.proximityBeepsAreEnabled.toggle()
            print("Beeps button tapped.")
        }) {
            Text("Tap to \(proximityViewModel.proximityBeepsAreEnabled ? "DISABLE" : "ENABLE") proximity beeps")
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
        }
        .frame(width: geo.size.width, height: geo.size.height / 2)
    }
    
    func settingsPageHapticsButton(geo: GeometryProxy) -> some View {
        Button(action: {
            proximityViewModel.proximityHapticsAreEnabled.toggle()
            print("Haptics button tapped.")
        }) {
            Text("Tap to \(proximityViewModel.proximityHapticsAreEnabled ? "DISABLE" : "ENABLE") proximity haptics (vibration)")
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

        }
        .frame(width: geo.size.width, height: geo.size.height / 2)
    }
    
    func settingsPageVocalInstructionsButton(geo: GeometryProxy) -> some View {
        Button(action: {
            proximityViewModel.vocalInstructionsAreEnabled.toggle()
            print("Vocal instructions button tapped.")
        }) {
            Text("Tap to \(proximityViewModel.vocalInstructionsAreEnabled ? "DISABLE" : "ENABLE") vocal instructions")
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
        }
        .frame(width: geo.size.width, height: geo.size.height / 2)
    }
    
    func settingsPageAdjustWarningDistanceButtons(geo: GeometryProxy) -> some View {
        HStack(spacing: 0) {
            Button(action: {
                if proximityViewModel.warningDistance > 1 {
                    proximityViewModel.warningDistance -= 1
                }
            }) {
                Text("Tap to REDUCE warning distance")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
            .frame(width: geo.size.width / 2, height: geo.size.height / 2)
            Button(action: {
                if proximityViewModel.warningDistance < 20 {
                    proximityViewModel.warningDistance += 1
                }
            }) {
                Text("Tap to INCREASE warning distance")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
            .frame(width: geo.size.width / 2, height: geo.size.height / 2)
        }
        .frame(width: geo.size.width, height: geo.size.height / 2)
    }
    
    func startSonarButton(geo: GeometryProxy) -> some View {
        Button(action: {
            proximityViewModel.sonarIsActive = true
            proximityViewModel.startMonitoring()
        }) {
            VStack {
                Text("To START sonar, tap anywhere in the lower half of the screen")
                    .font(.title)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
        }
        .frame(width: geo.size.width, height: geo.size.height / 2)
    }
    
    func stopSonarButton(geo: GeometryProxy) -> some View {
        Button(action: {
            proximityViewModel.sonarIsActive = false
            proximityViewModel.stopMonitoring()
        }) {
            VStack {
                // Display distance in feet
                Text("Distance: \(proximityViewModel.sonarIsActive ? "\(proximityViewModel.distance * 3.28084, specifier: "%.2f") feet" : "--")")
                    .font(.largeTitle)
                    .padding()
                
                // Warning Message
                HStack {
                    Text("Pathway:")
                    Text(proximityViewModel.distance * 3.28084 < proximityViewModel.warningDistance ? "OBJECT DETECTED!" : "All clear")
                }
                .font(.title)
                
                Spacer()
                
                // START/STOP Sonar Instructions
                Text("To STOP sonar, tap anywhere in the lower half of the screen")
                    .font(.title)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(proximityViewModel.distance * 3.28084 < 2.0 ? Color.red.opacity(0.2) : Color.green.opacity(0.2))
            .cornerRadius(10)
        }
        .frame(width: geo.size.width, height: geo.size.height / 2)
    }
    
}

#Preview {
    ProximityFeedbackView()
}
