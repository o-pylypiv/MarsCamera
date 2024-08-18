//
//  MockNetworkManagerTests.swift
//  MarsCameraTests
//
//  Created by Olha Pylypiv on 18.08.2024.
//

import XCTest
@testable import MarsCamera

final class MockNetworkManagerTests: XCTestCase {
    
    var mockNetworkManager: MockNetworkManager!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
    }
    
    override func tearDown() {
        mockNetworkManager = nil
        super.tearDown()
    }
    
    func testFetchRoverDataSuccess() {
        let expectedRovers = [
            Rover(id: 5, name: "Curiosity", landingDate: "2012-08-06", launchDate: "2011-11-26", status: "active", maxSol: 4102, maxDate: "2024-02-19", totalPhotos: 695670, cameras: [])
        ]
        mockNetworkManager.fetchRoverDataHandler = { completion in
            completion(.success(expectedRovers))
        }
        let expectation = self.expectation(description: "FetchRoverData")

        mockNetworkManager.fetchRoverData { result in
            switch result {
            case .success(let rovers):
                XCTAssertEqual(rovers.count, 1)
                XCTAssertEqual(rovers.first?.name, "Curiosity")
            case .failure:
                XCTFail("Expected success, but got failure")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchRoverDataFailure() {
        mockNetworkManager.fetchRoverDataHandler = { completion in
            completion(.failure(.unableToComplete))
        }
        let expectation = self.expectation(description: "FetchRoverData")

        mockNetworkManager.fetchRoverData { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error, .unableToComplete)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchPhotosSuccess() {
        let expectedPhotos = [
            Photo(
                id: 872386,
                sol: 3207,
                camera: Camera(
                    id: 20,
                    name: "FHAZ",
                    roverId: 5,
                    fullName: "Front Hazard Avoidance Camera"
                ),
                imgSrc: "https://mars.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/03207/opgs/edr/fcam/FLB_682187717EDR_F0901732FHAZ00341M_.JPG",
                earthDate: "2021-08-14",
                rover: Rover(
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
                        CameraInfo(name: "MAST", fullName: "Mast Camera"),
                        CameraInfo(name: "CHEMCAM", fullName: "Chemistry and Camera Complex"),
                        CameraInfo(name: "MAHLI", fullName: "Mars Hand Lens Imager"),
                        CameraInfo(name: "MARDI", fullName: "Mars Descent Imager"),
                        CameraInfo(name: "RHAZ", fullName: "Rear Hazard Avoidance Camera")
                    ]
                )
            )
        ]
        mockNetworkManager.fetchPhotosHandler = { rover, camera, date, completion in
            completion(.success(expectedPhotos))
        }
        let expectation = self.expectation(description: "FetchPhotos")

        mockNetworkManager.fetchPhotos(rover: "Curiosity", camera: "FHAZ", date: "2021-08-14") { result in
            switch result {
            case .success(let photos):
                XCTAssertEqual(photos.count, 1)
                XCTAssertEqual(photos.first?.camera.name, "FHAZ")
            case .failure:
                XCTFail("Expected success, but got failure")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchPhotosFailure() {
        mockNetworkManager.fetchPhotosHandler = { rover, camera, date, completion in
            completion(.failure(.invalidData))
        }
        let expectation = self.expectation(description: "FetchPhotos")

        mockNetworkManager.fetchPhotos(rover: "Curiosity", camera: "FHAZ", date: "2021-08-14") { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertEqual(error, .invalidData)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testDownloadImageSuccess() {
        let expectedImage = UIImage(systemName: "photo")
        mockNetworkManager.downloadImageHandler = { urlString, completion in
            completion(expectedImage)
        }
        let expectation = self.expectation(description: "DownloadImage")

        mockNetworkManager.downloadImage(from: "http://example.com/image.jpg") { image in
            XCTAssertEqual(image, expectedImage)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testDownloadImageFailure() {
        mockNetworkManager.downloadImageHandler = { urlString, completion in
            completion(nil)
        }
        let expectation = self.expectation(description: "DownloadImage")

        mockNetworkManager.downloadImage(from: "http://example.com/image.jpg") { image in
            XCTAssertNil(image)
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
    
}
