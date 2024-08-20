//
//  MockNetworkManager.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 18.08.2024.
//

import UIKit

class MockNetworkManager: NetworkManagerProtocol {
    
    var fetchRoverDataHandler: ((@escaping (Result<[Rover], MCNetworkingError>) -> Void) -> Void)?
    var fetchPhotosHandler: ((String?, String?, String?, @escaping (Result<[Photo], MCNetworkingError>) -> Void) -> Void)?
    var downloadImageHandler: ((String, @escaping (UIImage?) -> Void) -> Void)?
    
    func fetchRoverData(completion: @escaping (Result<[Rover], MCNetworkingError>) -> Void) {
        guard let fetchRoverDataHandler else {
            fatalError("fetchRoverDataHandler is not set")
        }
        fetchRoverDataHandler(completion)
    }
    
    func fetchPhotos(rover: String?, camera: String?, date: String?, completion: @escaping (Result<[Photo], MCNetworkingError>) -> Void) {
        guard let fetchPhotosHandler else {
            fatalError("fetchPhotosHandler is not set")
        }
        fetchPhotosHandler(rover, camera, date, completion)
    }
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        guard let downloadImageHandler else {
            fatalError("downloadImageHandler is not set")
        }
        downloadImageHandler(urlString, completed)
    }
    
}
