//
//  LogoView.swift
//  Sonar
//
//  Created by Spencer Hurd on 11/15/24.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Text("Sonic BAT")
                    .font(.custom("MarkerFelt-Thin", size: 18))
                    .kerning(5)
                    .bold()
                    .shadow(color: Color.purple, radius: 10, x: 0, y: 0) // Glowing shadow effect
                    .foregroundStyle(LinearGradient(
                        gradient:
                            Gradient(
                                colors: [.blue, .purple]
                            ),
                        startPoint: .top,
                        endPoint: .bottom)
                    )
                Text("Sonic BAT")
                    .font(.custom("MarkerFelt-Thin", size: 18))
                    .kerning(5)
                    .bold()
                    .shadow(color: Color.white, radius: 10, x: 0, y: 0) // Glowing shadow effect
                    .foregroundStyle(LinearGradient(
                        gradient:
                            Gradient(
                                colors: [.orange, .yellow]
                            ),
                        startPoint: .top,
                        endPoint: .bottom)
                    )
                
                Text("Sonic BAT - American Typewriter")
                    .font(.custom("AmericanTypewriter", size: 18))
                Text("Sonic BAT - Bradley Hand")
                    .font(.custom("BradleyHandITCTT-Bold", size: 18))
                Text("Sonic BAT - Chalkduster")
                    .font(.custom("Chalkduster", size: 18))
                Text("Sonic BAT - Copperplate")
                    .font(.custom("Copperplate", size: 18))
                Text("Sonic BAT - Courier New")
                    .font(.custom("CourierNewPSMT", size: 18))
                Text("Sonic BAT - DIN Condensed")
                    .font(.custom("DINCondensed-Bold", size: 18))
                Text("Sonic BAT - Futura")
                    .font(.custom("Futura-Medium", size: 18))
                Text("Sonic BAT - Hoefler Text")
                    .font(.custom("HoeflerText-Regular", size: 18))
                Text("Sonic BAT - Impact")
                    .font(.custom("Impact", size: 18))
                Text("Sonic BAT - Kefa")
                    .font(.custom("Kefa-Regular", size: 18))
                Text("Sonic BAT - Marker Felt")
                    .font(.custom("MarkerFelt-Thin", size: 18))
                Text("Sonic BAT - Noteworthy")
                    .font(.custom("Noteworthy-Light", size: 18))
                Text("Sonic BAT - Rockwell")
                    .font(.custom("Rockwell-Regular", size: 18))
            }
            .padding()
            .padding(.bottom, 400)
        }
        .foregroundStyle(Color.yellow)
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 60)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(Color.black)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    LogoView()
}
