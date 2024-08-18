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
    
    func getCameraName(for row: Int) -> String {
        return cameras[row].name
    }
    
    func getCameraFullName(for row: Int) -> String {
        return cameras[row].fullName
    }
    
}
