//
//  HistoryViewModel.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 20.08.2024.
//

import UIKit
import CoreData

class HistoryViewModel {
    
    var selectedDate: Date?
    var selectedRoverName: String?
    var selectedCameraName: String?
    
    var didUpdateItems: (() -> Void)?
    var didEncounterError: ((String) -> Void)?
    var didStartLoading: (() -> Void)?
    var didEndLoading: (() -> Void)?
    var onFilterApplied: ((Date?, String?, String?) -> Void)?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var savedFilters: [SavedFilter] = []
    var roverDataManager: RoverDataProvider
    
    init(roverDataManager: RoverDataProvider = RoverDataManager.shared) {
        self.roverDataManager = roverDataManager
    }
    
    init(selectedDate: Date?, selectedRoverName: String?, selectedCameraName: String?, roverDataManager: RoverDataProvider = RoverDataManager.shared) {
        self.selectedDate = selectedDate
        self.selectedRoverName = selectedRoverName
        self.selectedCameraName = selectedCameraName
        self.roverDataManager = roverDataManager
    }
    
    func getAllSavedFilters() {
        didStartLoading?()
        let fetchRequest: NSFetchRequest<SavedFilter> = SavedFilter.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let savedFilters = try context.fetch(fetchRequest)
            self.savedFilters = savedFilters
            didEndLoading?()
            didUpdateItems?()
        } catch {
            didEndLoading?()
            didEncounterError?("Fetching from CoreData got an error: \(error.localizedDescription)")
        }
    }
    
    func saveFilter() {
        guard let selectedDate = selectedDate, let selectedCameraName = selectedCameraName else {
            didEncounterError?("Error: Missing filter data.")
            return
        }
        
        var cameraFullName: String?
        switch roverDataManager.getCachedRovers() {
        case .success(let rovers):
            if let selectedRoverName = selectedRoverName {
                if let rover = rovers.first(where: { $0.name == selectedRoverName }) {
                    if let camera = rover.cameras.first(where: { $0.name == selectedCameraName }) {
                        cameraFullName = camera.fullName
                    }
                }
            }
            if cameraFullName == nil {
                for rover in rovers {
                    if let camera = rover.cameras.first(where: { $0.name == selectedCameraName }) {
                        cameraFullName = camera.fullName
                        break
                    }
                }
            }
            
        case .failure(let error):
            didEncounterError?("Error fetching cached rovers: \(error.localizedDescription)")
        }
        
        let newFilter = SavedFilter(context: context)
        newFilter.roverName = selectedRoverName
        newFilter.cameraName = selectedCameraName
        newFilter.cameraFullName = cameraFullName
        newFilter.photoDate = selectedDate
        newFilter.timestamp = Date()
        
        do {
            try context.save()
        } catch {
            didEncounterError?("Saving to CoreData got an error: \(error.localizedDescription)")
        }
    }
    
    func deleteFilter(filter: SavedFilter) {
        context.delete(filter)
        
        do {
            try context.save()
            if let index = savedFilters.firstIndex(of: filter) {
                savedFilters.remove(at: index)
            }
            didUpdateItems?()
        } catch {
            didEncounterError?("Deleting from CoreData got an error: \(error.localizedDescription)")
        }
    }
    
    func applyFilter(filter: SavedFilter) {
        selectedDate = filter.photoDate
        selectedRoverName = filter.roverName
        selectedCameraName = filter.cameraName
        
        onFilterApplied?(selectedDate, selectedRoverName, selectedCameraName)
    }

}
