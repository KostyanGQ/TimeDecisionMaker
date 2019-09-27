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
}
