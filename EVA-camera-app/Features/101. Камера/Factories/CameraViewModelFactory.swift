//
//  CameraViewModelFactory.swift
//  EVA-camera-app
//
//  Created by Alex on 27.07.2023.
//

import Foundation

protocol ICameraViewModelFactory {
    func makeErrorAlertModel() -> AlertModel
    func makeFinishAlertModel(mode: CameraMode) -> AlertModel
}

final class CameraViewModelFactory: ICameraViewModelFactory {
    // MARK: - ICameraViewModelFactory
    
    func makeErrorAlertModel() -> AlertModel {
        AlertModel(
            title: R.string.localizable.general_error(),
            description: R.string.localizable.general_unexpected_error(),
            buttonText: R.string.localizable.general_ok()
        )
    }
    
    func makeFinishAlertModel(mode: CameraMode) -> AlertModel {
        AlertModel(
            title: R.string.localizable.general_ok(),
            description: mode == .photo
                ? R.string.localizable.camera_photo_success()
                : R.string.localizable.camera_video_success(),
            buttonText: R.string.localizable.general_ok()
        )
    }
}
