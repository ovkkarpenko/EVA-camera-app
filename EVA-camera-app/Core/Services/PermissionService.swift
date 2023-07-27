//
//  PermissionService.swift
//  EVA-camera-app
//
//  Created by Alex on 27.07.2023.
//

import UIKit
import Photos

protocol IPermissionService {
    func isGrantedCameraAccess() -> Bool
    func isGrantedLibraryAccess() -> Bool
    
    func requestCameraAccess(completion: ((Bool) -> Void)?)
    func requestLibraryAccess(completion: ((Bool) -> Void)?)
}

final class PermissionService: IPermissionService {
    // MARK: - IPermissionService
    
    func isGrantedCameraAccess() -> Bool {
        AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == AVAuthorizationStatus.authorized &&
            UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    func isGrantedLibraryAccess() -> Bool {
        PHPhotoLibrary.authorizationStatus(for: .addOnly) == .authorized
    }
    
    func requestCameraAccess(completion: ((Bool) -> Void)?) {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { isGranted in
            DispatchQueue.main.async {
                if isGranted && UIImagePickerController.isSourceTypeAvailable(.camera) {
                    completion?(true)
                } else {
                    completion?(false)
                }
            }
        })
    }
    
    func requestLibraryAccess(completion: ((Bool) -> Void)?) {
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            DispatchQueue.main.async {
                completion?(status == .authorized)
            }
        }
    }
}
