//
//  ProximityFeedbackView.swift
//  Sonic BAT
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
                    if proximityViewModel.isShowingAndTellingFirstInstructions {
                        showAndTellInstructionsPopup(geo: geo)
                    } else {
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
            }
            .foregroundStyle(Color.white)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .offset(x: -39)
        }
    }
}

extension ProximityFeedbackView {
    
    var backgroundImage: some View {
        ZStack(alignment: .topLeading) {
            // Background image and overlay
            Image("bg2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            Rectangle()
                .fill(Color.black.opacity(0.7))
                .ignoresSafeArea()
            
            // Text logo in the top-left corner
            Text("Sonic BAT")
                .font(.custom("MarkerFelt-Thin", size: 18))
                .kerning(5)
                .bold()
                .shadow(color: Color.blue, radius: 10, x: 0, y: 0) // Glowing shadow effect
                .foregroundStyle(LinearGradient(
                    gradient:
                        Gradient(
                            colors: [.white, .yellow]
                        ),
                    startPoint: .top,
                    endPoint: .bottom)
                )
                .offset(x: 139, y: 40)
        }
        .ignoresSafeArea()
    }
    
    func settingsPageTurnerButton(geo: GeometryProxy) -> some View {
        Button(action: {
            withAnimation {
                if proximityViewModel.currentSettingsPage < 4 {
                    proximityViewModel.currentSettingsPage += 1
                } else {
                    proximityViewModel.currentSettingsPage = 0
                }
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
                Text("Warning distance: \(String(format: "%.0f", proximityViewModel.warningDistance)) \(proximityViewModel.warningDistance == 1 ? "foot" : "feet")")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .background(Color.blue.opacity(0.2))
            .cornerRadius(10)
        }
        .frame(width: geo.size.width, height: geo.size.height / 2)
        .onAppear {
            proximityViewModel.messageToSpeak = """
            Overview of current settings:
            Beeps: \(proximityViewModel.proximityBeepsAreEnabled ? "enabled" : "disabled").
            Haptics: \(proximityViewModel.proximityHapticsAreEnabled ? "enabled" : "disabled").
            Voice instructions: \(proximityViewModel.vocalInstructionsAreEnabled ? "enabled" : "disabled")
            Warning distance currently set to: \(String(format: "%.0f", proximityViewModel.warningDistance)) \(proximityViewModel.warningDistance == 1 ? "foot" : "feet").
            """
            proximityViewModel.speakMessage()
        }
    }
    
    func settingsPageBeepsButton(geo: GeometryProxy) -> some View {
        Button(action: {
            proximityViewModel.proximityBeepsAreEnabled.toggle()
            proximityViewModel.messageToSpeak = """
            Beeps are now \(proximityViewModel.proximityBeepsAreEnabled ? "enabled" : "disabled"). Tap on lower half of screen to \(proximityViewModel.proximityBeepsAreEnabled ? "disable" : "enable")").
            """
            proximityViewModel.speakMessage()
            print("Beeps button tapped.")
        }) {
            (Text("Tap to ")
                + Text(proximityViewModel.proximityBeepsAreEnabled ? "DISABLE" : "ENABLE")
                    .bold()
                    .underline()
                    .italic()
                + Text(" proximity beeps"))
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
        }
        .frame(width: geo.size.width, height: geo.size.height / 2)
        .onAppear {
            proximityViewModel.messageToSpeak = """
            Beeps are currently \(proximityViewModel.proximityBeepsAreEnabled ? "enabled" : "disabled"). Tap on lower half of screen to \(proximityViewModel.proximityBeepsAreEnabled ? "disable" : "enable")").
            """
            proximityViewModel.speakMessage()
        }
    }
    
    func settingsPageHapticsButton(geo: GeometryProxy) -> some View {
        Button(action: {
            proximityViewModel.proximityHapticsAreEnabled.toggle()
            proximityViewModel.messageToSpeak = """
            Haptics are now \(proximityViewModel.proximityHapticsAreEnabled ? "enabled" : "disabled"). Tap on lower half of screen to \(proximityViewModel.proximityHapticsAreEnabled ? "disable" : "enable")").
            """
            proximityViewModel.speakMessage()
            print("Haptics button tapped.")
        }) {
            (Text("Tap to ")
                + Text(proximityViewModel.proximityHapticsAreEnabled ? "DISABLE" : "ENABLE")
                    .bold()
                    .underline()
                    .italic()
                + Text(" proximity haptics"))
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

        }
        .frame(width: geo.size.width, height: geo.size.height / 2)
        .onAppear {
            proximityViewModel.messageToSpeak = """
            Haptics are currently \(proximityViewModel.proximityHapticsAreEnabled ? "enabled" : "disabled"). Tap on lower half of screen to \(proximityViewModel.proximityHapticsAreEnabled ? "disable" : "enable")").
            """
            proximityViewModel.speakMessage()
        }
    }
    
    func settingsPageVocalInstructionsButton(geo: GeometryProxy) -> some View {
        Button(action: {
            proximityViewModel.vocalInstructionsAreEnabled.toggle()
            proximityViewModel.messageToSpeak = """
            Vocal instructions are now \(proximityViewModel.vocalInstructionsAreEnabled ? "enabled" : "disabled"). Tap on lower half of screen to \(proximityViewModel.vocalInstructionsAreEnabled ? "disable" : "enable")").
            """
            proximityViewModel.speakMessage()
            print("Vocal instructions button tapped.")
        }) {
            (Text("Tap to ")
             + Text(proximityViewModel.vocalInstructionsAreEnabled ? "DISABLE" : "ENABLE")
                    .bold()
                    .underline()
                    .italic()
                + Text("\n vocal instructions"))
                .font(.largeTitle)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
        }
        .frame(width: geo.size.width, height: geo.size.height / 2)
        .onAppear {
            proximityViewModel.messageToSpeak = """
            Vocal Instructions are currently \(proximityViewModel.vocalInstructionsAreEnabled ? "enabled" : "disabled"). Tap on lower half of screen to \(proximityViewModel.vocalInstructionsAreEnabled ? "disable" : "enable")").
            """
            proximityViewModel.speakMessage()
        }
    }
    
    func settingsPageAdjustWarningDistanceButtons(geo: GeometryProxy) -> some View {
        HStack(spacing: 0) {
            Button(action: {
                if proximityViewModel.warningDistance > 1 {
                    proximityViewModel.warningDistance -= 1
                    proximityViewModel.messageToSpeak = "The warning distance decreased to \(Int(proximityViewModel.warningDistance)) \(proximityViewModel.warningDistance == 1 ? "foot" : "feet")."
                }
                if proximityViewModel.warningDistance == 1 {
                    proximityViewModel.messageToSpeak = "1 foot is the lowest warning distance."
                }
                proximityViewModel.speakMessage()
            }) {
                (Text("Tap to ")
                    + Text("REDUCE")
                        .bold()
                        .underline()
                        .italic()
                    + Text("\n warning distance"))
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
                    proximityViewModel.messageToSpeak = "The warning distance increased to \(Int(proximityViewModel.warningDistance)) feet."
                }
                if proximityViewModel.warningDistance == 20 {
                    proximityViewModel.messageToSpeak = "20 feet is the highest warning distance."
                }
                proximityViewModel.speakMessage()
            }) {
                (Text("Tap to ")
                    + Text("INCREASE")
                        .bold()
                        .underline()
                        .italic()
                    + Text("\n warning distance"))
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
        .onAppear {
            proximityViewModel.messageToSpeak = """
            The warning distance is currently set to \(Int(proximityViewModel.warningDistance)) \(proximityViewModel.warningDistance == 1 ? "foot" : "feet"). Tap on the lower-left half of the screen to decrease the distance and tap on the lower-right half of the screen to increase the distance.
            """
            proximityViewModel.speakMessage()
        }
    }
    
    func startSonarButton(geo: GeometryProxy) -> some View {
        Button(action: {
            proximityViewModel.sonarIsActive = true
            proximityViewModel.startMonitoring() // TODO: This isn't working on the second click
            proximityViewModel.messageToSpeak = "Sonar activated."
            proximityViewModel.speakMessage()
        }) {
            VStack {
                (Text("To ")
                    + Text("START")
                        .bold()
                        .underline()
                        .italic()
                    + Text(" sonar, \n tap anywhere in the lower half of the screen"))
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
            proximityViewModel.messageToSpeak = "Sonar deactivated."
            proximityViewModel.speakMessage()
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
                (Text("To ")
                    + Text("STOP")
                        .bold()
                        .underline()
                        .italic()
                    + Text(" sonar, \n tap anywhere in the lower half of the screen"))
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
    
    func showAndTellInstructionsPopup(geo: GeometryProxy) -> some View {
        VStack {
            Button {
                proximityViewModel.stopSpeaking() // Stop text-to-speech
                proximityViewModel.isShowingAndTellingFirstInstructions = false
            } label: {
                Text(proximityViewModel.showAndTellInstructionMessage)
                    .font(.headline)
                    .padding()
                    .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: geo.size.width, height: geo.size.height)
        .onAppear {
            proximityViewModel.messageToSpeak = proximityViewModel.showAndTellInstructionMessage
            proximityViewModel.speakMessage()
        }
    }
    
}

#Preview {
    ProximityFeedbackView()
}
