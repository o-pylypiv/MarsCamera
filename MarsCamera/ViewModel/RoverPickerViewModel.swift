//
//  RoverPickerViewModel.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 17.08.2024.
//

import Foundation

class RoverPickerViewModel {
    
    var rovers: [String] = []
    var selectedRover: String?
    var didUpdateRovers: (() -> Void)?
    
    func getRoverName(for row: Int) -> String {
        return rovers[row]
    }

    func selectRover(at row: Int) {
        selectedRover = rovers[row]
    }
    
}
