//
//  CollectionViewController.swift
//  Fooderoso
//
//  Created by Victor Leal Porto de Almeida Arruda on 03/11/16.
//  Copyright © 2016 AlunosDeKiev. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    var items = ["1", "2", "3", "4", "5", "6", "7", "8"]
    var imagesItems = ["feijoada", "briga", "porco", "sunny", "feijoada", "briga", "porco", "sunny"]
    var indexSegue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! CellCollection

        cell.productImage.image = UIImage(named: imagesItems[(indexPath as NSIndexPath).row])!
        cell.productText.text = "Nome da imagem " + items[(indexPath as NSIndexPath).row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        print("You selected cell #\(indexPath.item)!")
        indexSegue = indexPath.item
        performSegue(withIdentifier: "HomeToProduct", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "HomeToProduct"){
            var result:ProductDetailViewController = ProductDetailViewController()
            result = (segue.destination as? ProductDetailViewController)!
            
            result.imageName = imagesItems[indexSegue]
        }
        
    }

}
