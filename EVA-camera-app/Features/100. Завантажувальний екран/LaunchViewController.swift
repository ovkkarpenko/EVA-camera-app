//
//  LaunchViewController.swift
//  EVA-camera-app
//
//  Created by Alex on 27.07.2023.
//

import UIKit
import SnapKit

protocol LaunchModuleOutput: AnyObject {
    func launchDidOpenHome()
}

protocol ILaunchViewController: UIViewController {
    func reloadView()
}

final class LaunchViewController: BaseViewController {
    
    // Dependencies
    
    private let viewModel: ILaunchViewModel
    
    // UI
    private let titleLabel: UILabel = UILabel()
    private let permissionButton: UIButton = UIButton(type: .system)
    
    // MARK: - Initializers
    
    init(viewModel: ILaunchViewModel) {
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
        viewModel.checkPermissions()
    }
    
    // MARK: - Actions
    
    @objc private func permissionTap() {
        viewModel.didTapPermission()
    }
}

// MARK: - ILaunchViewController

extension LaunchViewController: ILaunchViewController {
    func reloadView() {
        titleLabel.text = viewModel.title
    }
}

// MARK: - SetupUI

extension LaunchViewController {
    private func setupUI() {
        setupTitleLabel()
        setupPermissionButton()
        
        view.backgroundColor = R.color.background()
    }
    
    private func setupTitleLabel() {
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = R.color.primaryText()
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupPermissionButton() {
        permissionButton.tintColor = R.color.link()
        permissionButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        permissionButton.setTitle(R.string.localizable.general_allow(), for: .normal)
        permissionButton.layer.cornerRadius = 6
        permissionButton.layer.borderWidth = 1
        permissionButton.layer.borderColor = R.color.border()?.cgColor
        permissionButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        permissionButton.addTarget(self, action: #selector(permissionTap), for: .touchUpInside)
        
        view.addSubview(permissionButton)
        permissionButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(30)
        }
    }
}
