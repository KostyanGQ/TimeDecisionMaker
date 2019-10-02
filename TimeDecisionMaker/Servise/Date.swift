//
//  Date.swift
//  TimeDecisionMaker
//
//  Created by Константин Овчаренко on 9/25/19.
//

import Foundation

extension Date {
    
    func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date {
        let delta = TimeInterval(timeZone.secondsFromGMT() - initTimeZone.secondsFromGMT())
        return addingTimeInterval(delta)
    }
    

    
//    func startOfDay() -> Date{
//        let calendar = Calendar.current
//           let unitFlags = Set<Calendar.Component>([.year, .month, .day])
//           let components = calendar.dateComponents(unitFlags, from: self)
//           return calendar.date(from: components)!
//    }
//    func endOfDate() -> Date{
//           var components = DateComponents()
//           components.day = 1
//           let date = Calendar.current.date(byAdding: components, to: self.startOfDay())
//           return (date?.addingTimeInterval(-1))!
//    }
}
