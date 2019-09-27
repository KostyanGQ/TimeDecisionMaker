//
//  RDFileServise.swift
//  TimeDecisionMaker
//
//  Created by Константин Овчаренко on 9/25/19.
//

import Foundation
import EventKit

class RDFileServise: NSObject {
        
    private var fileKeys = ["SUMMARY", "CREATED", "STATUS", "DESCRIPTION", "UID", "DTSTART", "DTEND", "LAST-MODIFIED", "LOCATION", "SEQUENCE", "TRANSP", "DTSTAMP"]
    private var timezone: String!
    private var meet = [Meet]()
    private let formatter = DateFormatter()
    

    public func fetchAppointment(resourceFile: String) -> [Meet] {
        meet.removeAll()
        let serviceMeet = Meet()
        guard let path = Bundle.main.path(forResource: resourceFile, ofType: "ics") else {
            print("Failed to load file from app bundle")
            return []
        }
        do {
            var myStrings = try String(contentsOfFile: path, encoding: String.Encoding.utf8).components(separatedBy: .newlines)
            var state = false
            myStrings = myStrings.filter({ $0 != ""})
            print("123,\(myStrings)")
            for element in myStrings {
                
                if element == "BEGIN:VEVENT" {
                    state = true
                } else if element == "END:VEVENT" {
                    state = false
                    serviceMeet.makeModelEmptyForChecking()
                } else if element.contains("X-WR-TIMEZONE:") {
                    timezone = element.matchingStrings(regex: "(?<=X-WR-TIMEZONE:).*").first?[0]
                }
                
                if state && getElementByKey(element: element).1 != nil {
                    
                    getVariableByKey(key: getElementByKey(element: element).0!, keyValue: getElementByKey(element: element).1!, thisAppointment: serviceMeet)
                    
                    if serviceMeet.isReadyToAdd() {
                        meet.append(Meet(summary: serviceMeet.summary, created: serviceMeet.created, UID: serviceMeet.UID,description: serviceMeet.descriptionAp, dateStart: serviceMeet.dateStart, dateEnd: serviceMeet.dateEnd, lastModified: serviceMeet.lastModified, location: serviceMeet.location, sequence: serviceMeet.sequence, stamp: serviceMeet.stamp))
                    }
                }
            }
        } catch {
            print("Failed to read text")
        }
        print("123,\(meet)")
        return meet
    }
        
        
        private func getElementByKey(element: String) -> (String?, String?) {
            var stringWithoutKeyName : String!
            var keyName : String!
            for key in fileKeys {
                if element.contains(key) {
                    if element.contains("\(key);VALUE=DATE:") {
                        if let value = element.matchingStrings(regex: "(?<=\(key);VALUE=DATE:).*").first?[0] {
                            stringWithoutKeyName = "\(value)T000000Z"
                        }
                    } else {
                        stringWithoutKeyName = element.matchingStrings(regex: "(?<=\(key):).*").first?[0]
                    }
                    keyName = key
                }
            }
            return (keyName, stringWithoutKeyName)
        }
        
        /// Method for saving values to the appointment
        ///
        /// - Parameters:
        ///   - key: title of the key from .ics file such as "SUMMARY"
        ///   - keyValue: values of this key
        ///   - thisAppointment: current object to perform
        private func getVariableByKey(key: String, keyValue: String, thisAppointment: Meet) {
            switch key {
            case fileKeys[0]:
                thisAppointment.summary = keyValue
            case fileKeys[1]:
                thisAppointment.created = keyValue.convertStringToDate(timezone: timezone, format: "yyyyMMdd'T'HHmmss'Z'")
            case fileKeys[2]:
                print("status")
//                thisAppointment.status = thisAppointment.statusTypeFromString(value: keyValue)
            case fileKeys[3]:
                thisAppointment.descriptionAp = keyValue
            case fileKeys[4]:
                thisAppointment.UID = keyValue
            case fileKeys[5]:
                thisAppointment.dateStart = keyValue.convertStringToDate(timezone: timezone, format: "yyyyMMdd'T'HHmmss'Z'")
            case fileKeys[6]:
                thisAppointment.dateEnd = keyValue.convertStringToDate(timezone: timezone, format: "yyyyMMdd'T'HHmmss'Z'")
            case fileKeys[7]:
                thisAppointment.lastModified = keyValue.convertStringToDate(timezone: timezone, format: "yyyyMMdd'T'HHmmss'Z'")
            case fileKeys[8]:
                thisAppointment.location = keyValue
            case fileKeys[9]:
                thisAppointment.sequence = Int(keyValue) ?? 0
            case fileKeys[10]:
                print("transparency")
//                thisAppointment.transparency = thisAppointment.transparencyTypeFromString(value: keyValue)
            case fileKeys[11]:
                thisAppointment.stamp = keyValue.convertStringToDate(timezone: timezone, format: "yyyyMMdd'T'HHmmss'Z'")
            default:
                print("error")
            }
            
        }
    
    
    func createNewCalendar(nameOfCalendar : String){
        
        let eventStore = EKEventStore()
        let calendars = eventStore.calendarsForEntityType(EKEntityTypeEvent) as [EKCalendar]
        var exists = false
        for calendar in calendars {
           if calendar.title == "newcal" {
               exists = true
           }
        }

        var err : NSError?
        if exists==false {
           let newCalendar = EKCalendar(forEntityType:EKEntityTypeEvent, eventStore:eventStore)
           newCalendar.title="newcal"
           newCalendar.source = eventStore.defaultCalendarForNewEvents.source
           let ok = eventStore.saveCalendar(newCalendar, commit:true, error:&err)
           print(ok)
        }
        
    }
    
    
        

//        public func getDaysByMonth(month: String, year: Int) -> [Date] {
//            let calendar = Calendar.current
//
//            formatter.dateFormat = "yyyy-MMM"
//
//            formatter.timeZone = TimeZone(identifier: "Europe/Kiev")
//            let components = calendar.dateComponents([.year, .month], from: formatter.date(from: "\(year)-\(month)")!)
//            let startOfMonth = calendar.date(from: components)!
//            let numberOfDays = calendar.range(of: .day, in: .month, for: startOfMonth)!.upperBound
//            let allDays = Array(0..<numberOfDays).map{ calendar.date(byAdding:.day, value: $0, to: startOfMonth)!}
//            var dates = [Date]()
//            for date in allDays {
//                dates.append(date.convertToTimeZone(initTimeZone:TimeZone(abbreviation: "UTC")!, timeZone: TimeZone(identifier: "Europe/Kiev")!))
//            }
//            return dates
//        }
//
        /// Method to perform days calculation from 1 to month's lenghth
        ///
        /// - Parameter month: selected month's name
        /// - Returns: array of strings
//        public func getDatesFromMonth(month: [Date]) -> [String] {
//            var values = [String]()
//            for i in 1...month.count {
//                values.append("\(i)")
//            }
//            return values
//        }
        
        /// Method for checking if date interval is ready for manipulations
        ///
        /// - Parameters:
        ///   - startDate: start date
        ///   - endDate: end date
        /// - Returns: returns true if dates are ready for date interval type
//        public func dateViladation(startDate: Date, endDate: Date) -> Bool {
//            guard startDate < endDate  else {
//                return false
//            }
//            return true
//        }
    }



