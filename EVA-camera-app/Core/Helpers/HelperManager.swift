//
//  HelperManager.swift
//  EVA-camera-app
//
//  Created by Alex on 27.07.2023.
//

import AVFoundation

final class HelperManager {
    static func recordSound() {
        let systemSoundID: SystemSoundID = 1014
        AudioServicesPlaySystemSound(systemSoundID)
    }
    
    static func stopSound() {
        let systemSoundID: SystemSoundID = 1013
        AudioServicesPlaySystemSound(systemSoundID)
    }
}
