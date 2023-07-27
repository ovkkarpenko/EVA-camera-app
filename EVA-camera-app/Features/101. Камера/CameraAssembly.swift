//
//  CameraAssembly.swift
//  EVA-camera-app
//
//  Created by Alex on 27.07.2023.
//

import UIKit

protocol ICameraAssembly {
    func assembly() -> CameraViewController
}

final class CameraAssembly {
    // Dependencies
    private let cameraService: ICameraService
    private let viewModelFactory: ICameraViewModelFactory
    
    // MARK: - Initializers
    
    init(
        cameraService: ICameraService = CameraService(),
        viewModelFactory: ICameraViewModelFactory = CameraViewModelFactory()
    ) {
        self.cameraService = cameraService
        self.viewModelFactory = viewModelFactory
    }
    
    // MARK: - ICameraAssembly
    
    func assembly() -> CameraViewController {
        let viewModel: CameraViewModel = CameraViewModel(
            cameraService: cameraService,
            viewModelFactory: viewModelFactory
        )
        let view: CameraViewController = CameraViewController(viewModel: viewModel)
        
        viewModel.view = view
        
        return view
    }
}

