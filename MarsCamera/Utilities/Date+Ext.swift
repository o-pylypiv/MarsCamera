//
//  Date+Ext.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 12.08.2024.
//

import Foundation

extension Date {
    
    var appPreviewString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        return dateFormatter.string(from: self)
    }
    
    var convertToAPIFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: self)
    }
    
}
