//
//  LiDARManager.swift
//  Sonar
//
//  Created by Spencer Hurd on 11/15/24.
//

import Foundation
import ARKit

class LiDARManager: NSObject, ARSessionDelegate {
    private var arSession: ARSession!
    var onDistanceUpdate: ((Float) -> Void)?

    override init() {
        super.init()
        arSession = ARSession()
        arSession.delegate = self
    }

    func startSession(with configuration: ARWorldTrackingConfiguration) {
        guard ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) else {
            print("Scene depth not supported on this device.")
            return
        }
        configuration.frameSemantics = .sceneDepth
        arSession.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        print("LiDAR session started.")
    }

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard let sceneDepth = frame.sceneDepth else { return }

        let depthMap = sceneDepth.depthMap
        let nearestDistance = processDepthData(depthMap)
        onDistanceUpdate?(nearestDistance)
    }

    private func processDepthData(_ depthMap: CVPixelBuffer) -> Float {
        CVPixelBufferLockBaseAddress(depthMap, .readOnly)
        let width = CVPixelBufferGetWidth(depthMap)
        let height = CVPixelBufferGetHeight(depthMap)
        let baseAddress = CVPixelBufferGetBaseAddress(depthMap)
        var nearestDistance: Float = .greatestFiniteMagnitude

        if let floatBuffer = baseAddress?.assumingMemoryBound(to: Float.self) {
            for y in 0..<height {
                for x in 0..<width {
                    let index = y * width + x
                    let distance = floatBuffer[index]
                    if distance < nearestDistance {
                        nearestDistance = distance
                    }
                }
            }
        }

        CVPixelBufferUnlockBaseAddress(depthMap, .readOnly)
        return nearestDistance
    }
}
