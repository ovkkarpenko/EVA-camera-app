//
//  LaunchViewModel.swift
//  EVA-camera-app
//
//  Created by Alex on 27.07.2023.
//

import UIKit
import Photos

protocol ILaunchViewModel {
    var title: String { get }
    
    func checkPermissions()
    func didTapPermission()
}

protocol LaunchViewDelegate: UIViewController {
    func reloadView()
}

enum LaunchState {
    case camera
    case library
}

final class LaunchViewModel {
    // Dependencies
    weak var delegate: LaunchViewDelegate?
    weak var output: LaunchModuleOutput?
    private let permissionService: IPermissionService
    
    // Properties
    private var state: LaunchState = .camera
    
    // MARK: - Initializers
    
    init(permissionService: IPermissionService) {
        self.permissionService = permissionService
    }
    
    // MARK: - Private
    
    private func openSettings() {
        let application = UIApplication.shared
        
        if let url = URL(string: UIApplication.openSettingsURLString), application.canOpenURL(url) {
            application.open(url)
        }
    }
    
    private func showCameraAccessDeniedAlert() {
        delegate?.showAlert(configure: { configurator in
            configurator.title = R.string.localizable.launch_camera_denied_title()
            configurator.message = R.string.localizable.launch_camera_denied_description()
            configurator.actions = [
                .default(title: R.string.localizable.general_settings(), handler: { [weak self] in
                    self?.openSettings()
                }),
                .cancel(title: R.string.localizable.general_cancel())
            ]
        })
    }
    
    private func showLibraryAccessDeniedAlert() {
        delegate?.showAlert(configure: { configurator in
            configurator.title = R.string.localizable.launch_library_denied_title()
            configurator.message = R.string.localizable.launch_library_denied_description()
            configurator.actions = [
                .default(title: R.string.localizable.general_settings(), handler: { [weak self] in
                    self?.openSettings()
                }),
                .cancel(title: R.string.localizable.general_cancel())
            ]
        })
    }
}

// MARK: - ILaunchViewModel

extension LaunchViewModel: ILaunchViewModel {
    var title: String {
        if state == .camera {
            return R.string.localizable.launch_camera_permission_text()
        } else if state == .library {
            return R.string.localizable.launch_library_permission_text()
        }
        return ""
    }
    
    func checkPermissions() {
        if !permissionService.isGrantedCameraAccess() {
            state = .camera
        } else if !permissionService.isGrantedLibraryAccess() {
            state = .library
        }
        delegate?.reloadView()
    }
    
    func didTapPermission() {
        if state == .camera {
            permissionService.requestCameraAccess { [weak self] isGranted in
                if isGranted && UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self?.checkPermissions()
                } else {
                    self?.showCameraAccessDeniedAlert()
                }
            }
        } else if state == .library {
            permissionService.requestLibraryAccess { [weak self] isGranted in
                if isGranted {
                    self?.output?.launchDidOpenHome()
                } else {
                    self?.showLibraryAccessDeniedAlert()
                }
            }
        }
    }
}
