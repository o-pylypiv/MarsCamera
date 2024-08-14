//
//  String+Ext.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 12.08.2024.
//

import Foundation

extension String {
    
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "uk_UA")
        dateFormatter.timeZone = TimeZone.current
        
        return dateFormatter.date(from: self)
    }
    
    func convertToDisplayFormat() -> String {
        guard let date = self.convertToDate() else { return "N/A" }
        return date.convertToMonthDayYearFormat()
    }
}
