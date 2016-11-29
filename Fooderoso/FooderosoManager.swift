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
    fileprivate var userProductsKeys: [String] = []
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
    
    func startSelling() {
        
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
            
        }, withCancel: {error in
            print("FAILURE: something went wrong while trying to get the products")
        })
    }

}

// private functions
extension FooderosoManager {
    func saveNewUser(_ user: FDUser) {
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
    
    func loadUserInfo() {
        guard let userId = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        firebaseRef.child("users/\(userId)").observe(.value, with: { (userSnapshot) in
            guard let userJSON = userSnapshot.json else {
                return
            }
            
            self.currentUser = FDUser(withId: userId, andJSON: userJSON)
            if let productsKeys = userJSON["products"].arrayObject as? [[String : Bool]] {
                self.userProductsKeys = []
//                for (productKey, _) in productsKeys {
//                    self.userProductsKeys.append(productKey)
//                }
            }
            
            NotificationCenter.default.post(name: FDNotification.userLoggedInSuccessfully, object: nil)
            
        })
    }
    
    
    
}
