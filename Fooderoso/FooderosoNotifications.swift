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
    static let productUpdateSucceeded = Notification.Name("productUpdateSucceeded")
    static let productUpdateFailed = Notification.Name("productUpdateFailed")
    static let noProductsFound = Notification.Name("noProductsFound")
    static let productsFound = Notification.Name("productsFound")
    static let sellingProductsUpdated = Notification.Name("sellingProductsUpdated")
     static let sellingProductsFailed = Notification.Name("sellingProductsFailed")
    
    // User Products
    static let userProductAdded = Notification.Name("userProductAdded")
    static let userProductChanged = Notification.Name("userProductChanged")
    static let userProductRemoved = Notification.Name("userProductRemoved")
    static let noUserProductsFound = Notification.Name("noUserProductsFound")
    
    // Selling
    static let sellingModeFailed = Notification.Name("sellingModeFailed")
    static let sellingModeUpdated = Notification.Name("sellingModeUpdated")
    
}
