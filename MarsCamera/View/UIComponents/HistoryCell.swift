//
//  HistoryCell.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 14.08.2024.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    static let reuseID = "HistoryCell"
    
    private let roverLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.customBody2
        label.textColor = .layerOne
        return label
    }()
    
    private let cameraLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    private let filtersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Filters", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        contentView.backgroundColor = .backgroundOne
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.orange.cgColor
        
        let stackView = UIStackView(arrangedSubviews: [roverLabel, cameraLabel, dateLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4
        
        contentView.addSubview(stackView)
        contentView.addSubview(filtersButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        filtersButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            filtersButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            filtersButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            contentView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func configure(rover: String, camera: String, date: String) {
        roverLabel.text = "Rover: \(rover)"
        cameraLabel.text = "Camera: \(camera)"
        dateLabel.text = "Date: \(date)"
    }
    
}
