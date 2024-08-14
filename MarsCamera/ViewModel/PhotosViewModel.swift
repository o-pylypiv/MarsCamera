//
//  PhotosViewModel.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 08.08.2024.
//

import UIKit

class PhotosViewModel {
    var photos: [Photo] = []
   
    var didUpdatePhotos: (() -> Void)?
    var didEncounterError: ((String) -> Void)?
    
    func fetchPhotos(rover: String?, camera: String?, date: String?, completion: ((Result<[Photo], MCError>) -> Void)? = nil) {
        
        NetworkManager.shared.fetchPhotos(rover: rover, camera: camera, date: date) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos = photos
                DispatchQueue.main.async {
                    self?.didUpdatePhotos?()
                    completion?(.success(photos))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.didEncounterError?(error.rawValue)
                    completion?(.failure(error))
                }
            }
        }
    }
}
