//
//  ProductDetailViewController.swift
//  Fooderoso
//
//  Created by Victor Leal Porto de Almeida Arruda on 03/11/16.
//  Copyright © 2016 AlunosDeKiev. All rights reserved.
//

import UIKit
import GooglePlaces

class ProductDetailViewController: UIViewController {
    
    //-----
    //Views
    //-----
 
    @IBOutlet weak var talkSellerView: UIButton!
    @IBOutlet weak var photoUser: UIImageView!
    @IBOutlet weak var photoProduct: UIImageView!
    @IBOutlet var nameProduct: UILabel!
    
    //-----
    //Infos
    //-----

    var placesClient: GMSPlacesClient?
//    var imageName : String = ""
    var currentProduct: FDProduct!

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    //Conteudo pras tags, modificar pra antender o back-end
     var tags = ["#Doce", "#Salgado", "#Chocolate", "#Espacial", "#Bebida"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        self.loadInfo()
    }
    
    func loadInfo() {
        self.nameProduct.text = self.currentProduct.name
        self.photoProduct.image = self.currentProduct.photo
    }
    
    override func viewWillAppear(_ animated: Bool){
        talkSellerView.layer.cornerRadius = 5
        photoUser.layer.cornerRadius = photoUser.bounds.height/2;
        photoUser.clipsToBounds = true
        photoUser.layer.borderColor = UIColor(red:0.97, green:0.25, blue:0.47, alpha:1.00).cgColor
        photoUser.layer.borderWidth = 1
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
   /* @IBAction func getCurrentPlace(sender: UIButton) {
        
        placesClient?.currentPlace(callback: {
            (placeLikelihoodList: GMSPlaceLikelihoodList?, error: NSError?) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            self.nameLabel.text = "No current place"
            self.addressLabel.text = ""
            
            if let placeLicklihoodList = placeLikelihoodList {
                let place = placeLicklihoodList.likelihoods.first?.place
                if let place = place {
                    self.nameLabel.text = place.name
                    self.addressLabel.text = place.formattedAddress.componentsSeparatedByString(", ")
                        .joinWithSeparator("\n")
                }
            }
        } as! GMSPlaceLikelihoodListCallback)
    }*/
    
    @IBAction func go(_ sender: AnyObject) {
        var placesClient: GMSPlacesClient?
        placesClient = GMSPlacesClient.shared()
        placesClient?.currentPlace(callback: {
            (placeLikelihoodList: GMSPlaceLikelihoodList?, error: NSError?) in
            
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                let alert = UIAlertController(title: "Error", message: "Couldn't find a location", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.nameLabel.text = place.name
                }
            }
            
            
            } as! GMSPlaceLikelihoodListCallback)
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func close_btn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressUser(_ sender: Any) {
        performSegue(withIdentifier: "DetailToUser", sender: nil)
        print(92372937)
    }


    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        UIApplication.shared.statusBarStyle = .default
    }
    
}

//-------------------------------------------//
//Extesion para cuidar do Collection das tags//
//-------------------------------------------//

extension ProductDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath as IndexPath) as! TagsCellCollection
        cell.tagTitle.text = tags[(indexPath as NSIndexPath).row]
        cell.tagTitle.sizeToFit()
        cell.tagTitle.textAlignment = .center;
        cell.layer.cornerRadius = cell.bounds.height/2;
        
       
        
        return cell
    }
    
   /* func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
      //  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath as IndexPath) as! TagsCellCollection
    
        let cell = collectionView.cellForItem(at: indexPath) as! TagsCellCollection
            
        let itemWidth = cell.tagTitle.frame.width*2
        let itemHeight = cell.tagTitle.frame.height
        return CGSize(width: itemWidth, height: itemHeight)


    }*/
    
}




