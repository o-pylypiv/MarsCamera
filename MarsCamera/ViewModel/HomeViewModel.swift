//
//  HomeViewModel.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 08.08.2024.
//

import UIKit

protocol DataLoadableViewModel {
    
    var didUpdatePhotos: (() -> Void)? { get set }
    var didEncounterError: ((String) -> Void)? { get set }
    var didUpdatePickers: (() -> Void)? { get set }
    var didSetDateRange: ((Date, Date) -> Void)? { get set }
    var didStartLoading: (() -> Void)? { get set }
    var didEndLoading: (() -> Void)? { get set }

}

class HomeViewModel: DataLoadableViewModel {

    private(set) var rovers = [Rover]()
    private(set) var minDate = Date()
    private(set) var maxDate = Date()

    var roverDataManager: RoverDataProvider
    var networkingManager: NetworkManager
    var roverPickerViewModel: RoverPickerViewModel?
    var cameraPickerViewModel: CameraPickerViewModel?
    var historyViewModel: HistoryViewModel?
    
    var photos: [Photo] = []
    var selectedDate: Date = Date()
    var selectedRoverName: String?
    var selectedCameraName: String?
    var validRovers: [String] = []
    var validCameras: [CameraInfo] = []
    
    var didUpdatePhotos: (() -> Void)?
    var didEncounterError: ((String) -> Void)?
    var didUpdatePickers: (() -> Void)?
    var didSetDateRange: ((Date, Date) -> Void)?
    var didStartLoading: (() -> Void)?
    var didEndLoading: (() -> Void)?
    
    init(roverDataManager: RoverDataProvider = RoverDataManager.shared, networkingManager: NetworkManager = NetworkManager.shared) {
        self.networkingManager = networkingManager
        self.roverDataManager = roverDataManager
        if case .success(let rovers) = roverDataManager.getCachedRovers() {
            self.rovers = rovers
        }
    }
    
    func updateFilters(rover: String?, cameraName: String?) {
        selectedRoverName = rover
        selectedCameraName = cameraName
    }
    
    func loadRoverData() {
        didStartLoading?()
        networkingManager.fetchRoverData { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(rovers):
                self.roverDataManager.cacheRovers(rovers: rovers)
                self.setDateRange(for: rovers.datesRange)
                self.getPhotos()
            case .failure(let error):
                self.didEncounterError?(error.rawValue)
                self.didEndLoading?()
            }
        }
    }
    
    private func setDateRange(for dateRange: RoverDataProvider.DatesRange?) {
        guard let dateRange else {
            didEncounterError?("Failed to get date range.")
            didEndLoading?()
            return
        }
        
        (minDate, maxDate) = dateRange
        selectedDate = maxDate
        DispatchQueue.main.async {
            self.didSetDateRange?(dateRange.minDate, dateRange.maxDate)
        }
    }
    
    func getPhotos() {
        let selectedDateString = selectedDate.convertToAPIFormat
        didStartLoading?()
        
        getValidRoversAndCameras(for: selectedDate)
        fetchPhotos(rover: selectedRoverName, camera: selectedCameraName, date: selectedDateString)
    }
    
    private func fetchPhotos(rover: String?, camera: String?, date: String) {
        networkingManager.fetchPhotos(rover: rover, camera: camera, date: date) { [weak self] result in
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
    
    func getValidRoversAndCameras(for date: Date) {
        var validRovers: [Rover] = []
        var validCamerasSet: Set<CameraInfo> = []

        for rover in rovers {
            if let landingDate = rover.landingDate.convertToDate,
               let maxDate = rover.maxDate.convertToDate,
               landingDate <= date && date <= maxDate {
                validRovers.append(rover)

                if selectedRoverName == "All" {
                    validCamerasSet.formUnion(rover.cameras)
                } else if rover.name == selectedRoverName {
                    validCamerasSet.formUnion(rover.cameras)
                }
            }
        }

        self.validRovers = validRovers.map { $0.name }
        self.validCameras = Array(validCamerasSet)

        roverPickerViewModel?.rovers = ["All"] + self.validRovers
        roverPickerViewModel?.didUpdateRovers?()
        
        cameraPickerViewModel?.cameras = self.validCameras
        cameraPickerViewModel?.didUpdateCameras?()
        
        didUpdatePickers?()
    }
    
    func addFiltersToHistory() {
        let historyViewModel = HistoryViewModel(
            selectedDate: self.selectedDate,
            selectedRoverName: self.selectedRoverName,
            selectedCameraName: self.selectedCameraName
        )
        historyViewModel.saveFilter()
    }
    
}
