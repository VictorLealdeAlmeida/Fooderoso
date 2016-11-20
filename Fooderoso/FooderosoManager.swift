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
    
    fileprivate var userChatsKeys: [String] = []
    fileprivate var userProductsKeys: [String] = []
    
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

}

// private functions
extension FooderosoManager {
    func saveNewUser(_ user: FDUser) {
        var dict = user.toDict()
        dict["is-selling"] = false
        
        let userId = FIRAuth.auth()?.currentUser?.uid
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
            guard let snapValue = userSnapshot.value as? JSON else {
                return
            }
            
            self.currentUser = FDUser(withId: userId, andJSON: snapValue)
            if let productsKeys = snapValue["products"].arrayObject as? [[String : Bool]] {
                self.userProductsKeys = []
//                for (productKey, _) in productsKeys {
//                    self.userProductsKeys.append(productKey)
//                }
            }
            
            NotificationCenter.default.post(name: FDNotification.userLoggedInSuccessfully, object: nil)
            
        })
    }
    
    
    
}
