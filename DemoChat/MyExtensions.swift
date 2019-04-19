//
//  MyExtensions.swift
//  DemoChat
//
//  Created by bruce on 2019/4/19.
//  Copyright © 2019 bruce. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func showMessage(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
        
        // duration in seconds
        let duration: Double = 5
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
        }
    }
}
