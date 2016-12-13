//
//  CollectionViewController.swift
//  Fooderoso
//
//  Created by Victor Leal Porto de Almeida Arruda on 03/11/16.
//  Copyright © 2016 AlunosDeKiev. All rights reserved.
//

import UIKit

class CollectionViewController: BaseViewController {
    
    @IBOutlet var productsCollection: UICollectionView!
    @IBOutlet weak var photoUser: UIImageView!
    
    var activityIndicador: UIActivityIndicatorView?
    
    var items = ["1", "2", "3", "4", "5", "6", "7", "8"]
    var imagesItems = ["feijoada", "briga", "porco", "sunny", "feijoada", "briga", "porco", "sunny"]
    var indexSegue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getProducts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool){
        photoUser.layer.cornerRadius = photoUser.bounds.height/2;
        photoUser.clipsToBounds = true
        photoUser.layer.borderColor = UIColor(red:0.97, green:0.25, blue:0.47, alpha:1.00).cgColor
        photoUser.layer.borderWidth = 1
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.childViewControllers[0] as? ProductDetailViewController, let product = sender as? FDProduct {
            vc.currentProduct = product
        }
        
    }
    
    func getProducts() {
        NotificationCenter.default.addObserver(self, selector: #selector(CollectionViewController.productsLoaded(notification:)), name: FDNotification.noProductsFound, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CollectionViewController.productsLoaded(notification:)), name: FDNotification.productsFound, object: nil)
        
        self.toggleLoading()
        self.manager.getProducts()
    }
    
    func toggleLoading() {
        if self.activityIndicador == nil {
            // show the loading indicator
            self.activityIndicador = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            self.activityIndicador!.center = self.view.center
            self.activityIndicador!.hidesWhenStopped = true
            self.activityIndicador!.stopAnimating()
            self.view.addSubview(self.activityIndicador!)
            self.activityIndicador!.startAnimating()
            return
        }
        
        // remove the loading indicator
        self.activityIndicador!.stopAnimating()
        self.activityIndicador!.removeFromSuperview()
        self.activityIndicador = nil
    }
    

}

// Notification Listeners
extension CollectionViewController {
    func productsLoaded(notification: Notification) {
        if self.activityIndicador != nil {
            self.toggleLoading()
        }
        
        if self.manager.productsOnSale.count == 0 {
            // display an empty state view
            self.productsCollection.isHidden = true
            return
        }
        self.productsCollection.isHidden = false
        self.productsCollection.reloadData()
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.manager.productsOnSale.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath as IndexPath) as! CellCollection
        
        let product = self.manager.productsOnSale[indexPath.row]
        cell.configWithProduct(product: product)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("You selected cell #\(indexPath.item)!")
        
        let product = self.manager.productsOnSale[indexPath.row]
        performSegue(withIdentifier: "HomeToProduct", sender: product)
    }
    
    //DelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 50) / 2.0
        let height = width
        return CGSize(width: width, height: height)
    }
}
