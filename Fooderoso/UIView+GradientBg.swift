//
//  UIView+GradientBg.swift
//  fooderoso
//
//  Created by Bruno Barbosa on 13/12/16.
//  Copyright © 2016 AlunosDeKiev. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    var gradientFromBlack: Bool {
        get {
            return self.shadowed
        }
        set(newValue) {
            self.backgroundColor = UIColor.clear
            
//            let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 320.0, height: 50.0))
            let gradient = CAGradientLayer()
            gradient.frame = self.bounds
            gradient.locations = [0.0, 1.0]
            gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
            self.layer.insertSublayer(gradient, at: 0)
            //use startPoint and endPoint to change direction of gradient (http://stackoverflow.com/a/20387923/2057171)
        }
    }
    
    var gradientToBlack: Bool {
        get {
            return self.shadowed
        }
        set(newValue) {
            self.backgroundColor = UIColor.clear
            
//            let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 320.0, height: 50.0))
            let gradient = CAGradientLayer()
            gradient.frame = self.bounds
            gradient.locations = [0.0, 1.0]
            gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
            self.layer.insertSublayer(gradient, at: 0)
            //use startPoint and endPoint to change direction of gradient (http://stackoverflow.com/a/20387923/2057171)
        }
    }
}
