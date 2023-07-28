//
//  CameraViewModelFactory.swift
//  EVA-camera-app
//
//  Created by Alex on 27.07.2023.
//

import Foundation

protocol ICameraViewModelFactory {
    func makeCameraModel(isLoading: Bool, isRecording: Bool) -> CameraModel
    func makeErrorAlertModel() -> AlertModel
    func makeFinishAlertModel(mode: CameraMode) -> AlertModel
}

final class CameraViewModelFactory: ICameraViewModelFactory {
    // MARK: - ICameraViewModelFactory
    
    func makeCameraModel(isLoading: Bool, isRecording: Bool) -> CameraModel {
        CameraModel(
            isLoading: isLoading,
            actionButtonImage: isRecording
                ? R.image.ic_camera_stop()?.withRenderingMode(.alwaysTemplate)
                : R.image.ic_camera()?.withRenderingMode(.alwaysTemplate),
            switchCameraButtonImage: R.image.ic_camera_switch()?.withRenderingMode(.alwaysTemplate)
        )
    }
    
    func makeErrorAlertModel() -> AlertModel {
        AlertModel(
            title: R.string.localizable.general_error(),
            description: R.string.localizable.general_unexpected_error(),
            defaultButtonText: R.string.localizable.general_ok(),
            cancelButtonText: nil
        )
    }
    
    func makeFinishAlertModel(mode: CameraMode) -> AlertModel {
        AlertModel(
            title: R.string.localizable.general_ok(),
            description: mode == .photo
                ? R.string.localizable.camera_photo_success()
                : R.string.localizable.camera_video_success(),
            defaultButtonText: R.string.localizable.general_ok(),
            cancelButtonText: nil
        )
    }
}
