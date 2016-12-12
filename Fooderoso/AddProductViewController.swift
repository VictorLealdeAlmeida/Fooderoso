//
//  AddProductViewController.swift
//  fooderoso
//
//  Created by Victor Leal Porto de Almeida Arruda on 29/11/16.
//  Copyright © 2016 AlunosDeKiev. All rights reserved.
//

import UIKit

class AddProductViewController: UIViewController {
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var valueText: UITextField!
    @IBOutlet weak var descripton: UITextView!
    
    
    var tags = ["#Doce", "#Salgado", "#Chocolate", "#Espacial", "#Bebida"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
        
        print(nameText.text)
        print(valueText.text)
        print(descripton.text)
        
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
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
        
        let color = UIColor(red:0.95, green:0.51, blue:0.36, alpha:1.00)
        
        let selectedCell:UICollectionViewCell = collectionView.cellForItem(at: indexPath)!

        if selectedCell.contentView.backgroundColor != color{
            selectedCell.contentView.backgroundColor = color
        }else{
            selectedCell.contentView.backgroundColor = UIColor(red:0.57, green:0.57, blue:0.57, alpha:1.00)
        }
        
        
        
        
        
        
        
    }
    
}
