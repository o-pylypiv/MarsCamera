//
//  MCPhotoImageView.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 09.08.2024.
//

import UIKit

class MCPhotoImageView: UIImageView {
    
    let placeholderImage = UIImage(resource: .emptyPlaceholder)
    let cache = NetworkManager.shared.cache
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        layer.cornerRadius = 20
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func downloadPhoto(fromURL url: String) {
        NetworkManager.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.image = image ?? self.placeholderImage
            }
        }
    }
    
}
