//
//  UIViewShadowExtension.swift
//  bigu
//
//  Created by Bruno Barbosa on 5/31/16.
//  Copyright © 2016 Bigu App. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var shadowed: Bool {
        get {
            return self.shadowed
        }
        set(newValue) {
            self.layer.masksToBounds = false
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowOpacity = 0.3
        }
    }
}
