//
//  CameraPickerViewModel.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 13.08.2024.
//

class CameraPickerViewModel {
    var cameras: [CameraInfo] = []
    var selectedCamera: String?
    var selectedRover: String?
    
    var didUpdateCameras: (() -> Void)?
    
    func fetchCameras() {
        guard let rover = selectedRover else {
            cameras = RoverData.roverCameras["All"] ?? []
            cameras.insert(CameraInfo(name: "All", fullName: "All"), at: 0)
            didUpdateCameras?()
            return
        }
        cameras = RoverData.roverCameras[rover] ?? []
        cameras.insert(CameraInfo(name: "All", fullName: "All"), at: 0)
        didUpdateCameras?()
    }

    
    func getCameraName(for row: Int) -> String {
        return cameras[row].name
    }
    
    func getCameraFullName(for row: Int) -> String {
        return cameras[row].fullName
    }
}
