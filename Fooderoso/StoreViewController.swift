//
//  StoreViewController.swift
//  fooderoso
//
//  Created by Victor Leal Porto de Almeida Arruda on 07/11/16.
//  Copyright © 2016 AlunosDeKiev. All rights reserved.
//

import UIKit

class StoreViewController: BaseViewController {
    
    @IBOutlet var statusSwitch: UISwitch!
    @IBOutlet var sellingTitleLbl: UILabel!
    @IBOutlet var placeBtn: UIButton!
    @IBOutlet var editBtn: UIButton!
    
    var currentPlace: String?
    
    var items = ["1", "2", "3", "4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statusSwitch.tintColor = UIColor(red:0.68, green:0.68, blue:0.68, alpha:1.00)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}

//--------------------------------------------//
//                  ACTIONS                   //
//--------------------------------------------//
extension StoreViewController {
    @IBAction func close_btn(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func statusChanged(_ sender: UISwitch) {
        
        if sender.isOn { // turning the selling mode ON
            
            if self.currentPlace == nil {
                // if theres no place set up, ask for the user to do it before turning it on
                let alert = UIAlertController(title: "Local indefinido", message: "Por favor, adicione o local no qual você está vendendo antes de continuar", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    sender.setOn(false, animated: true)
                }))
                
            } else { // there's a place already set up
                // show edit button of the collection view
                self.editBtn.isHidden = false
            }
            
        } else { // turning the selling mode OFF
            self.editBtn.isHidden = true
        }
    }
    
}

//--------------------------------------------//
//Extesion para cuidado do Collection dos produtos//
//--------------------------------------------//

extension StoreViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if((indexPath.row + 1) < self.items.count){

        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath as IndexPath) as! CellCollection
            
            
            cell.productImage.image = UIImage(named: "feijoada")!
            cell.productText.text = items[(indexPath as NSIndexPath).row]
            
            return cell
            
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addProductCell", for: indexPath) 
            return cell;
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        if((indexPath.row + 1) == self.items.count){
        
            print("You selected cell #\(indexPath.item)!")
            performSegue(withIdentifier: "addProdSegue", sender: nil)
                
        }else{
            
            let selectedCell:UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
            
            if selectedCell.contentView.alpha != 1{
                selectedCell.contentView.alpha = 1
            }else{
                selectedCell.contentView.alpha = 0.5
            }
        }
        
        
        

    }
    
    //DelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - 50) / 2.0
        let height = width
        return CGSize(width: width, height: height)
    }
    
    
    
}
