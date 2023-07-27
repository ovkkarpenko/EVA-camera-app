//
//  UIAlertAction+Utils.swift
//  EVA-camera-app
//
//  Created by Alex on 27.07.2023.
//

import UIKit

extension UIAlertAction {
    class func cancel(title: String?, handler: (() -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: title, style: .cancel, handler: { _ in
            handler?()
        })
    }
    
    class func destructive(title: String?, handler: (() -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: title, style: .destructive, handler: { _ in
            handler?()
        })
    }
    
    class func `default`(title: String?, style: UIAlertAction.Style = .default,
                         handler: (() -> Void)? = nil) -> UIAlertAction {
        return UIAlertAction(title: title, style: style, handler: { _ in
            handler?()
        })
    }
}

