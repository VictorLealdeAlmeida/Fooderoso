//
//  UserViewController.swift
//  fooderoso
//
//  Created by Victor Leal Porto de Almeida Arruda on 13/12/16.
//  Copyright © 2016 AlunosDeKiev. All rights reserved.
//

import UIKit

class UserViewController: BaseViewController {
    
    @IBOutlet weak var userPhoto: UIImageView!
    //Se user for ele msm: TRUE / caso contrario: FALSE
    var user = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.manager.currentUser?.photo != nil{
            userPhoto.image = self.manager.currentUser?.photo
        }
        
    }
   
    @IBAction func openMenu(_ sender: Any) {
         initSheet()
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }

    
}

extension UserViewController: UIActionSheetDelegate{
    
    func initSheet(){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if user{
            actionSheet.addAction(UIAlertAction(title: "Editar", style: .default, handler: nil))
            actionSheet.addAction(UIAlertAction(title: "Sair", style: .default, handler: nil))
            actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))

        }else{
            actionSheet.addAction(UIAlertAction(title: "Enviar mensagem", style: .default, handler: nil))
            actionSheet.addAction(UIAlertAction(title: "Denunciar", style: .destructive, handler: nil))
            actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        }
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
}

extension UserViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.manager.productsOnSale.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath as IndexPath) as! CellCollection
        
        let product = self.manager.userProducts[indexPath.row]
        cell.configWithProduct(product: product)
        return cell
    }
    
    
    //DelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 50) / 2.0
        let height = width
        return CGSize(width: width, height: height)
    }
}
