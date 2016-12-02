//
//  AddProductViewController.swift
//  fooderoso
//
//  Created by Victor Leal Porto de Almeida Arruda on 29/11/16.
//  Copyright © 2016 AlunosDeKiev. All rights reserved.
//

import UIKit

class AddProductViewController: UIViewController {
    
    var tags = ["#Doce", "#Salgado", "#Chocolate", "#Espacial", "#Bebida"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

//-------------------------------------------//
//Extesion para cuidar do Collection das tags//
//-------------------------------------------//

extension AddProductViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("You selected cell #\(indexPath.item)!")
        
        let selectedCell:UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
        selectedCell.contentView.backgroundColor = UIColor(red:0.95, green:0.51, blue:0.36, alpha:1.00)
        
        selectedCell.
        
        
        
        
        
    }
    
}
