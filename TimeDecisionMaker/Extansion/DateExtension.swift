//
//  DateExtension.swift
//  TimeDecisionMaker
//
//  Created by Константин Овчаренко on 7/22/19.
//

import Foundation

extension Date {
    
    static var today: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
    }
}
