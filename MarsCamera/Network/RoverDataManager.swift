//
//  RoverDataManager.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 15.08.2024.
//

import Foundation

class RoverDataManager {
    static let shared = RoverDataManager()
    private let apiKey = "uhRLRSaAadFoRFgUf6QYmEMEgqUkk37DMOkwZee8"
    private let baseURL = "https://api.nasa.gov/mars-photos/api/v1/rovers"
    private let userDefaultsKey = "CachedRoverData"
    private let dateRangeKey = "CachedDateRange"
    var rovers: [Rover] = []
    
    private init() {
        loadCachedRovers()
    }
    
    func fetchRoverData(completion: @escaping (Result<[Rover], MCError>) -> Void) {
        let urlString = "\(baseURL)?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(.failure(.unableToComplete))
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
                let roverData = try decoder.decode(RoverData.self, from: data)
                self.rovers = roverData.rovers
                self.cacheRovers() 
                completion(.success(self.rovers))
            } catch {
                print("Decoding Error: \(error.localizedDescription)")
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    private func cacheRovers() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(rovers) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    func loadCachedRovers() {
        if let savedData = UserDefaults.standard.object(forKey: userDefaultsKey) as? Data {
            let decoder = JSONDecoder()
            if let savedRovers = try? decoder.decode([Rover].self, from: savedData) {
                self.rovers = savedRovers
            }
        }
    }
    
    func getDateRange() -> (minDate: String, maxDate: String)? {
        guard let minDate = rovers.map({ $0.landingDate }).min(),
              let maxDate = rovers.map({ $0.maxDate }).max() else {
            return nil
        }
        return (minDate, maxDate)
    }
    
    func getCachedRovers() -> [Rover] {
        return rovers
    }
}
