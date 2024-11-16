//
//  LaunchScreenView.swift
//  Sonic BAT
//
//  Created by Spencer Hurd on 11/15/24.
//

import SwiftUI

struct LaunchScreenView: View {
    @State private var cloud1Offset: CGFloat = -(UIScreen.main.bounds.width + 1000)
    @State private var cloud2Offset: CGFloat = -(UIScreen.main.bounds.width + 1000)
    @State private var cloud3Offset: CGFloat = UIScreen.main.bounds.width + 1000
    @State private var cloud4Offset: CGFloat = UIScreen.main.bounds.width + 1000

    var body: some View {
        ZStack {
            // Background image and overlay
            Image("bg2")
                .resizable()
                .aspectRatio(contentMode: .fit)

            // Animating clouds
            Image("cloud1")
                .offset(x: cloud1Offset, y: -100)
                .opacity(0.5)
                .scaleEffect(x: 1, y: -1) // Flips the image vertically
                .onAppear {
                    animateCloud(for: $cloud1Offset, direction: .rightToLeft, delay: 0)
                }
            
            Image("cloud1")
                .offset(x: cloud3Offset, y: -300)
                .opacity(0.4)
                .onAppear {
                    animateCloud(for: $cloud3Offset, direction: .leftToRight, delay: 3)
                }
            

            Rectangle()
                .fill(Color.black.opacity(0.4))
                .ignoresSafeArea()

            VStack {
                Image("batLogo")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .foregroundColor(.white)

                // Text logo in the top-left corner
                Text("Sonic BAT")
                    .font(.custom("MarkerFelt-Thin", size: 40))
                    .kerning(5)
                    .bold()
                    .shadow(color: Color.white, radius: 10, x: 0, y: 0) // Glowing shadow effect
                    .foregroundStyle(LinearGradient(
                        gradient: Gradient(colors: [.white, .yellow]),
                        startPoint: .top,
                        endPoint: .bottom)
                    )
            }
            Image("cloud1")
                .offset(x: cloud2Offset, y: -250)
                .opacity(0.3)
                .scaleEffect(x: 1, y: -1) // Flips the image vertically
                .onAppear {
                    animateCloud(for: $cloud2Offset, direction: .leftToRight, delay: 1)
                }
            Image("cloud1")
                .offset(x: cloud4Offset, y: 50)
                .opacity(0.4)
                .onAppear {
                    animateCloud(for: $cloud4Offset, direction: .rightToLeft, delay: 2)
                }
        }
    }

    private func animateCloud(for offset: Binding<CGFloat>, direction: AnimationDirection, delay: Double) {
        let screenWidth = UIScreen.main.bounds.width
        let animationDuration: Double = 10
        let resetPosition = direction == .rightToLeft ? -screenWidth : screenWidth
        let startPosition = direction == .rightToLeft ? screenWidth : -screenWidth

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            offset.wrappedValue = startPosition
            withAnimation(.linear(duration: animationDuration).repeatForever(autoreverses: false)) {
                offset.wrappedValue = resetPosition
            }
        }
    }
}

enum AnimationDirection {
    case rightToLeft
    case leftToRight
}

#Preview {
    LaunchScreenView()
}
