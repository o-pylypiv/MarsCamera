//
//  PhotosViewModel.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 08.08.2024.
//

import UIKit

class PhotosViewModel {

    var photos: [Photo] = []
    var selectedDateString: String = "N/A"
    var selectedRover: String?
    var selectedCamera: String?
    var validRovers: [String] = []
    var validCameras: [CameraInfo] = []
    
    var didUpdatePhotos: (() -> Void)?
    var didEncounterError: ((String) -> Void)?
    var didUpdatePickers: (() -> Void)?
    var didSetDateRange: ((Date, Date) -> Void)?
    var didStartLoading: (() -> Void)?
    var didEndLoading: (() -> Void)?
    
    func updateFilters(rover: String?, camera: String?) {
        selectedRover = rover
        selectedCamera = camera
    }
    
    func fetchRoverData() {
        didStartLoading?()
        RoverDataManager.shared.fetchRoverData { [weak self] result in
            switch result {
            case .success:
                self?.setDateRange()
                self?.fetchPhotosForAllRovers()
            case .failure(let error):
                self?.didEncounterError?(error.rawValue)
                self?.didEndLoading?()
            }
        }
    }
    
    private func setDateRange() {
        guard let dateRange = RoverDataManager.shared.getDateRange() else {
            didEncounterError?("Failed to get date range.")
            didEndLoading?()
            return
        }
        selectedDateString = dateRange.maxDate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let minDate = dateFormatter.date(from: dateRange.minDate),
           let maxDate = dateFormatter.date(from: dateRange.maxDate) {
            DispatchQueue.main.async {
                self.didSetDateRange?(minDate, maxDate)
                self.didEndLoading?()
            }
        } else {
            didEncounterError?("Failed to parse date range.")
            didEndLoading?()
        }
    }
    
    func getPhotos() {
        if selectedDateString == "N/A" {
            didEncounterError?("Invalid date. Please select a valid date.")
            return
        }
        
        didStartLoading?()
        if selectedCamera == "All" { selectedCamera = nil }

        if let rover = selectedRover, rover != "All" {
            fetchPhotos(rover: rover, camera: selectedCamera, date: selectedDateString)
        } else {
            fetchPhotosForAllRovers()
        }
    }
    
    private func fetchPhotos(rover: String?, camera: String?, date: String?) {
        NetworkManager.shared.fetchPhotos(rover: rover, camera: camera, date: date) { [weak self] result in
            defer { self?.didEndLoading?() }
            
            switch result {
            case .success(let photos):
                self?.photos = photos
                self?.didUpdatePhotos?()
            case .failure(let error):
                self?.didEncounterError?(error.rawValue)
            }
        }
    }
    
    private func fetchPhotosForAllRovers() {
        let rovers = RoverDataManager.shared.getCachedRovers()
        var validRovers: [String] = []
        var validCameras: Set<CameraInfo> = []
        let group = DispatchGroup()
        var allPhotos: [Photo] = []
        var hasErrorOccurred = false
        
        rovers.forEach { rover in
            group.enter()
            NetworkManager.shared.fetchPhotos(rover: rover.name, camera: selectedCamera, date: selectedDateString) { result in
                defer { group.leave() }
                
                switch result {
                case .success(let photos):
                    if !photos.isEmpty {
                        validRovers.append(rover.name)
                        photos.forEach { photo in
                            if let cameraInfo = rover.cameras.first(where: { $0.name == photo.camera.name }) {
                                validCameras.insert(cameraInfo)
                            }
                        }
                        allPhotos.append(contentsOf: photos)
                    }
                case .failure:
                    hasErrorOccurred = true
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.didEndLoading?()
            
            if hasErrorOccurred {
                self?.didEncounterError?("Failed to load photos. Please try again later.")
            } else {
                self?.photos = allPhotos
                self?.validRovers = validRovers
                self?.validCameras = Array(validCameras)
                DispatchQueue.main.async {
                    self?.didUpdatePhotos?()
                    self?.didUpdatePickers?()
                }
                print("Updating pickers with rovers: \(validRovers), cameras: \(Array(validCameras.map { $0.name }))")
            }
        }
    }

    func getRovers() -> [String] {
        return RoverDataManager.shared.getCachedRovers().map { $0.name }
    }
}
