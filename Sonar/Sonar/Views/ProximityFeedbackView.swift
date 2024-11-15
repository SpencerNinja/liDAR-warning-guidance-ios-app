//
//  ProximityFeedbackView.swift
//  Sonar
//
//  Created by Spencer Hurd on 11/15/24.
//

import SwiftUI

struct ProximityFeedbackView: View {
    @StateObject private var viewModel = ProximitySensorViewModel()
    var body: some View {
        VStack {
            // Convert meters to feet for display
            Text("Distance: \(viewModel.distance * 3.28084, specifier: "%.2f") feet")
                .font(.largeTitle)
                .padding()
            // Display warning message if object is closer than 2 feet
            Text(viewModel.distance * 3.28084 < 2.0 ? "Object too close!" : "All clear")
                .font(.headline)
                .foregroundColor(viewModel.distance * 3.28084 < 2.0 ? .red : .green)
            Button(action: {
                viewModel.startMonitoring()
            }) {
                Text("Start Monitoring")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

#Preview {
    ProximityFeedbackView()
}
