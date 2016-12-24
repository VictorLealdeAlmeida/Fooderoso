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

class FDUser: NSObject {
    var id: String?
    var firstName: String
    var lastName: String
    var userDescription: String?
    var photo: UIImage? = nil
    
    var selling: Bool = false
    var location: String? = nil
    
    init(withId id: String, andJSON json: JSON) {
        self.id = id
        self.firstName = json["first-name"].stringValue
        self.lastName = json["last-name"].stringValue
        self.userDescription = json["description"].string
        let photoStr = json["photo"].stringValue
        if let data = Data(base64Encoded: photoStr, options: .ignoreUnknownCharacters) {
            self.photo = UIImage(data: data)
        }
        if let selling = json["is-selling"].bool {
            self.selling = selling
        }
        
        if let loc = json["location"]["name"].string {
            self.location = loc
        }
        
    }
    
    override init() {
        self.id = nil
        self.firstName = ""
        self.lastName = ""
        self.userDescription = ""
        self.photo = nil
        
        super.init()
    }
    
    func toDict() -> [String : Any] {
        var dict: [String: Any] = [:]
        dict["first-name"] = self.firstName
        dict["last-name"] = self.lastName
        dict["description"] = self.userDescription
        
        if let image = self.photo {
            let imageData = UIImagePNGRepresentation(image)
            let base64Img = imageData?.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
            
            dict["photo"] = base64Img
        }
        
        dict["is-selling"] = self.selling
        
        if let loc = self.location {
            dict["location"] = ["name" : loc]
        }
        
        return dict
    }
}
