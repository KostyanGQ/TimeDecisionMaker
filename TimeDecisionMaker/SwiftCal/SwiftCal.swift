//
//  SwiftCal.swift
//  CalendarKit-Swift
//
//  Created by Maurice Arikoglu on 30.11.17.
//  Copyright © 2017 Maurice Arikoglu. All rights reserved.
//

import UIKit

public enum SwiftCalError: Error {
    case emptyICS
    case timezoneUnsalvageable
}

public class SwiftCal {

    public var timezone: TimeZone
    public var allEvents: [CalendarEvent] {
        return eventStore
    }
    private var eventStore = [CalendarEvent]()

    init(icsFileContent: String) throws {

        let formattedICS = icsFileContent.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        guard
            formattedICS.count > 0
        else {
            throw SwiftCalError.emptyICS
        }

        do {
            guard
                let timezone = try  TimeZone(secondsFromGMT: 10800)
                else {
                    throw SwiftCalError.timezoneUnsalvageable
            }
            self.timezone = timezone
        } catch {
            throw error
        }

        let calendarEventsICS = formattedICS.components(separatedBy: ICSEventKey.eventBegin)
            .compactMap { $0.contains(ICSEventKey.eventEnd) ? $0 : nil }

        for event in calendarEventsICS {
            guard
                let calendarEvent = ICSEventParser.event(from: event, calendarTimezone: self.timezone)
                else {
                    continue
            }
            self.addEvent(calendarEvent)
        }
    }

}

extension SwiftCal {

    @discardableResult public func addEvent(_ event: CalendarEvent) -> Int {

        eventStore.append(event)
        return allEvents.count
    }
    
    @discardableResult public func addEvents(_ events: SwiftCal) -> Int {
        for event in events.allEvents {
            eventStore.append(event)
        }
        return allEvents.count
    }
    
    @discardableResult public func removeAllDays() -> Int {
        eventStore.removeAll() { $0.isAllDay }
        return allEvents.count
    }
    
    public func sort() {
        eventStore = eventStore.sorted(by: { (e1, e2) in
            let calendar = Calendar.current
            guard
                let sd1 = e1.startDate,
                let sd2 = e2.startDate,
                let compareDate1 = calendar.date(from: calendar.dateComponents([.day, .hour, .minute, .second], from: sd1)),
                let compareDate2 = calendar.date(from: calendar.dateComponents([.day, .hour, .minute, .second], from: sd2))
                else {
                    return false
            }
            
            return compareDate1 < compareDate2
        })
    }

    public func events(for date: Date) -> [CalendarEvent] {

        var eventsForDate = [CalendarEvent]()

        for event in eventStore where event.takesPlaceOnDate(date) {
            eventsForDate.append(event)
        }

        eventsForDate = eventsForDate.sorted(by: { (e1, e2) in
            // We compare time only because initial start dates might be different because of recurrence
            let calendar = Calendar.current
            guard
                let sd1 = e1.startDate,
                let sd2 = e2.startDate,
                let compareDate1 = calendar.date(from: calendar.dateComponents([.hour, .minute, .second], from: sd1)),
                let compareDate2 = calendar.date(from: calendar.dateComponents([.hour, .minute, .second], from: sd2))
                else {
                    return false
            }

            return compareDate1 < compareDate2
        })

        return eventsForDate
    }

}
