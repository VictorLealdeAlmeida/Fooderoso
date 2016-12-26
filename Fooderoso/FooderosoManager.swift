//
//  FooderosoManager.swift
//  fooderoso
//
//  Created by Bruno Barbosa on 20/11/16.
//  Copyright © 2016 AlunosDeKiev. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SwiftyJSON

class FooderosoManager: NSObject {
    static let instance = FooderosoManager()
    private override init() {
        super.init()
        self.firebaseRef = FIRDatabase.database().reference()
    }
    
    var firebaseRef: FIRDatabaseReference!
    
    var currentUser: FDUser?
    var userProducts: [FDProduct] = []
    
    var productsOnSale: [FDProduct] = []
    
    fileprivate var userChatsKeys: [String] = []
    fileprivate var userProductsKeys: [String:Bool] = [:]
    fileprivate var loadedUsers: [FDUser] = []
    
    /*
     #################
        AUTH
     #################
     */
    func loginAnonymously() {
        if let _ = FIRAuth.auth()?.currentUser {
            self.loadUserInfo()
            return
        }
        
        FIRAuth.auth()?.signInAnonymously(completion: { (user, error) in
            if let error = error {
                print("FAILURE: something went wrong trying to login anonymously")
                print(error.localizedDescription)
                return
            }
            
            print("SUCCESS: user logged in successfully")
            let newUser = FDUser()
            self.saveNewUser(newUser)
        })
    }
    
    func login(withEmail email: String, withAndPassword password: String) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                print("FAILURE: something went wrong trying to login with email and password")
                print(error.localizedDescription)
                return
            }
            
            print("SUCCESS: user logged in successfully")
            self.loadUserInfo()
        })
    }
    
    /*
     #################
        PRODUCTS
     #################
     */
    func saveProduct(_ product: FDProduct) {
        var pathsDict:[String:Any] = [:]
        let productKey = firebaseRef.child("products").childByAutoId().key
        pathsDict["products/\(productKey)"] = product.toDict()
        
        for tag in product.tags {
            pathsDict["tags/\(tag.name)/products/\(productKey)"] = true
        }
        
        pathsDict["users/\(self.currentUser!.id!)/products/\(productKey)"] = false
        
        firebaseRef.updateChildValues(pathsDict, withCompletionBlock: { (error, ref) in
            if let error = error {
                print("FAILURE: something went wrong while trying to save the product")
                print(error.localizedDescription)
                NotificationCenter.default.post(name: FDNotification.productCreationFailed, object: nil)
                return
            }
            
            print("SUCCESS: product created successfully")
            NotificationCenter.default.post(name: FDNotification.productCreatedSuccessfully, object: nil)
        })
    }
    
    func updateProduct(_ product: FDProduct, allTags: [FDProductTag]) {
        var pathsDict:[String:Any] = [:]
        let productKey = product.id!
        pathsDict["products/\(productKey)"] = product.toDict()
        
        for tag in allTags {
            pathsDict["tags/\(tag.name)/products/\(productKey)"] = nil
        }
        for tag in product.tags {
            pathsDict["tags/\(tag.name)/products/\(productKey)"] = true
        }
        
        pathsDict["users/\(self.currentUser!.id!)/products/\(productKey)"] = product.selling
        
        firebaseRef.updateChildValues(pathsDict, withCompletionBlock: { (error, ref) in
            if let error = error {
                print("FAILURE: something went wrong while trying to update the product")
                print(error.localizedDescription)
                NotificationCenter.default.post(name: FDNotification.productUpdateFailed, object: nil)
                return
            }
            
            print("SUCCESS: product updated successfully")
            NotificationCenter.default.post(name: FDNotification.productUpdateSucceeded, object: nil)
        })
    }
    
    func getProducts() {
        firebaseRef.child("products").queryOrdered(byChild: "selling").queryEqual(toValue: true).observe(.value, with: {productsSnapshot in
            guard let productsJSON = productsSnapshot.json else {
                print("No product found")
                NotificationCenter.default.post(name: FDNotification.noProductsFound, object: nil)
                return
            }
            
            self.productsOnSale = []
            for (key, productJSON) in productsJSON.dictionaryValue {
                if productJSON["seller"].stringValue == self.currentUser!.id! {
                    continue
                }
                print(productJSON)
                print(key)
                let newProduct = FDProduct(withId: key, andJSON: productJSON)
                self.productsOnSale.append(newProduct)
            }
            
            NotificationCenter.default.post(name: FDNotification.productsFound, object: nil)
            
        }, withCancel: {error in
            print("FAILURE: something went wrong while trying to get the products")
        })
    }
    
    func getUserProducts() {
        
        if self.userProductsKeys.count == 0 {
            NotificationCenter.default.post(name: FDNotification.noUserProductsFound, object: nil)
        }
        
        self.listenToUserAddedProducts()
        self.listenToUserChangedProduct()
        self.listenToUserRemovedProducts()
    }
    
    func toggleSellingMode(_ status: Bool, location: String?=nil) {
        var pathsDict:[String:Any] = [:]
        pathsDict["users/\(self.currentUser!.id!)/is-selling"] = status
        
        if let loc = location {
            pathsDict["users/\(self.currentUser!.id!)/location/name"] = loc
        }
        
        firebaseRef.updateChildValues(pathsDict, withCompletionBlock: { (error, ref) in
            if let error = error {
                print("FAILURE: something went wrong while trying to update the selling status")
                print(error.localizedDescription)
                NotificationCenter.default.post(name: FDNotification.sellingModeFailed, object: nil)
                return
            }
            
            NotificationCenter.default.post(name: FDNotification.sellingModeUpdated, object: nil)
        })
    }
    
    /*
     #################
     CHATS
     #################
     */
    
    func getChats() {
        guard let userId = FIRAuth.auth()?.currentUser?.uid else {
            NotificationCenter.default.post(name: FDNotification.userNotLogged, object: nil)
            return
        }
        
        self.firebaseRef.child("users/\(userId)/chats").queryOrderedByValue().observe(.childAdded, with: {chatSnapshot in
            
        })
    }
    

}

