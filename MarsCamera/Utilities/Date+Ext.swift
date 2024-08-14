//
//  Date+Ext.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 12.08.2024.
//

import Foundation

extension Date {
    
    func convertToMonthDayYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        return dateFormatter.string(from: self)
    }
    
    func convertToAPIFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: self)
    }
}
