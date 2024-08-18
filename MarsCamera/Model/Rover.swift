//
//  Rover.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 08.08.2024.
//

import Foundation

struct Rover: Codable, Equatable {
    
    let id: Int
    let name: String
    let landingDate: String
    let launchDate: String
    let status: String
    let maxSol: Int
    let maxDate: String
    let totalPhotos: Int
    let cameras: [CameraInfo]
    
}
