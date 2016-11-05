//
//  FDUser.swift
//  fooderoso
//
//  Created by Bruno Barbosa on 05/11/16.
//  Copyright © 2016 AlunosDeKiev. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class FDUser {
    let id: String
    let firstName: String
    let lastName: String
    var description: String?
    var photo: UIImage? = nil
    
    init(withId id: String, andJSON json: JSON) {
        self.id = id
        self.firstName = json["first-name"].stringValue
        self.lastName = json["last-name"].stringValue
        self.description = json["description"].string
        let photoStr = json["photo"].stringValue
        if let data = Data(base64Encoded: photoStr, options: .ignoreUnknownCharacters) {
            self.photo = UIImage(data: data)
        }
    }
}
