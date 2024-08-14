//
//  Photo.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 08.08.2024.
//

import Foundation

struct Photo: Codable {
    let id: Int
    let sol: Int
    let camera: Camera
    let imgSrc: String
    let earthDate: String
    let rover: Rover
}
