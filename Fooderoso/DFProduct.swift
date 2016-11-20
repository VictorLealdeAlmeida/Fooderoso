//
//  DFProduct.swift
//  fooderoso
//
//  Created by Bruno Barbosa on 05/11/16.
//  Copyright © 2016 AlunosDeKiev. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class FDProduct: NSObject {
    let id: String
    let name: String
    let prodDescription: String
    let photo: UIImage?
    let price: Double
    var priceString: String {
        return "R$\(String(format: "%.2f", self.price))"
    }
    let seller: FDUser
    var tags: [FDProductTag] = []
    
    init(withId id: String, andJSON json: JSON, andSeller user: FDUser) {
        self.id = id
        self.name = json["name"].stringValue
        self.prodDescription = json["description"].stringValue
        
        let photoStr = json["photo"].stringValue
        if let data = Data(base64Encoded: photoStr, options: .ignoreUnknownCharacters) {
            self.photo = UIImage(data: data)
        } else {
            self.photo = nil
        }
        
        self.price = json["price"].doubleValue
        self.seller = user
        
        let tagsDict = json["tags"].dictionaryValue
        let tagsArray: [String] = Array(tagsDict.keys)
        for tagKey in tagsArray {
            self.tags.append(FDProductTag(withName: tagKey))
        }
    }
}
