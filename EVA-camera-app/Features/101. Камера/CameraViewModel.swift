//
//  CameraViewModel.swift
//  EVA-camera-app
//
//  Created by Alex on 27.07.2023.
//

import UIKit
import Foundation
import AVFoundation

protocol ICameraViewModel {
    func didLoad()
    func didTapAction()
    func didTapSwitchCamera()
    func didTapCameraMode(index: Int)
}

final class CameraViewModel {
    // Dependencies
    weak var view: ICameraViewController?
    private let cameraService: ICameraService
    private let viewModelFactory: ICameraViewModelFactory
    
    // Properties
    private var isLoading: Bool = true
    private var isRecording: Bool = false
    
    // MARK: - Initializers
    
    init(
        cameraService: ICameraService,
        viewModelFactory: ICameraViewModelFactory
    ) {
        self.cameraService = cameraService
        self.viewModelFactory = viewModelFactory
    }
    
    // MARK: - Private
    
    private func updateView() {
        view?.reloadView(with: viewModelFactory.makeCameraModel(isLoading: isLoading, isRecording: isRecording))
    }
}

// MARK: - ICameraViewModel

extension CameraViewModel: ICameraViewModel {
    func didLoad() {
        isLoading = true
        updateView()
        
        cameraService.setDelegate(self)
        cameraService.startRunning { [weak self] captureSession in
            guard let captureSession = captureSession else { return }
            self?.isLoading = false
            self?.updateView()
            self?.view?.setupPreviewLayer(with: captureSession)
        }
    }
    
    func didTapAction() {
        cameraService.action()
    }
    
    func didTapSwitchCamera() {
        isLoading = true
        updateView()
        cameraService.switchCamera()
    }
    
    func didTapCameraMode(index: Int) {
        guard let mode = CameraMode(rawValue: index) else { return }
        isLoading = true
        updateView()
        cameraService.switchMode(mode)
    }
}

// MARK: - CameraServiceDelegate

extension CameraViewModel: CameraServiceDelegate {
    func cameraService(_ cameraService: CameraService, isRecording: Bool) {
        self.isRecording = isRecording
        updateView()
    }
    
    func cameraServiceError(_ cameraService: CameraService) {
        let alert: AlertModel = viewModelFactory.makeErrorAlertModel()
        
        view?.showAlert { configurator in
            configurator.title = alert.title
            configurator.message = alert.description
            configurator.actions = [.default(title: alert.defaultButtonText)]
        }
    }
    
    func cameraServiceSetupIsComplete(_ cameraService: CameraService) {
        isLoading = false
        updateView()
    }
    
    func cameraServiceStart(_ cameraService: CameraService, mode: CameraMode) {
        if mode == .video {
            HelperManager.recordSound()
        }
    }
    
    func cameraServiceFinish(_ cameraService: CameraService, mode: CameraMode) {
        if mode == .video {
            HelperManager.stopSound()
        }
        
        let alert: AlertModel = viewModelFactory.makeFinishAlertModel(mode: mode)
        
        view?.showAlert { configurator in
            configurator.title = alert.title
            configurator.message = alert.description
            configurator.actions = [.default(title: alert.defaultButtonText)]
        }
    }
}
