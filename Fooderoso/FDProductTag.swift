//
//  FDProductTag.swift
//  fooderoso
//
//  Created by Bruno Barbosa on 05/11/16.
//  Copyright © 2016 AlunosDeKiev. All rights reserved.
//

import Foundation
import SwiftyJSON

struct FDProductTag {
    let name: String
    
    init(withJSON json: JSON) {
        self.name = json["name"].stringValue
    }

    init(withName name: String) {
        self.name = name
    }
    
    
}
