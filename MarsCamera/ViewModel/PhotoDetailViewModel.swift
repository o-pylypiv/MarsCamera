//
//  PhotoDetailViewModel.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 12.08.2024.
//

import Foundation

class PhotoDetailViewModel {
    let photo: Photo
    
    init(photo: Photo) {
        self.photo = photo
    }
    var imageURL: URL? { return URL(string: photo.imgSrc) }
}
