//
//  CameraPickerViewModel.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 13.08.2024.
//

import Foundation

class CameraPickerViewModel {
    
    var cameras: [CameraInfo] = []
    var selectedCamera: String?
    var selectedRover: String?
    var didUpdateCameras: (() -> Void)?
    
    func getCameraName(for row: Int) -> String {
        return cameras[row].name
    }
    
    func getCameraFullName(for row: Int) -> String {
        return cameras[row].fullName
    }
    
}
