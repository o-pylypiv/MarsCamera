//
//  MCEmptyStateView.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 12.08.2024.
//

import UIKit

class MCEmptyStateView: UIView {
    
    let messageLabel = UILabel()
    let placeholderImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }
    
    private func configure() {
        addSubview(placeholderImageView)
        addSubview(messageLabel)
        
        configureLogoImageView()
        configureMessageLabel()
        backgroundColor = .backgroundOne
    }
    
    private func configureLogoImageView() {
        placeholderImageView.image = UIImage(resource: .emptyPlaceholder)
        placeholderImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeholderImageView.widthAnchor.constraint(equalToConstant: 145),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 145),
            placeholderImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -40)
        ])
    }
    
    private func configureMessageLabel() {
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.customBody

        messageLabel.textColor = .layerTwo
        messageLabel.adjustsFontSizeToFitWidth = true
        messageLabel.minimumScaleFactor = 0.9
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.numberOfLines = 3
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 20),
            messageLabel.centerXAnchor.constraint(equalTo: placeholderImageView.centerXAnchor),
            messageLabel.widthAnchor.constraint(equalToConstant: 220),
            messageLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }
    
}
