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
                let alert = UIAlertController(title: "Local indefinido", message: "Por favor, antes de ativar a venda, adicione o local no qual você está vendendo (Ex.: Centro de Informática - UFPE)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    sender.setOn(false, animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
                return
                
            } else { // there's a place already set up
                self.toggleLoading(true)
                self.manager.toggleSellingMode(true, location: self.currentPlace!)
            }
            
        } else { // turning the selling mode OFF
            self.toggleLoading(true)
            self.manager.toggleSellingMode(false)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(StoreViewController.sellingModeUpdated), name: FDNotification.sellingModeUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(StoreViewController.sellingModeFailed), name: FDNotification.sellingModeFailed, object: nil)
    }
    
    func toggleLoading(_ shouldLoad: Bool) {
        
    }
    
}

//--------------------------------------------//
//                  ACTIONS                   //
//--------------------------------------------//
extension StoreViewController {
    func sellingModeUpdated() {
        NotificationCenter.default.removeObserver(self, name: FDNotification.sellingModeUpdated, object: nil)
        NotificationCenter.default.removeObserver(self, name: FDNotification.sellingModeFailed, object: nil)
        
        let title: String
        let message: String
        
        if self.statusSwitch.isOn {
            title = "Vendendo!"
            message = "Pronto! Agora é partir pras vendas! ;-)"
        } else {
            title = "Venda desativada!"
            message = "A gente entende que todo mundo merece um pouco de descanso."
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        self.editBtn.isHidden = !self.statusSwitch.isOn
    }
    
    func sellingModeFailed() {
        NotificationCenter.default.removeObserver(self, name: FDNotification.sellingModeUpdated, object: nil)
        NotificationCenter.default.removeObserver(self, name: FDNotification.sellingModeFailed, object: nil)
        
        let message: String
        if self.statusSwitch.isOn {
            message = "Ocorreu algo estranho. Não foi possível ativar as vendas! :("
        } else {
            message = "Ocorreu algo estranho. Não foi possível desativar as vendas! :("
        }
        
        let alert = UIAlertController(title: "Ooops!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        self.statusSwitch.setOn(!self.statusSwitch.isOn, animated: true)
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
