//
//  CellCollection.swift
//  Fooderoso
//
//  Created by Victor Leal Porto de Almeida Arruda on 03/11/16.
//  Copyright © 2016 AlunosDeKiev. All rights reserved.
//

import UIKit
class CellCollection: UICollectionViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productText: UILabel!
    @IBOutlet var productPrice: UILabel!
    @IBOutlet var checkImg: UIImageView!

    
    func configWithProduct(product: FDProduct) {
        self.productImage.image = product.photo
        self.productText.text = product.name
        
        self.productPrice.text = "R$\(String(format: "%.2f", arguments: [product.price]))"
        
        self.toggleCheck(product.selling)
    }
    
    func toggleCheck(_ selling:Bool) {
        guard let _ = self.checkImg else {
            return
        }
        if selling {
            self.checkImg.isHidden = false
            self.alpha = 1.0
        } else {
            self.checkImg.isHidden = true
            self.alpha = 0.5
        }
    }
}


