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
    var id: String?
    var name: String
    var prodDescription: String
    var photo: UIImage
    var price: Double
    var priceString: String {
        return "R$\(String(format: "%.2f", self.price))"
    }
    let seller: FDUser?
    var tags: [FDProductTag] = []
    var selling: Bool = true
    
    init(withId id: String, andJSON json: JSON, andSeller user: FDUser?=nil, andStatus selling:Bool=true) {
        self.id = id
        self.name = json["name"].stringValue
        self.prodDescription = json["description"].stringValue
        
        let photoStr = json["photo"].stringValue
        if let data = Data(base64Encoded: photoStr, options: .ignoreUnknownCharacters), let photo = UIImage(data: data) {
            self.photo = photo
        } else {
            self.photo = #imageLiteral(resourceName: "cuzcuz")
        }
        
        self.price = json["price"].doubleValue
        self.seller = user
        
        let tagsDict = json["tags"].dictionaryValue
        let tagsArray: [String] = Array(tagsDict.keys)
        for tagKey in tagsArray {
            self.tags.append(FDProductTag(withName: tagKey))
        }
        
        self.selling = selling
    }
    
    init(withName name: String, andDesc desc: String, andPhoto photo: UIImage, andPrice price: Double, andSeller seller: FDUser, andTags tags: [FDProductTag]) {
        self.id = nil
        self.name = name
        self.prodDescription = desc
        self.photo = photo
        self.price = price
        self.seller = seller
        self.tags = tags
    }
    
    func toDict() -> [String : Any] {
        var dict:[String:Any] = [:]
        dict["name"] = self.name
        dict["description"] = self.prodDescription
        
        let imageData = UIImagePNGRepresentation(self.photo)
        let base64Img = imageData?.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
        
        dict["photo"] = base64Img
        
        dict["price"] = self.price
        if let seller = self.seller {
            dict["seller"] = seller.id!
        }
        
        var tagsKeys:[String:Bool] = [:]
        for tag in self.tags {
            tagsKeys[tag.name] = true
        }
        dict["tags"] = tagsKeys
        
        return dict
    }
}
