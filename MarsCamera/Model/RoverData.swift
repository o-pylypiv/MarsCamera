//
//  RoverData.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 14.08.2024.
//

import Foundation

struct RoverData {
    static let roverCameras: [String: [CameraInfo]] = [
        "All": [
            CameraInfo(name: "FHAZ", fullName: "Front Hazard Avoidance Camera"),
            CameraInfo(name: "RHAZ", fullName: "Rear Hazard Avoidance Camera"),
            CameraInfo(name: "MAST", fullName: "Mast Camera"),
            CameraInfo(name: "CHEMCAM", fullName: "Chemistry and Camera Complex"),
            CameraInfo(name: "MAHLI", fullName: "Mars Hand Lens Imager"),
            CameraInfo(name: "MARDI", fullName: "Mars Descent Imager"),
            CameraInfo(name: "NAVCAM", fullName: "Navigation Camera"),
            CameraInfo(name: "PANCAM", fullName: "Panoramic Camera"),
            CameraInfo(name: "MINITES", fullName: "Miniature Thermal Emission Spectrometer (Mini-TES)")
        ],
        "Curiosity": [
            CameraInfo(name: "FHAZ", fullName: "Front Hazard Avoidance Camera"),
            CameraInfo(name: "RHAZ", fullName: "Rear Hazard Avoidance Camera"),
            CameraInfo(name: "MAST", fullName: "Mast Camera"),
            CameraInfo(name: "CHEMCAM", fullName: "Chemistry and Camera Complex"),
            CameraInfo(name: "MAHLI", fullName: "Mars Hand Lens Imager"),
            CameraInfo(name: "NAVCAM", fullName: "Navigation Camera")
        ],
        "Opportunity": [
            CameraInfo(name: "FHAZ", fullName: "Front Hazard Avoidance Camera"),
            CameraInfo(name: "RHAZ", fullName: "Rear Hazard Avoidance Camera"),
            CameraInfo(name: "NAVCAM", fullName: "Navigation Camera"),
            CameraInfo(name: "PANCAM", fullName: "Panoramic Camera"),
            CameraInfo(name: "MINITES", fullName: "Miniature Thermal Emission Spectrometer (Mini-TES)")
        ],
        "Spirit": [
            CameraInfo(name: "FHAZ", fullName: "Front Hazard Avoidance Camera"),
            CameraInfo(name: "RHAZ", fullName: "Rear Hazard Avoidance Camera"),
            CameraInfo(name: "NAVCAM", fullName: "Navigation Camera"),
            CameraInfo(name: "PANCAM", fullName: "Panoramic Camera"),
            CameraInfo(name: "MINITES", fullName: "Miniature Thermal Emission Spectrometer (Mini-TES)")
        ]
    ]
}
