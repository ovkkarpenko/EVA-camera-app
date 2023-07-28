//
//  LaunchViewModelFactory.swift
//  EVA-camera-app
//
//  Created by Alex on 28.07.2023.
//

import Foundation

protocol ILaunchViewModelFactory {
    func makeLaunchModel(state: LaunchState) -> LaunchModel
    func makeCameraAccessDeniedAlertModel() -> AlertModel
    func makeLibraryAccessDeniedAlertModel() -> AlertModel
}

final class LaunchViewModelFactory: ILaunchViewModelFactory {
    // MARK: - ILaunchViewModelFactory
    
    func makeLaunchModel(state: LaunchState) -> LaunchModel {
        let title: String
        
        switch state {
        case .camera:
            title = R.string.localizable.launch_camera_permission_text()
        case .library:
            title = R.string.localizable.launch_library_permission_text()
        }
        
        return LaunchModel(
            title: title,
            permissionButtonText: R.string.localizable.general_allow()
        )
    }
    
    func makeCameraAccessDeniedAlertModel() -> AlertModel {
        AlertModel(
            title: R.string.localizable.launch_camera_denied_title(),
            description: R.string.localizable.launch_camera_denied_description(),
            defaultButtonText: R.string.localizable.general_settings(),
            cancelButtonText: R.string.localizable.general_cancel()
        )
    }
    
    func makeLibraryAccessDeniedAlertModel() -> AlertModel {
        AlertModel(
            title: R.string.localizable.launch_library_denied_title(),
            description: R.string.localizable.launch_library_denied_description(),
            defaultButtonText: R.string.localizable.general_settings(),
            cancelButtonText: R.string.localizable.general_cancel()
        )
    }
}
