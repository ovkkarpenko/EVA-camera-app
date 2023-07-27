//
//  BaseViewController.swift
//  EVA-camera-app
//
//  Created by Alex on 27.07.2023.
//

import UIKit

class BaseViewController: UIViewController {
    var backImage: UIImage? {
        UIImage(named: "ic_arrow_left")
    }
    
    override var prefersStatusBarHidden: Bool {
        false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
