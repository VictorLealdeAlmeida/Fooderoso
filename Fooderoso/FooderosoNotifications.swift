//
//  FooderosoNotifications.swift
//  fooderoso
//
//  Created by Bruno Barbosa on 20/11/16.
//  Copyright © 2016 AlunosDeKiev. All rights reserved.
//

import Foundation

class FDNotification {
    // Authentication
    static let userLoggedInSuccessfully = Notification.Name("userLoggedInSuccessfully")
    static let userCreatedSuccessfully = Notification.Name("userLoggedInSuccessfully")
    
    // Products
    static let productCreatedSuccessfully = Notification.Name("productCreatedSuccessfully")
    static let productCreationFailed = Notification.Name("productCreationFailed")
    
}
