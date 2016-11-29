//
//  ProductDetailViewController.swift
//  Fooderoso
//
//  Created by Victor Leal Porto de Almeida Arruda on 03/11/16.
//  Copyright © 2016 AlunosDeKiev. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    //-----
    //Views
    //-----
 
    @IBOutlet weak var talkSellerView: UIButton!
    @IBOutlet weak var photoUser: UIImageView!
    @IBOutlet weak var photoProduct: UIImageView!
    
    //-----
    //Infos
    //-----

    var imageName : String = ""
    
    
    //Conteudo pras tags, modificar pra antender o back-end
     var tags = ["#Doce", "#Salgado", "#Chocolate", "#Espacial", "#Bebida"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoProduct.image = UIImage(named: imageName)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //---------------
        //Ajustes na view
        //---------------
        talkSellerView.layer.cornerRadius = 10
        photoUser.layer.cornerRadius = photoUser.bounds.height/2;
        photoUser.clipsToBounds = true
        photoUser.layer.borderColor = UIColor(red:0.97, green:0.25, blue:0.47, alpha:1.00).cgColor
        photoUser.layer.borderWidth = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
        
    }
    
}

//--------------------------------------------//
//Extesion para cuidado do Collection das tags//
//--------------------------------------------//

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
 