// private functions
extension FooderosoManager {
    
    /*
     #################
     USER
     #################
     */
    
    fileprivate func saveNewUser(_ user: FDUser) {
        var dict = user.toDict()
        dict["is-selling"] = false
        
        let userId = FIRAuth.auth()?.currentUser?.uid
        user.id = userId
        self.currentUser = user
        firebaseRef.child("users/\(userId!)").setValue(dict, withCompletionBlock: { (error, ref) in
            if let error = error {
                print("FAILURE: something went wrong while trying to save the user")
                print(error.localizedDescription)
                return
            }
            
            print("SUCCESS: user created successfully")
            NotificationCenter.default.post(name: FDNotification.userCreatedSuccessfully, object: nil)
        })
    }
    
    fileprivate func loadUserInfo() {
        guard let userId = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        firebaseRef.child("users/\(userId)").observe(.value, with: { (userSnapshot) in
            guard let userJSON = userSnapshot.json else {
                return
            }
            
            self.currentUser = FDUser(withId: userId, andJSON: userJSON)
            if let productsKeys = userJSON["products"].dictionaryObject as? [String : Bool] {
                self.userProductsKeys = productsKeys
                for prod in self.userProducts {
                    let status = self.userProductsKeys[prod.id!] ?? false
                    prod.selling = status
                    NotificationCenter.default.post(name: FDNotification.userProductChanged, object: nil, userInfo: ["productId" : prod.id!, "product" : prod])
                }
            }
            
            NotificationCenter.default.post(name: FDNotification.userLoggedInSuccessfully, object: nil)
            
        })
    }
    
    /*
     #################
     PRODUCTS
     #################
     */
    
    fileprivate func listenToUserAddedProducts() {
        let userId = self.currentUser!.id!
        firebaseRef.child("products").queryOrdered(byChild: "seller").queryEqual(toValue: userId).observe(.childAdded, with: {(prodSnap) in
            guard let productJSON = prodSnap.json else {
                print("product not valid")
                return
            }
            
            let prodStatus = self.userProductsKeys[prodSnap.key] ?? false
            let newProd = FDProduct(withId: prodSnap.key, andJSON: productJSON, andSeller: self.currentUser, andStatus: prodStatus)
            self.userProducts.append(newProd)
            NotificationCenter.default.post(name: FDNotification.userProductAdded, object: nil, userInfo: ["product": newProd])
            
        }, withCancel: {error in
            print("FAILURE: something went wrong while trying to get the user's products")
            print(error.localizedDescription)
        })
    }
    
    fileprivate func listenToUserRemovedProducts() {
        let userId = self.currentUser!.id!
        firebaseRef.child("products").queryOrdered(byChild: "seller").queryEqual(toValue: userId).observe(.childRemoved, with: {prodSnap in
            
            for (index, prod) in self.userProducts.enumerated() {
                if prod.id == prodSnap.key {
                    self.userProducts.remove(at: index)
                    NotificationCenter.default.post(name: FDNotification.userProductRemoved, object: nil, userInfo: ["productId": prodSnap.key])
                    return
                }
            }
            
        }, withCancel: {error in
            print("FAILURE: something went wrong while trying to get the user product that was removed")
            print(error.localizedDescription)
        })
    }
    
    fileprivate func listenToUserChangedProduct() {
        let userId = self.currentUser!.id!
        firebaseRef.child("products").queryOrdered(byChild: "seller").queryEqual(toValue: userId).observe(.childChanged, with: {prodSnap in
            guard let productJSON = prodSnap.json else {
                print("product not valid")
                return
            }
            
            let prodStatus = self.userProductsKeys[prodSnap.key] ?? false
            let newProd = FDProduct(withId: prodSnap.key, andJSON: productJSON, andSeller: self.currentUser, andStatus: prodStatus)
            
            for (index, prod) in self.userProducts.enumerated() {
                if prod.id == prodSnap.key {
                    let range = Range(uncheckedBounds: (lower: index, upper: index+1))
                    self.userProducts.replaceSubrange(range, with: [newProd])
                    NotificationCenter.default.post(name: FDNotification.userProductChanged, object: nil, userInfo: ["product" : newProd, "productId" : prodSnap.key] )
                    return
                }
            }
            
        }, withCancel: {error in
            print("FAILURE: something went wrong while trying to get the user product that changed")
            print(error.localizedDescription)
        })
    }
    
    
}
