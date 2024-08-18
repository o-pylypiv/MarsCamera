//
//  MockRoverDataProviderTests.swift
//  MarsCameraTests
//
//  Created by Olha Pylypiv on 18.08.2024.
//

import XCTest
@testable import MarsCamera

final class MockRoverDataProviderTests: XCTestCase {
    
    var mockDataProvider: MockRoverDataProvider!
    
    override func setUp() {
        super.setUp()
        mockDataProvider = MockRoverDataProvider()
    }
    
    override func tearDown() {
        mockDataProvider = nil
        super.tearDown()
    }
    
    func testCacheRovers() {
        let expectation = self.expectation(description: "CacheRoversHandler was called")
        var roversCached: [Rover]?
        
        mockDataProvider.cacheRoversHandler = { rovers in
            roversCached = rovers
            expectation.fulfill()
        }
        
        let testRovers = createTestRovers()
        mockDataProvider.cacheRovers(rovers: testRovers)
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertEqual(roversCached, testRovers)
    }
    
    func testGetCachedRoversSuccess() {
        let testRovers = createTestRovers()
        
        mockDataProvider.getCachedRoversHandler = {
            return .success(testRovers)
        }
        
        let result = mockDataProvider.getCachedRovers()
        
        switch result {
        case .success(let rovers):
            XCTAssertEqual(rovers, testRovers)
        case .failure:
            XCTFail("Expected success, but got failure")
        }
    }
    
    func testGetCachedRoversFailure() {
        mockDataProvider.getCachedRoversHandler = {
            return .failure(NSError(domain: "TestError", code: 1, userInfo: nil))
        }
        
        let result = mockDataProvider.getCachedRovers()
        
        switch result {
        case .success:
            XCTFail("Expected failure, but got success")
        case .failure(let error):
            XCTAssertEqual((error as NSError).domain, "TestError")
        }
    }
    
    func testGetDateRangeSuccess() {
        let expectedRange: RoverDataProvider.DatesRange = (minDate: Date(), maxDate: Date())
        
        mockDataProvider.getDateRangeHandler = {
            return expectedRange
        }
        let dateRange = mockDataProvider.getDateRange()
        
        XCTAssertNotNil(dateRange)
        XCTAssertEqual(dateRange?.minDate, expectedRange.minDate)
        XCTAssertEqual(dateRange?.maxDate, expectedRange.maxDate)
    }
    
    func testGetDateRangeNil() {
        mockDataProvider.getDateRangeHandler = {
            return nil
        }
        let dateRange = mockDataProvider.getDateRange()
        
        XCTAssertNil(dateRange)
    }
    
    private func createTestRovers() -> [Rover] {
        let curiosity = Rover(
            id: 5,
            name: "Curiosity",
            landingDate: "2012-08-06",
            launchDate: "2011-11-26",
            status: "active",
            maxSol: 4102,
            maxDate: "2024-02-19",
            totalPhotos: 695670,
            cameras: [
                CameraInfo(name: "FHAZ", fullName: "Front Hazard Avoidance Camera"),
                CameraInfo(name: "NAVCAM", fullName: "Navigation Camera"),
                CameraInfo(name: "MAST", fullName: "Mast Camera")
            ]
        )
        
        let spirit = Rover(
            id: 7,
            name: "Spirit",
            landingDate: "2004-01-04",
            launchDate: "2003-06-10",
            status: "complete",
            maxSol: 2208,
            maxDate: "2010-03-21",
            totalPhotos: 124550,
            cameras: [
                CameraInfo(name: "FHAZ", fullName: "Front Hazard Avoidance Camera"),
                CameraInfo(name: "NAVCAM", fullName: "Navigation Camera"),
                CameraInfo(name: "PANCAM", fullName: "Panoramic Camera")
            ]
        )
        
        return [curiosity, spirit]
    }
}
