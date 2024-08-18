//
//  MCIconTextButton.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 12.08.2024.
//


import UIKit

class MCIconTextButton: UIButton {
    
    private let iconImageView = UIImageView()
    private let buttonLabel = UILabel()
    
    init(icon: UIImage?, title: String?) {
        super.init(frame: .zero)
        setupViews(icon: icon, title: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews(icon: UIImage?, title: String?) {
        iconImageView.image = icon
        iconImageView.contentMode = .scaleAspectFit
        addSubview(iconImageView)
        
        buttonLabel.text = title
        buttonLabel.textColor = .layerOne
        buttonLabel.font = UIFont.customBody2
        buttonLabel.numberOfLines = 1
        buttonLabel.adjustsFontSizeToFitWidth = true
        buttonLabel.minimumScaleFactor = 0.7
        
        if title != nil {
            buttonLabel.isHidden = false
            addSubview(buttonLabel)
            iconImageView.translatesAutoresizingMaskIntoConstraints = false
            buttonLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                iconImageView.widthAnchor.constraint(equalToConstant: 20),
                iconImageView.heightAnchor.constraint(equalToConstant: 20),
                
                buttonLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
                buttonLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                buttonLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        } else {
            buttonLabel.isHidden = true
            iconImageView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                iconImageView.widthAnchor.constraint(equalToConstant: 24),
                iconImageView.heightAnchor.constraint(equalToConstant: 24)
            ])
        }
        
        backgroundColor = .white
        layer.cornerRadius = 10
    }
    
    func setSize(width: CGFloat, height: CGFloat, iconSize: CGFloat?) {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(lessThanOrEqualToConstant: width),
            heightAnchor.constraint(equalToConstant: height)
        ])
        
        if let iconSize = iconSize {
            for constraint in iconImageView.constraints {
                if constraint.firstAttribute == .width || constraint.firstAttribute == .height {
                    constraint.isActive = false
                }
            }
            iconImageView.widthAnchor.constraint(equalToConstant: iconSize).isActive = true
            iconImageView.heightAnchor.constraint(equalToConstant: iconSize).isActive = true
        }
    }
    
    func changeTitle(newTitle: String) {
        buttonLabel.text = newTitle
    }
    
    func getTitle() -> String? {
        return buttonLabel.text
    }
    
}
