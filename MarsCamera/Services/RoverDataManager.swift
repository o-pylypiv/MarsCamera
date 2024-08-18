//
//  RoverDataManager.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 15.08.2024.
//

import Foundation

protocol RoverDataProvider {
    
    typealias DatesRange = (minDate: Date, maxDate: Date)
    
    func cacheRovers(rovers: [Rover])
    func getCachedRovers() -> Result<[Rover], Error>
    func getDateRange() -> DatesRange?
    
}

class RoverDataManager: RoverDataProvider {
        
    var networking = NetworkManager.shared
    static let shared = RoverDataManager()
    
    private let apiKey = "uhRLRSaAadFoRFgUf6QYmEMEgqUkk37DMOkwZee8"
    private let baseURL = "https://api.nasa.gov/mars-photos/api/v1/rovers"
    private let roverDataKey = "CachedRoverData"
    private let dateRangeKey = "CachedDateRange"
    
    init() {
        self.networking.fetchRoverData { [weak self] result in
            switch result {
            case .success(let rovers):
                self?.cacheRovers(rovers: rovers)
            case .failure(let error):
                print("Decoding Error: \(error.localizedDescription)")
            }
        }
    }
        
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
                self.cacheRovers(rovers: roverData.rovers)
                completion(.success(roverData.rovers))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    func cacheRovers(rovers: [Rover]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(rovers) {
            UserDefaults.standard.set(encoded, forKey: roverDataKey)
        }
    }
    
    func getCachedRovers() -> Result<[Rover], Error> {
        if let savedData = UserDefaults.standard.object(forKey: roverDataKey) as? Data {
            let decoder = JSONDecoder()
            do {
                let savedRovers = try decoder.decode([Rover].self, from: savedData)
                return .success(savedRovers)
            } catch {
                return .failure(MCDataProviderError.decodingError)
            }
        }
        return .success([])
    }
    
    func getDateRange() -> DatesRange? {
        let cachedRovers = getCachedRovers()
        guard case .success(let rovers) = cachedRovers else {
            return nil
        }
        return rovers.datesRange
    }
    
}

extension Array where Element == Rover {
    
    var datesRange: RoverDataProvider.DatesRange? {
        guard
            let minDate = self.map(\.landingDate).min()?.convertToDate,
            let maxDate = self.map(\.maxDate).max()?.convertToDate
        else {
            return nil
        }
        return (minDate: minDate, maxDate: maxDate)
    }
    
}
