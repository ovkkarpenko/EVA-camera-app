//
//  CameraViewController.swift
//  EVA-camera-app
//
//  Created by Alex on 27.07.2023.
//

import UIKit
import AVFoundation

final class CameraViewController: BaseViewController {
    
    // Dependencies
    private let viewModel: ICameraViewModel
    
    // UI
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private let loadingLabel: UILabel = UILabel()
    private let actionButton: UIButton = UIButton(type: .system)
    private let switchCameraButton: UIButton = UIButton(type: .system)
    private let cameraModeSegment: UISegmentedControl = UISegmentedControl(
        items: [
            R.string.localizable.camera_mode1(),
            R.string.localizable.camera_mode2(),
        ]
    )
    
    // MARK: - Initializers
    
    init(viewModel: ICameraViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        viewModel.didLoad()
    }
    
    // MARK: - Actions
    
    @objc private func actionTap() {
        viewModel.didTapAction()
    }
    
    @objc private func switchCameraTap() {
        viewModel.didTapSwitchCamera()
    }
    
    @objc private func cameraModeChanged() {
        viewModel.didTapCameraMode(index: cameraModeSegment.selectedSegmentIndex)
    }
}

// MARK: - CameraViewDelegate

extension CameraViewController: CameraViewDelegate {
    func reloadView(isRecording: Bool) {
        actionButton.setImage(
            isRecording
                ? R.image.ic_camera_stop()?.withRenderingMode(.alwaysTemplate)
                : R.image.ic_camera()?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
    }
    
    func setupPreviewLayer(with captureSession: AVCaptureSession) {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        self.previewLayer?.removeFromSuperlayer()
        self.previewLayer = nil
        self.previewLayer = previewLayer
        view.layer.insertSublayer(previewLayer, at: 0)
        
        loadingLabel.isHidden = true
        actionButton.isHidden = false
        cameraModeSegment.isHidden = false
        switchCameraButton.isHidden = false
    }
}

// MARK: - SetupUI

extension CameraViewController {
    private func setupUI() {
        setupLoadingLabel()
        setupActionButton()
        setupSwitchCameraButton()
        setupCameraModeSegment()
        
        view.backgroundColor = R.color.background()
    }
    
    private func setupLoadingLabel() {
        loadingLabel.textColor = R.color.primaryText()
        loadingLabel.textAlignment = .center
        loadingLabel.font = .systemFont(ofSize: 14)
        loadingLabel.text = R.string.localizable.general_loading()
        
        view.addSubview(loadingLabel)
        loadingLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupActionButton() {
        actionButton.isHidden = true
        actionButton.tintColor = R.color.image()
        actionButton.addTarget(self, action: #selector(actionTap), for: .touchUpInside)
        
        view.addSubview(actionButton)
        actionButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.size.equalTo(60)
        }
    }
    
    private func setupSwitchCameraButton() {
        switchCameraButton.isHidden = true
        switchCameraButton.tintColor = R.color.image()
        switchCameraButton.setImage(R.image.ic_camera_switch()?.withRenderingMode(.alwaysTemplate), for: .normal)
        switchCameraButton.addTarget(self, action: #selector(switchCameraTap), for: .touchUpInside)
        
        view.addSubview(switchCameraButton)
        switchCameraButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(30)
            $0.centerY.equalTo(actionButton)
            $0.size.equalTo(50)
        }
    }
    
    private func setupCameraModeSegment() {
        cameraModeSegment.isHidden = true
        cameraModeSegment.selectedSegmentIndex = 0
        cameraModeSegment.selectedSegmentTintColor = R.color.link()
        cameraModeSegment.layer.borderWidth = 1
        cameraModeSegment.layer.borderColor = R.color.border()?.cgColor
        cameraModeSegment.layer.cornerRadius = 6
        cameraModeSegment.addTarget(self, action: #selector(cameraModeChanged), for: .valueChanged)
        
        view.addSubview(cameraModeSegment)
        cameraModeSegment.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(actionButton.snp.top).offset(-20)
        }
    }
}
