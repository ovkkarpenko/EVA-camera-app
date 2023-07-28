//
//  LaunchCoordinator.swift
//  EVA-camera-app
//
//  Created by Alex on 27.07.2023.
//

import UIKit

protocol ILaunchCoordinator {
    func start()
}

final class LaunchCoordinator: ILaunchCoordinator {
    // Dependencies
    private let window: UIWindow?
    private let permissionService: IPermissionService
    
    // MARK: - Initializers
    
    init(
        with window: UIWindow?,
        permissionService: IPermissionService
    ) {
        self.window = window
        self.permissionService = permissionService
    }
    
    // MARK: - ILaunchCoordinator
    
    func start() {
        if permissionService.isGrantedCameraAccess() && permissionService.isGrantedLibraryAccess() {
            launchDidOpenHome()
        } else {
            let controller: LaunchViewController = LaunchAssembly().assembly(output: self)
            window?.rootViewController = UINavigationController(rootViewController: controller)
            window?.makeKeyAndVisible()
        }
    }
}

// MARK: - LaunchModuleOutput

extension LaunchCoordinator: LaunchModuleOutput {
    func launchDidOpenHome() {
        let controller: CameraViewController = CameraAssembly().assembly()
        window?.rootViewController = UINavigationController(rootViewController: controller)
        window?.makeKeyAndVisible()
    }
}
