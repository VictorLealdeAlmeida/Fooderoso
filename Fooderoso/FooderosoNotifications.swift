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
    static let userNotLogged = Notification.Name("userNotLogged");
    
    // Products
    static let productCreatedSuccessfully = Notification.Name("productCreatedSuccessfully")
    static let productCreationFailed = Notification.Name("productCreationFailed")
    static let noProductsFound = Notification.Name("noProductsFound")
    static let productsFound = Notification.Name("productsFound")
}
