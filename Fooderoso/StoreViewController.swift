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
    @IBOutlet var productsCollection: UICollectionView!
    
    var loadingView: UIView?
    var collectionLoading: UIActivityIndicatorView?
    
    var currentPlace: String? {
        didSet {
            if currentPlace == nil {
                self.placeBtn.setTitle("Adicionar Local", for: .normal)
                self.placeBtn.setTitle("Adicionar Local", for: .disabled)
            } else {
                 self.placeBtn.setTitle(self.currentPlace, for: .normal)
                self.placeBtn.setTitle(self.currentPlace, for: .disabled)
            }
        }
    }

    var editingProducts: Bool = false
    var changedProductsKeys: [String : Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.statusSwitch.tintColor = UIColor(red:0.68, green:0.68, blue:0.68, alpha:1.00)
        
        self.loadInfo()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.childViewControllers.first as? AddProductTableViewController, let product = sender as? FDProduct {
            vc.currentProduct = product
        }
    }
    
    func loadInfo() {
        self.toggleCollectionLoading(true)
        
        NotificationCenter.default.addObserver(self, selector: #selector(StoreViewController.loadSellingStatus), name: FDNotification.userLoggedInSuccessfully, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(StoreViewController.loadProducts), name: FDNotification.userProductAdded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(StoreViewController.loadProducts), name: FDNotification.userProductChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(StoreViewController.loadProducts), name: FDNotification.userProductRemoved, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(StoreViewController.loadProducts), name: FDNotification.noUserProductsFound, object: nil)
        
        self.loadSellingStatus()
        self.manager.getUserProducts()
    }
    
    func loadSellingStatus() {
        self.statusSwitch.setOn(self.manager.currentUser!.selling, animated: true)
        self.currentPlace = self.manager.currentUser?.location
    }
    
    func loadProducts() {
        DispatchQueue.main.async {
            self.toggleCollectionLoading(false)
//            self.products = self.manager.userProducts
            self.productsCollection.reloadData()
        }
    }
    
    func toggleCollectionLoading(_ shouldLoad: Bool) {
        if shouldLoad {
            
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            activityIndicator.center = self.productsCollection.center
            self.view.addSubview(activityIndicator)
            self.collectionLoading = activityIndicator
            
            UIView.animate(withDuration: 0.3, animations: {
                self.productsCollection.alpha = 0.0
            }, completion: { (Bool) in
                if self.manager.userProducts.count <= 0 {
                    self.productsCollection.isHidden = true
                    activityIndicator.startAnimating()
                }
            })
        } else {
            
            if let activityIndicator = self.collectionLoading {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
                self.collectionLoading = nil
            }
            
            self.productsCollection.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.productsCollection.alpha = 1.0
            })
        }
    }
    
    func toggleLoading(_ shouldLoad: Bool) {
        if shouldLoad {
            let blurView = UIVisualEffectView(frame: self.view.frame)
            blurView.effect = UIBlurEffect(style: UIBlurEffectStyle.light)
            blurView.center = self.view.center
            let activityIndicador = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            activityIndicador.center = blurView.center
            activityIndicador.startAnimating()
            blurView.addSubview(activityIndicador)
            blurView.alpha = 0.0
            self.loadingView = blurView
            self.view.addSubview(self.loadingView!)
            UIView.animate(withDuration: 0.3, animations: { 
                blurView.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: { 
                self.loadingView?.alpha = 0.0
            }, completion: { (Bool) in
                self.loadingView?.removeFromSuperview()
            })
        }
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
    
    @IBAction func changePlace(_ sender: UIButton) {
        if self.currentPlace != nil {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Alterar local", style: UIAlertActionStyle.default, handler: { (action) in
                self.changePlace()
            }))
            actionSheet.addAction(UIAlertAction(title: "Remover local", style: .destructive, handler: { (action) in
                self.currentPlace = nil
            }))
            actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            self.present(actionSheet, animated: true, completion: nil)
        } else {
            self.changePlace()
        }
    }
    
    private func changePlace() {
        // TODO: handle place searching
        let alert = UIAlertController(title: "Adicionar local", message: "Digite abaixo o nome do local onde você está vendendo.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Centro de Informática - UFPE"
        }
        alert.addAction(UIAlertAction(title: "Adicionar", style: .default, handler: { (action) in
            let place = alert.textFields?[0].text
            if place == nil || place!.isEmpty {
                // handle not valid place
                return
            }
            self.currentPlace = place
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func toggleEditingProd(_ sender: Any) {
        self.isEditing = !self.isEditing
        
        if self.isEditing {
            self.editBtn.setTitle("Salvar", for: .normal)
            let alert = UIAlertController(title: "Selecionar produtos", message: "Selecione os produtos a serem vendidos no momento", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.editBtn.setTitle("Editar", for: .normal)
            self.manager.updateSellingProducts(productsKeysToUpdate: self.changedProductsKeys)
            self.changedProductsKeys = [:]
        }
    }
    
}

//--------------------------------------------//
//               NOTIFICATIONS                //
//--------------------------------------------//
extension StoreViewController {
    func sellingModeUpdated() {
        self.toggleLoading(false)
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
        self.placeBtn.isEnabled = !self.statusSwitch.isOn
    }
    
    func sellingModeFailed() {
        self.toggleLoading(false)
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
//          COLLECTION VIEW PRODUCTS          //
//--------------------------------------------//

extension StoreViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.manager.userProducts.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == self.manager.userProducts.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addProductCell", for: indexPath)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath as IndexPath) as! CellCollection
        let product = self.manager.userProducts[(indexPath as NSIndexPath).row]

        cell.configWithProduct(product: product)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        
        if indexPath.row == self.manager.userProducts.count {
        
            print("You selected cell #\(indexPath.item)!")
            performSegue(withIdentifier: "addProdSegue", sender: nil)
                
        } else {
            let product = self.manager.userProducts[indexPath.row]
            if self.editingProducts {
                // multiple selection
                product.selling = !product.selling
                let cell = collectionView.cellForItem(at: indexPath) as! CellCollection
                cell.toggleCheck(product.selling)
                self.changedProductsKeys[product.id!] = product.selling
            } else {
                // single selection
                performSegue(withIdentifier: "addProdSegue", sender: product)
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
