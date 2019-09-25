//
//  MeetFile.swift
//  TimeDecisionMaker
//
//  Created by Константин Овчаренко on 9/24/19.
//

import Foundation


class User : NSObject {
    
    public var name : String = ""
    public var ICSFile : String = ""
    
    
    init(name: String, ICSFile: String) {
        self.name = name
        self.ICSFile = ICSFile
    }
    override init() {
        self.name = ""
        self.ICSFile = ""
    }
}
