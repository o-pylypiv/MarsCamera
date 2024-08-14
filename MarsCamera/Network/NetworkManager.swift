//
//  NetworkManager.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 08.08.2024.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private let apiKey = "uhRLRSaAadFoRFgUf6QYmEMEgqUkk37DMOkwZee8"
    private let baseURL = "https://api.nasa.gov/mars-photos/api/v1/rovers/"
    
    let cache = NSCache<NSString, UIImage>()
    
    func fetchPhotos(rover: String? = "curiosity",
                     camera: String? = nil,
                     date: String? = nil,
                     completion: @escaping (Result<[Photo], MCError>) -> Void) {
        
        var urlComponents = URLComponents(string: "\(baseURL)\(rover?.lowercased() ?? "curiosity")/photos")!
        var queryItems = [URLQueryItem]()
        
        if let camera = camera { queryItems.append(URLQueryItem(name: "camera", value: camera.lowercased())) }
        if let date = date { queryItems.append(URLQueryItem(name: "earth_date", value: date)) }
        queryItems.append(URLQueryItem(name: "api_key", value: apiKey))
        
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        print("Request URL: \(url)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            print("ResponseCode: \(response.statusCode)")
            
            if response.statusCode == 500 {
                print("Server error. Please try again later.")
                completion(.failure(.serverError))
                return
            }
            
            guard response.statusCode == 200 else {
                print("Invalid response status code: \(response.statusCode)")
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                print("No data received.")
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let photosResponse = try decoder.decode(PhotoResponse.self, from: data)
                completion(.success(photosResponse.photos))
            } catch {
                print("Decoding Error: \(error.localizedDescription)")
                completion(.failure(.invalidData))
            }
        }
        task.resume()
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
