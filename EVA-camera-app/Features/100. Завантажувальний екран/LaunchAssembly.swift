//
//  LaunchAssembly.swift
//  EVA-camera-app
//
//  Created by Alex on 27.07.2023.
//

import UIKit

protocol ILaunchAssembly {
    func assembly(output: LaunchModuleOutput?) -> LaunchViewController
}

final class LaunchAssembly {
    // Dependencies
    private let permissionService: IPermissionService
    
    // MARK: - Initializers
    
    init(permissionService: IPermissionService = PermissionService()) {
        self.permissionService = permissionService
    }
    
    // MARK: - ILaunchAssembly
    
    func assembly(output: LaunchModuleOutput?) -> LaunchViewController {
        let viewModel: LaunchViewModel = LaunchViewModel(permissionService: permissionService)
        let view: LaunchViewController = LaunchViewController(viewModel: viewModel)
        
        viewModel.view = view
        viewModel.output = output
        
        return view
    }
}
