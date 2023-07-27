//
//  UIViewController+Utils.swift
//  EVA-camera-app
//
//  Created by Alex on 27.07.2023.
//

import UIKit

extension UIViewController {
    func showAlert(configure: @escaping (AlertConfigurator) -> Void) {
        DispatchQueue.main.async {
            UIAlertController.show(in: self, configure: configure)
        }
    }
}
