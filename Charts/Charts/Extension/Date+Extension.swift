//
//  Date+Extension.swift
//  Charts
//
//  Created by Алексей Ведушев on 06.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import Foundation

extension Date {
    
    static var monthArray: [String] {
        let dateComponent = DateComponents(calendar: Calendar.current,year: 2020, month: 1, day: 1)
        
        guard let firstDate = dateComponent.date else {
            return []
        }
        
        return Array<Int>(0...11)
            .compactMap{ Calendar.current.date(byAdding: .month, value: $0, to: firstDate) }
            .map{ $0.monthName}
    }
    
    var day: Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: self)
    }
    
    var monthName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: self)
    }
    
    var month: Int {
        let calendar = Calendar.current
        return calendar.component(.month, from: self)
    }
    
    var year: Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: self)
    }
    
    var prevMonth: Int {
        Calendar.current.date(byAdding: .month, value: -1, to: self)!.month
    }
    
    var prevMonthName: String {
        Calendar.current.date(byAdding: .month, value: -1, to: self)!.monthName
    }
    
    var numDaysInMonth: Int {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: self)!
        let numDays = range.count
        return numDays
    }
    
}
