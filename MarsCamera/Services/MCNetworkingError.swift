//
//  MCNetworkingError.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 08.08.2024.
//

import Foundation

enum MCNetworkingError: String, Error {
    
    case invalidURL = "The app requested the wrong URL. Please try again later."
    case unableToComplete = "Unable to complete your request. Please check you internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data from the server was invalid. Please try again."
    case serverError = "Server error. Please try again later."
    
}
