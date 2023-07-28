//
//  LaunchViewModel.swift
//  EVA-camera-app
//
//  Created by Alex on 27.07.2023.
//

import UIKit
import Photos

protocol ILaunchViewModel {
    func checkPermissions()
    func didTapPermission()
}

enum LaunchState {
    case camera
    case library
}

final class LaunchViewModel {
    // Dependencies
    weak var view: ILaunchViewController?
    weak var output: LaunchModuleOutput?
    private let permissionService: IPermissionService
    private let viewModelFactory: ILaunchViewModelFactory
    
    // Properties
    private var state: LaunchState = .camera
    
    // MARK: - Initializers
    
    init(
        permissionService: IPermissionService,
        viewModelFactory: ILaunchViewModelFactory
    ) {
        self.permissionService = permissionService
        self.viewModelFactory = viewModelFactory
    }
    
    // MARK: - Private
    
    private func openSettings() {
        let application = UIApplication.shared
        
        if let url = URL(string: UIApplication.openSettingsURLString), application.canOpenURL(url) {
            application.open(url)
        }
    }
}

// MARK: - ILaunchViewModel

extension LaunchViewModel: ILaunchViewModel {
    func checkPermissions() {
        if !permissionService.isGrantedCameraAccess() {
            state = .camera
        } else if !permissionService.isGrantedLibraryAccess() {
            state = .library
        }
        view?.reloadView(with: viewModelFactory.makeLaunchModel(state: state))
    }
    
    func didTapPermission() {
        let cameraAccessDeniedAlertModel = viewModelFactory.makeCameraAccessDeniedAlertModel()
        let libraryAccessDeniedAlertModel = viewModelFactory.makeLibraryAccessDeniedAlertModel()
        
        if state == .camera {
            permissionService.requestCameraAccess { [weak self] isGranted in
                if isGranted && UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self?.checkPermissions()
                } else {
                    self?.view?.showAlert { configurator in
                        configurator.title = cameraAccessDeniedAlertModel.title
                        configurator.message = cameraAccessDeniedAlertModel.description
                        configurator.actions = [
                            .default(title: cameraAccessDeniedAlertModel.defaultButtonText, handler: { [weak self] in
                                self?.openSettings()
                            }),
                            .cancel(title: cameraAccessDeniedAlertModel.cancelButtonText)
                        ]
                    }
                }
            }
        } else if state == .library {
            permissionService.requestLibraryAccess { [weak self] isGranted in
                if isGranted {
                    self?.output?.launchDidOpenHome()
                } else {
                    self?.view?.showAlert { configurator in
                        configurator.title = libraryAccessDeniedAlertModel.title
                        configurator.message = libraryAccessDeniedAlertModel.description
                        configurator.actions = [
                            .default(title: libraryAccessDeniedAlertModel.defaultButtonText, handler: { [weak self] in
                                self?.openSettings()
                            }),
                            .cancel(title: libraryAccessDeniedAlertModel.cancelButtonText)
                        ]
                    }
                }
            }
        }
    }
}
