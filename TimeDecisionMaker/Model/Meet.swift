//
//  Meet.swift
//  TimeDecisionMaker
//
//  Created by Константин Овчаренко on 9/24/19.
//

import Foundation


 class Meet : NSObject {
    
    public var summary : String
    public var created : Date!
    public var status : Status!
    public var descriptionAp : String!
    public var UID : String
    public var dateInterval : DateInterval!
    public var dateStart : Date!
    public var dateEnd : Date!
    public var stamp : Date!
    public var lastModified : Date!
    public var location : String
    public var sequence : Int!
    public var transparency : Transparency!
    
    private let dateFormatter = DateFormatter()
       
       override init() {
           self.summary = ""
           self.UID = ""
           self.created = Date()
           self.status = Status.UNSET
           self.descriptionAp = ""
           self.location = ""
           self.transparency = Transparency.UNSET
       }
       
       public init(summary: String, created: Date, UID: String, status: Status, description: String, dateStart: Date, dateEnd: Date, lastModified: Date, location: String, sequence: Int, transparency : Transparency, stamp: Date) {
           self.summary = summary
           self.UID = UID
           self.status = status
           self.descriptionAp = description
           self.created = created
           self.dateStart = dateStart
           self.dateEnd = dateEnd
           self.dateInterval = DateInterval(start: dateStart, end: dateEnd)
           self.lastModified = lastModified
           self.location = location
           self.sequence = sequence
           self.transparency = transparency
           self.stamp = stamp
       }
       
    
    public func isReadyToAdd() -> Bool {
        return !(summary.isEmpty || summary == "" || UID.isEmpty || UID == ""  || sequence == nil)
    }
    
    
     public func makeModelEmptyForChecking() {
         self.summary = ""
         self.UID = ""
         self.status = Status.UNSET
         self.transparency = Transparency.UNSET
     }
    

    enum Status : String {
        
        case TENTATIVE = "TENTATIVE"
        case CONFIRMED = "CONFIRMED"
        case CANCELLED = "CANCELLED"
        case UNSET
        
        var description: String {
            return self.rawValue
        }
    }
    
    enum Transparency : String {
    case OPAQUE = "OPAQUE"
    case TRANSPARENT = "TRANSPARENT"
    case UNSET
    
    var description: String {
        return self.rawValue
    }
   }
    
}
