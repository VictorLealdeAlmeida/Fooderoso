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
    @IBOutlet weak var talkSellerView: UIView!
 
    @IBOutlet weak var photoUser: UIImageView!
    
    
    //Conteudo pras tags, modificar pra antender o back-end
     var tags = ["Doce", "Salgado", "Chocolate", "Espacial", "Bebida"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //---------------
        //Ajustes na view
        //---------------
        talkSellerView.layer.cornerRadius = 10
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
}

//--------------------------------------------//
//Extesion para cuidado do Collection das tags//
//--------------------------------------------//

extension ProductDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath as IndexPath) as! TagsCellCollection
        cell.tagTitle.text = tags[(indexPath as NSIndexPath).row]
        cell.layer.cornerRadius = cell.bounds.height/2;
        
        return cell
    }
}
