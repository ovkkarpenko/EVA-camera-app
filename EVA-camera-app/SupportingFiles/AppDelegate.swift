//
//  AppDelegate.swift
//  EVA-camera-app
//
//  Created by Alex on 27.07.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var launchCoordinator: ILaunchCoordinator?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        launchCoordinator = LaunchCoordinator(with: window, permissionService: PermissionService())
        launchCoordinator?.start()
        
        return true
    }
}
