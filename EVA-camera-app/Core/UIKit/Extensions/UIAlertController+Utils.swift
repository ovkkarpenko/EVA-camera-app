//
//  UIAlertController+Utils.swift
//  EVA-camera-app
//
//  Created by Alex on 27.07.2023.
//

import UIKit

extension UIAlertController {
    class func show(in viewController: UIViewController,
                    configure: (AlertConfigurator) -> Void) {
        let configurator = AlertConfigurator()
        configure(configurator)
        let alertController = UIAlertController(title: configurator.title,
                                                message: configurator.message,
                                                preferredStyle: configurator.style)
        configurator.actions.forEach { alertController.addAction($0) }
        alertController.preferredAction = configurator.prefferedAction
        viewController.present(alertController, animated: true, completion: nil)
    }
}

final class AlertConfigurator {
    var title: String?
    var message: String?
    var style: UIAlertController.Style = .alert
    var actions: [UIAlertAction] = []
    var prefferedAction: UIAlertAction?
}
