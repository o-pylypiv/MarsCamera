//
//  MCLabelWithAttributes.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 09.08.2024.
//

import UIKit

class MCLabelWithAttributes: UILabel {
    
        init() {
            super.init(frame: .zero)
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
    
    func set(title: String, body: String) {
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.customBody,
            .foregroundColor: UIColor.layerTwo
        ]
        let attributedText = NSMutableAttributedString(string: title, attributes: titleAttributes)

        let bodyAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.customBody2,
            .foregroundColor: UIColor.layerOne
        ]
        let bodyString = NSAttributedString(string: body, attributes: bodyAttributes)

        attributedText.append(bodyString)
        self.attributedText = attributedText
        
        self.numberOfLines = 0
        self.translatesAutoresizingMaskIntoConstraints = false
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.8
        self.lineBreakMode = .byWordWrapping
        self.textAlignment = .left
    }
    
}
