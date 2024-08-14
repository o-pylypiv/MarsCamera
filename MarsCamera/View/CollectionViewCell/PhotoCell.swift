//
//  PhotoCell.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 09.08.2024.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    static let reuseID = "PhotoCell"
    
    let photoImageView = MCPhotoImageView(frame: .zero)
    let roverLabel = MCLabelWithAttributes()
    let cameraLabel = MCLabelWithAttributes()
    let dateLabel = MCLabelWithAttributes()
    
    let padding: CGFloat = 16
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        configureCellAppearance()
        
        contentView.addSubview(photoImageView)
        contentView.addSubview(roverLabel)
        contentView.addSubview(cameraLabel)
        contentView.addSubview(dateLabel)
        
        configurePhotoImageView()
        configureLabels()
    }
    
    private func configureCellAppearance() {
        layer.cornerRadius = 30
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        
        contentView.layer.cornerRadius = 30
        contentView.layer.masksToBounds = true
        backgroundColor = .white
    }
    
    private func configurePhotoImageView() {
        NSLayoutConstraint.activate([
            photoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            photoImageView.heightAnchor.constraint(equalToConstant: 130),
            photoImageView.widthAnchor.constraint(equalTo: photoImageView.heightAnchor),
        ])
    }
    
    private func configureLabels() {
        NSLayoutConstraint.activate([
            roverLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: padding),
            roverLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            roverLabel.trailingAnchor.constraint(equalTo: photoImageView.leadingAnchor, constant: -10),
            
            cameraLabel.topAnchor.constraint(equalTo: roverLabel.bottomAnchor, constant: 4),
            cameraLabel.leadingAnchor.constraint(equalTo: roverLabel.leadingAnchor),
            cameraLabel.trailingAnchor.constraint(equalTo: roverLabel.trailingAnchor),
            cameraLabel.centerYAnchor.constraint(equalTo: photoImageView.centerYAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: cameraLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: roverLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: roverLabel.trailingAnchor),
            dateLabel.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: -padding),
        ])
    }
    
    func set(photo: Photo) {
        photoImageView.downloadPhoto(fromURL: photo.imgSrc)
        roverLabel.set(title: "Rover: ", body: photo.rover.name)
        cameraLabel.set(title: "Camera: ", body: photo.camera.fullName)
        dateLabel.set(title: "Date: ", body: photo.earthDate.convertToDisplayFormat())
    }
}
