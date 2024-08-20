//
//  HistoryCell.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 14.08.2024.
//

import UIKit

class HistoryCell: UICollectionViewCell {
    
    static let reuseID = "HistoryCell"
    
    let roverLabel = MCLabelWithAttributes()
    let cameraLabel = MCLabelWithAttributes()
    let dateLabel = MCLabelWithAttributes()
    let separatorView = UIView()
    let filtersTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        configureUIElements()
        setupCell()
    }
    
    private func configureUIElements() {
        layer.cornerRadius = 30
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        
        contentView.layer.cornerRadius = 30
        contentView.layer.masksToBounds = true
        backgroundColor = .backgroundOne
        
        separatorView.backgroundColor = .accentOne
        
        filtersTitleLabel.text = "Filters"
        filtersTitleLabel.font = .customTitle2
        filtersTitleLabel.textColor = .accentOne
    }
    
    private func setupCell() {
        let padding: CGFloat = 16
        let spacing: CGFloat = 10
        
        let labelStackView = UIStackView(arrangedSubviews: [roverLabel, cameraLabel, dateLabel])
        labelStackView.axis = .vertical
        labelStackView.alignment = .leading
        labelStackView.spacing = 6
        
        contentView.addSubview(separatorView)
        contentView.addSubview(filtersTitleLabel)
        contentView.addSubview(labelStackView)
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        filtersTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            filtersTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
            filtersTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            filtersTitleLabel.heightAnchor.constraint(equalToConstant: 28),
            filtersTitleLabel.widthAnchor.constraint(equalToConstant: 70),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            separatorView.trailingAnchor.constraint(equalTo: filtersTitleLabel.leadingAnchor, constant: -spacing),
            separatorView.centerYAnchor.constraint(equalTo: filtersTitleLabel.centerYAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            labelStackView.topAnchor.constraint(greaterThanOrEqualTo: filtersTitleLabel.bottomAnchor, constant: 2),
            labelStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            labelStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
            
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }
    
    func set(filter: SavedFilter) {
        if let photoDate = filter.photoDate?.appPreviewString {
            let roverName = filter.roverName ?? "All"
            let cameraFullName = filter.cameraFullName ?? "All"
            
            roverLabel.set(title: "Rover: ", body: roverName)
            cameraLabel.set(title: "Camera: ", body: cameraFullName)
            dateLabel.set(title: "Date: ", body: photoDate)
        }
    }
    
}
