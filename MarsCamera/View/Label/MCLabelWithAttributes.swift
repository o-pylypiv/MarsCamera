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
            .font: UIFont(name: "SFPro", size: 16) ?? UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor(red: 160/255, green: 160/255, blue: 160/255, alpha: 1)
        ]
        let attributedText = NSMutableAttributedString(string: title, attributes: titleAttributes)

        let bodyAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "SFPro", size: 17) ?? UIFont.boldSystemFont(ofSize: 17),
            .foregroundColor: UIColor.black
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
