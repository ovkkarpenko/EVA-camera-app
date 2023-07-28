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
    private let viewModelFactory: ILaunchViewModelFactory
    
    // MARK: - Initializers
    
    init(
        permissionService: IPermissionService = PermissionService(),
        viewModelFactory: ILaunchViewModelFactory = LaunchViewModelFactory()
    ) {
        self.permissionService = permissionService
        self.viewModelFactory = viewModelFactory
    }
    
    // MARK: - ILaunchAssembly
    
    func assembly(output: LaunchModuleOutput?) -> LaunchViewController {
        let viewModel: LaunchViewModel = LaunchViewModel(
            permissionService: permissionService,
            viewModelFactory: viewModelFactory
        )
        let view: LaunchViewController = LaunchViewController(viewModel: viewModel)
        
        viewModel.view = view
        viewModel.output = output
        
        return view
    }
}
