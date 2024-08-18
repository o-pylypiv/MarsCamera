//
//  MockRoverDataProvider.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 18.08.2024.
//

import Foundation

struct MockRoverDataProvider: RoverDataProvider {
    
    var getCachedRoversHandler: (() -> Result<[Rover], Error>)?
    var getDateRangeHandler: (() -> DatesRange?)?
    var cacheRoversHandler: (([Rover]) -> Void)?
    
    func cacheRovers(rovers: [Rover]) {
        guard let cacheRoversHandler else {
            fatalError("cacheRoversHandler is not set")
        }
        
        return cacheRoversHandler(rovers)
    }
        
    func getCachedRovers() -> Result<[Rover], Error> {
        guard let getCachedRoversHandler else {
            fatalError("getCachedRoversHandler is not set")
        }
        
        return getCachedRoversHandler()
    }
    
    func getDateRange() -> DatesRange? {
        guard let getDateRangeHandler else {
            fatalError("getDateRangeHandler is not set")
        }
        
        return getDateRangeHandler()
    }
    
}
