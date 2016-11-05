//
//  FIRDataSnapshot+JSON.swift
//  fooderoso
//
//  Created by Bruno Barbosa on 05/11/16.
//  Copyright © 2016 AlunosDeKiev. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON

extension FIRDataSnapshot {
    var json: JSON? {
        return JSON(self.value ?? nil)
    }
}
