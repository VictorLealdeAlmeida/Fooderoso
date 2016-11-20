//
//  FDChatMessage.swift
//  fooderoso
//
//  Created by Bruno Barbosa on 20/11/16.
//  Copyright © 2016 AlunosDeKiev. All rights reserved.
//

import UIKit
import SwiftyJSON

class FDChatMessage: NSObject {
    let id: String
    let text: String
    let sender: FDUser
    let read: Bool
    let time: Date
    
    init(withId id: String, andJSON json: JSON, andSender user: FDUser) {
        self.id = id
        self.sender = user
        
        self.text = json["text"].stringValue
        self.read = json["read"].boolValue
        
        let unixtime = json["time"].doubleValue
        self.time = Date(timeIntervalSince1970: unixtime)
    }
}
