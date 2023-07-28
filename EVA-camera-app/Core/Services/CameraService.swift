//
//  CameraService.swift
//  EVA-camera-app
//
//  Created by Alex on 27.07.2023.
//

import UIKit
import Photos
import AVFoundation

protocol ICameraService: NSObject {
    var isRecording: Bool { get }
    
    func setDelegate(_ delegate: CameraServiceDelegate?)
    func startRunning(_ completion: ((AVCaptureSession?) -> Void)?)
    func switchMode(_ mode: CameraMode)
    func switchCamera()
    func action()
}

protocol CameraServiceDelegate: AnyObject {
    func cameraService(_ cameraService: CameraService, isRecording: Bool)
    func cameraServiceStart(_ cameraService: CameraService, mode: CameraMode)
    func cameraServiceFinish(_ cameraService: CameraService, mode: CameraMode)
    func cameraServiceError(_ cameraService: CameraService)
    func cameraServiceSetupIsComplete(_ cameraService: CameraService)
}

enum CameraMode: Int, CaseIterable {
    case photo
    case video
}

final class CameraService: NSObject, ICameraService {
    // Dependencies
    weak var delegate: CameraServiceDelegate?
    private let photoOutput: AVCapturePhotoOutput = AVCapturePhotoOutput()
    private let videoOutput: AVCaptureMovieFileOutput = AVCaptureMovieFileOutput()
    private let captureSession: AVCaptureSession = AVCaptureSession()
    
    // Properties
    var isRecording: Bool = false {
        didSet { delegate?.cameraService(self, isRecording: isRecording) }
    }
    private var isBackCamera: Bool = true
    private var selectedMode: CameraMode = .photo
    
    // MARK: - ICameraService
    
    func setDelegate(_ delegate: CameraServiceDelegate?) {
        self.delegate = delegate
    }
    
    func startRunning(_ completion: ((AVCaptureSession?) -> Void)?) {
        isRecording = false
        captureSession.usesApplicationAudioSession = false
        updateCaptureSession()
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession.startRunning()
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                completion?(self.captureSession)
            }
        }
    }
    
    func switchMode(_ mode: CameraMode) {
        selectedMode = mode
        updateCaptureSession()
    }
    
    func switchCamera() {
        isBackCamera.toggle()
        updateCaptureSession()
    }
    
    func action() {
        switch selectedMode {
        case .photo:
            makePhoto()
            
        case .video:
            if isRecording {
                videoOutput.stopRecording()
            } else {
                startRecordingVideo()
            }
            isRecording.toggle()
        }
    }
    
    // MARK: - Private
    
    private func updateCaptureSession() {
        guard let input = getInput() else {
            delegate?.cameraServiceError(self)
            return
        }
        
        captureSession.beginConfiguration()
        
        captureSession.inputs.forEach { captureSession.removeInput($0) }
        captureSession.outputs.forEach { captureSession.removeOutput($0) }
        
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        } else {
            delegate?.cameraServiceError(self)
            return
        }
        
        if captureSession.canAddOutput(getOuput()) {
            captureSession.addOutput(getOuput())
        } else {
            delegate?.cameraServiceError(self)
            return
        }
        
        captureSession.commitConfiguration()
        delegate?.cameraServiceSetupIsComplete(self)
    }
    
    private func getInput() -> AVCaptureDeviceInput? {
        guard
            let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: isBackCamera ? .back : .front),
            let videoInput = try? AVCaptureDeviceInput(device: videoDevice)
        else {
            delegate?.cameraServiceError(self)
            return nil
        }
        
        return videoInput
    }
    
    private func getOuput() -> AVCaptureOutput {
        switch selectedMode {
        case .photo:
            return photoOutput
        case .video:
            return videoOutput
        }
    }
    
    private func makePhoto() {
        let photoSettings: AVCapturePhotoSettings = AVCapturePhotoSettings()
        
        if let photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
            
            delegate?.cameraServiceStart(self, mode: selectedMode)
        }
    }
    
    private func startRecordingVideo() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard let fileUrl = paths.first?.appendingPathComponent("output.mov") else {
            delegate?.cameraServiceError(self)
            return
        }
        try? FileManager.default.removeItem(at: fileUrl)
        videoOutput.startRecording(to: fileUrl, recordingDelegate: self as AVCaptureFileOutputRecordingDelegate)
        
        delegate?.cameraServiceStart(self, mode: selectedMode)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension CameraService: AVCapturePhotoCaptureDelegate {
    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        guard
            let imageData = photo.fileDataRepresentation(),
            let previewImage: UIImage = UIImage(data: imageData)
        else { return }
        
        do {
            try PHPhotoLibrary.shared().performChangesAndWait { [weak self] in
                guard let self = self else { return }
                PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
                delegate?.cameraServiceFinish(self, mode: selectedMode)
            }
        } catch {
            delegate?.cameraServiceError(self)
        }
    }
}

// MARK: - AVCaptureFileOutputRecordingDelegate

extension CameraService: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(
        _ output: AVCaptureFileOutput,
        didFinishRecordingTo outputFileURL: URL,
        from connections: [AVCaptureConnection],
        error: Error?
    ) {
        if error == nil {
            UISaveVideoAtPathToSavedPhotosAlbum(outputFileURL.path, nil, nil, nil)
            delegate?.cameraServiceFinish(self, mode: selectedMode)
        } else {
            isRecording = false
        }
    }
}
