//
//  NetworkManager.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 08.08.2024.
//

import UIKit

protocol NetworkManagerProtocol {
    
    func fetchRoverData(completion: @escaping (Result<[Rover], MCNetworkingError>) -> Void)
    func fetchPhotos(rover: String?, camera: String?, date: String?, completion: @escaping (Result<[Photo], MCNetworkingError>) -> Void)
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void)
    
}

class NetworkManager: NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    private let apiKey = "uhRLRSaAadFoRFgUf6QYmEMEgqUkk37DMOkwZee8"
    private let baseURL = "https://api.nasa.gov/mars-photos/api/v1/rovers/"
    
    let cache = NSCache<NSString, UIImage>()
    
    func fetchRoverData(completion: @escaping (Result<[Rover], MCNetworkingError>) -> Void) {
        let urlString = "\(baseURL)?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let roverData = try decoder.decode(RoverData.self, from: data)
                completion(.success(roverData.rovers))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }

    func fetchPhotos(rover: String?,
                     camera: String? = nil,
                     date: String? = nil,
                     completion: @escaping (Result<[Photo], MCNetworkingError>) -> Void) {
        
        if rover == nil || rover == "All" {
            fetchPhotosForAllRovers(camera: camera, date: date, completion: completion)
            return
        }
        
        var urlComponents = URLComponents(string: "\(baseURL)\(rover?.lowercased() ?? "curiosity")/photos")!
        var queryItems = [URLQueryItem]()
        
        var camera = camera
        if camera == "All" { camera = nil }
        if let camera = camera { queryItems.append(URLQueryItem(name: "camera", value: camera.lowercased())) }
        if let date = date { queryItems.append(URLQueryItem(name: "earth_date", value: date)) }
        queryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            if response.statusCode == 500 {
                completion(.failure(.serverError))
                return
            }
            
            guard response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let photosResponse = try decoder.decode(PhotoResponse.self, from: data)
                completion(.success(photosResponse.photos))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    private func fetchPhotosForAllRovers(camera: String?, date: String?, completion: @escaping (Result<[Photo], MCNetworkingError>) -> Void) {
        let cachedRoversResult = RoverDataManager.shared.getCachedRovers()

        switch cachedRoversResult {
        case .success(let rovers):
            var allPhotos: [Photo] = []
            let group = DispatchGroup()
            var hasErrorOccurred = false
            
            rovers.forEach { rover in
                group.enter()
                fetchPhotos(rover: rover.name, camera: camera, date: date) { result in
                    defer { group.leave() }
                    
                    switch result {
                    case .success(let photos):
                        if !photos.isEmpty {
                            allPhotos.append(contentsOf: photos)
                        }
                    case .failure:
                        hasErrorOccurred = true
                    }
                }
            }
            
            group.notify(queue: .main) {
                if hasErrorOccurred {
                    completion(.failure(.unableToComplete))
                } else {
                    completion(.success(allPhotos))
                }
            }
            
        case .failure(_):
            completion(.failure(.unableToComplete))
        }
    }
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {return}
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }
    
}
