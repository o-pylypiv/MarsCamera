//
//  UIViewController+Ext.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 13.08.2024.
//

import UIKit

extension UIViewController {
    
    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
}
