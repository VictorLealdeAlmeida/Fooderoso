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

    
    func configWithProduct(product: FDProduct) {
        self.productImage.image = product.photo
        self.productText.text = product.name
        
        self.productPrice.text = "R$\(String(format: "%.2f", arguments: [product.price]))"
    }
}


