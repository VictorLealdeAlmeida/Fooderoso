//
//  FDChatRoom.swift
//  fooderoso
//
//  Created by Bruno Barbosa on 20/11/16.
//  Copyright © 2016 AlunosDeKiev. All rights reserved.
//

import UIKit
import SwiftyJSON

class FDChatRoom: NSObject {
    let id: String
    let messages: [FDChatMessage]
    let users: [FDUser]
    
    init(withID id: String, andUsers users: [FDUser], andMessages messages: [FDChatMessage]) {
        self.id = id
        self.users = users
        self.messages = messages
    }
}
