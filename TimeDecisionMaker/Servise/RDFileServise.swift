//
//  RDFileServise.swift
//  TimeDecisionMaker
//
//  Created by Константин Овчаренко on 9/25/19.
//

import Foundation
import UIKit
import EventKit

class RDFileServise: NSObject {
        
    private var fileKeys = ["SUMMARY", "CREATED", "STATUS", "DESCRIPTION", "UID", "DTSTART", "DTEND", "LAST-MODIFIED", "LOCATION", "SEQUENCE", "TRANSP", "DTSTAMP"]
    private var timezone: String!
    private var meet = [Meet]()
    private let formatter = DateFormatter()
    

    public func parthICSFile(resourceFile: String) -> [Meet] {
        meet.removeAll()
        let serviceMeet = Meet()
        guard let path = Bundle.main.path(forResource: resourceFile, ofType: ".ics") else {
            print("Failed to load file from app bundle")
            return []
        }
        do {
            var myStrings = try String(contentsOfFile: path, encoding: String.Encoding.utf8).components(separatedBy: .newlines)
            var state = false
            myStrings = myStrings.filter({ $0 != ""})
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
                        meet.append(Meet(summary: serviceMeet.summary, created: serviceMeet.created, UID: serviceMeet.UID, description: serviceMeet.title, dateStart: serviceMeet.dateStart, dateEnd: serviceMeet.dateEnd, lastModified: serviceMeet.lastModified, location: serviceMeet.location, sequence: serviceMeet.sequence, stamp: serviceMeet.stamp))
                    }
                }
            }
        } catch {
            print("Failed to read text")
        }
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
                thisAppointment.title = keyValue
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
    

    func getEventDay(eventsList: [Meet], date : Date) -> [Meet]?{
        
        var events = [Meet]()
            
        let sortedEvents = eventsList.sorted(by: { $0.dateInterval.start < $1.dateInterval.start})

        for event in sortedEvents {
                
            if DateInterval(start: date, duration: 86340).contains(event.dateInterval.start) {
                    
                if !events.contains(event){
                    events.append(event)
                    print("somsing is ok")
                }
            }else {
                print("somsing gone wrong")
            }
        }

        return events
    }

        
    func saveEventChanges(event : Meet , resourceFile : String, resourseFile2 : String?) -> Bool {
        
        var newStrings = [String]()
        formatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
               
        guard let path = Bundle.main.path(forResource: resourceFile, ofType: "ics") else {
                print("Failed to load file from app bundle")
                return false
            }
        do {
            var myStrings = try String(contentsOfFile: path, encoding: String.Encoding.utf8).components(separatedBy: .newlines)
            var state = true
            myStrings = myStrings.filter({ $0 != ""})
               for i in 0..<myStrings.count {
                   
                   if myStrings[i] == "BEGIN:VEVENT" && myStrings[i+4] == "UID:\(event.UID)"{
                       print("UID:\(event.UID)")
                       newStrings.append(myStrings[i])
                       newStrings.append("DTSTART:\(formatter.string(from: event.dateInterval.start))")
                       newStrings.append("DTEND:\(formatter.string(from: event.dateInterval.end))")
                       newStrings.append("DTSTAMP:\(formatter.string(from: event.stamp))")
                       newStrings.append("UID:\(event.UID)")
                       newStrings.append("CREATED:\(formatter.string(from: event.created))")
                       newStrings.append("DESCRIPTION:\(event.title ?? "")")
                       newStrings.append("LAST-MODIFIED:\(formatter.string(from: event.lastModified))")
                       newStrings.append("LOCATION:\(event.location)")
                       newStrings.append("SEQUENCE:\(event.sequence ?? 0)")
//                       newStrings.append("STATUS:\(event.status.description)")
                       newStrings.append("SUMMARY:\(event.summary)")
//                       newStrings.append("TRANSP:\(event.transparency.description)")
                       state = false
                   } else if !state && myStrings[i] == "END:VEVENT" {
                       state = true
                   }
                   
                   if state {
                       newStrings.append(myStrings[i])
                   }
               }
               
               let joined = newStrings.joined(separator: ("\n"))
               do {
                   try joined.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
               } catch {
                   // handle error
               }

           } catch {
               print("Failed to read text")
               return false
           }
           
           return true
       }
    
    func createNewEvent(organizationICS: String, invitedICS: String) -> Bool{
        
        var newStrings = [String]()
        formatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
              
        guard let pathOrganizationICS = Bundle.main.path(forResource: organizationICS, ofType: "ics") else {
            print("Failed to load file from app bundle")
            return false
        }
        guard let pathInvitedICS = Bundle.main.path(forResource: invitedICS, ofType: "ics") else {
            print("Failed to load file from app bundle")
            return false
        }
        return true
    }
    
    func chekTime(startTime : Date , endTime : Date) -> Bool{
        
        if startTime > endTime {
            return false
        } else {
            return true
        }
    }
    
}



