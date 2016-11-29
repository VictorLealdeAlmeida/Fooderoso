//
//  StoreViewController.swift
//  fooderoso
//
//  Created by Victor Leal Porto de Almeida Arruda on 07/11/16.
//  Copyright © 2016 AlunosDeKiev. All rights reserved.
//

import UIKit

class StoreViewController: UIViewController {
    
    var items = ["1", "2", "3", "4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
   
}

//--------------------------------------------//
//Extesion para cuidado do Collection das tags//
//--------------------------------------------//

extension StoreViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if((indexPath.row + 1) < self.items.count){

        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreCellColection", for: indexPath as IndexPath) as! CellCollection
            
            
            cell.productImage.image = UIImage(named: "feijoada")!
            cell.productText.text = items[(indexPath as NSIndexPath).row]
            
            return cell
            
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddProduct", for: indexPath) 
            return cell;
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
    }
    
    
    
}
