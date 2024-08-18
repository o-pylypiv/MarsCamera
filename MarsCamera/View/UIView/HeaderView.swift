//
//  HeaderView.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 11.08.2024.
//

import UIKit

class HeaderView: UIView {
    
    var onDateButtonTapped: (() -> Void)?
    var onRoverButtonTapped: (() -> Void)?
    var onCameraButtonTapped: (() -> Void)?
    var onSaveButtonTapped: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "MARS.CAMERA"
        label.font = UIFont.customLargeTitle
        
        let attributedString = NSMutableAttributedString(string: label.text ?? "")
        let letterSpacing: CGFloat = -0.4
        attributedString.addAttribute(NSAttributedString.Key.kern, value: letterSpacing, range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
        
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customBody2
        return label
    }()
    
    private let calendarButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .calendar), for: .normal)
        return button
    }()
    
    let roverFilterButton = MCIconTextButton(icon: UIImage(resource: .roverIcon), title: "All")
    let cameraFilterButton = MCIconTextButton(icon: UIImage(resource: .cameraIcon), title: "All")
    let saveFiltersButton = MCIconTextButton(icon: UIImage(resource: .plusIcon), title: nil)
    
    init() {
        super.init(frame: .zero)
        setupView()
        calendarButton.addTarget(self, action: #selector(calendarButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .accentOne
        setupTitleStack()
        setupButtonStack()
    }
    
    private func setupTitleStack() {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        
        addSubview(stackView)
        addSubview(calendarButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        calendarButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 56) ,
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 19),
            stackView.widthAnchor.constraint(equalToConstant: 280),
            stackView.heightAnchor.constraint(equalToConstant: 68),
            
            calendarButton.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            calendarButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17),
            calendarButton.widthAnchor.constraint(equalToConstant: 44),
            calendarButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupButtonStack() {
        roverFilterButton.setSize(width: 140, height: 38, iconSize: nil)
        cameraFilterButton.setSize(width: 140, height: 38, iconSize: nil)
        saveFiltersButton.setSize(width: 38, height: 38, iconSize: nil)
        
        let buttonsStackView = UIStackView(arrangedSubviews: [roverFilterButton, cameraFilterButton, saveFiltersButton])
        buttonsStackView.axis = .horizontal
        buttonsStackView.alignment = .fill
        buttonsStackView.spacing = 12
        buttonsStackView.setCustomSpacing(23, after: cameraFilterButton)
        
        addSubview(buttonsStackView)
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonsStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 38)
        ])
        roverFilterButton.addTarget(self, action: #selector(roverButtonTapped), for: .touchUpInside)
        cameraFilterButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        saveFiltersButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc private func roverButtonTapped() {
        onRoverButtonTapped?()
    }
    
    @objc private func cameraButtonTapped() {
        onCameraButtonTapped?()
    }
    
    @objc private func saveButtonTapped() {
        onSaveButtonTapped?()
    }
    
    func setDateLabel(_ date: String) {
        subtitleLabel.text = date
    }
    
    @objc private func calendarButtonTapped() {
        onDateButtonTapped?()
    }
    
}
