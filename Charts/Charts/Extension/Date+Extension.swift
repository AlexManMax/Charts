//
//  Date+Extension.swift
//  Charts
//
//  Created by Алексей Ведушев on 06.06.2020.
//  Copyright © 2020 Алексей Ведушев. All rights reserved.
//

import Foundation

extension Date {
    
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
}
