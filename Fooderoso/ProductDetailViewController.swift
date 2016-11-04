//
//  ProductDetailViewController.swift
//  Fooderoso
//
//  Created by Victor Leal Porto de Almeida Arruda on 03/11/16.
//  Copyright © 2016 AlunosDeKiev. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
     var tags = ["Doce", "Salgado", "Chocolate", "Espacial"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath as IndexPath) as! TagsCellCollection
        
        
        cell.tagTitle.text = "#Hast"
        
        return cell
    }
    
    
    //######################################################################
    //ACHO QUE NAO FAZ SENTIDO SELECIONAR, APAGAR QUANDO TIVER CTZ
    //######################################################################
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
}
