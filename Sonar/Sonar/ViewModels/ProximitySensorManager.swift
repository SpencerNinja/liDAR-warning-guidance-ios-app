//
//  ProximitySensorManager.swift
//  Sonar
//
//  Created by Spencer Hurd on 11/15/24.
//

import Foundation
import AVFoundation
import UIKit

class ProximitySensorManager {
    func enableProximitySensor() {
        // Enable proximity monitoring on the current device
        UIDevice.current.isProximityMonitoringEnabled = true
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleProximityChange),
            name: UIDevice.proximityStateDidChangeNotification,
            object: nil
        )
    }
    @objc private func handleProximityChange() {
        if UIDevice.current.proximityState {
            print("Object detected nearby")
            // Trigger feedback
        } else {
            print("No object detected")
        }
    }
    func disableProximitySensor() {
        // Disable proximity monitoring when not needed
        UIDevice.current.isProximityMonitoringEnabled = false
        NotificationCenter.default.removeObserver(self, name: UIDevice.proximityStateDidChangeNotification, object: nil)
    }
}
