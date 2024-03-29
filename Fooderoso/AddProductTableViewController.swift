//
//  AddProductTableViewController.swift
//  fooderoso
//
//  Created by Bruno Barbosa on 20/12/16.
//  Copyright © 2016 AlunosDeKiev. All rights reserved.
//

import UIKit

class AddProductTableViewController: UITableViewController {

    @IBOutlet var photoProd: UIButton!
    @IBOutlet var prodImageView: UIImageView!
    @IBOutlet var nameTxtFld: UITextField!
    @IBOutlet var priceTxtFld: UITextField!
    @IBOutlet var descTxtFld: UITextField!
    
    @IBOutlet var tagsCollection: UICollectionView!
    @IBOutlet var charactersCount: UILabel!
    
    var prodImage: UIImage? {
        didSet {
            if self.prodImage != nil {
                self.prodImageView.image = self.prodImage
            }
            
            // reload the table to show or hide the image
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            self.tableView.reloadData()
        }
    }
    let manager = FooderosoManager.instance
    var loadingView: UIView?
    
    var currentProduct: FDProduct?
    
    // Test Data
    var tags = [
        FDProductTag(withName: "doce"),
        FDProductTag(withName: "salgado"),
        FDProductTag(withName: "fritinhos"),
        FDProductTag(withName: "espacial"),
        FDProductTag(withName: "bebidas"),
        FDProductTag(withName: "geladinhos"),
        FDProductTag(withName: "chocolate"),
        FDProductTag(withName: "vegano"),
        FDProductTag(withName: "vegetariano"),
        FDProductTag(withName: "zero-lactose")
    ]
    var selectedTags: [FDProductTag] = []
    var selectedTagsDict: [String : Bool] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadInfo()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func loadInfo() {
        for tag in self.tags {
            self.selectedTagsDict[tag.name] = false
        }
        
        if let product = self.currentProduct {
            self.nameTxtFld.text = product.name
            self.priceTxtFld.text = "\(String(format: "%.2f", arguments: [product.price]))"
            self.descTxtFld.text = product.prodDescription
            self.prodImage = product.photo
            
            for tag in product.tags {
                self.selectedTags.append(tag)
                self.selectedTagsDict[tag.name] = true
            }
            
            self.tagsCollection.reloadData()
        }
        self.descTxtFld.delegate = self
        self.charactersCount.text = "\(140-self.descTxtFld.text!.characters.count)/140"
    }
}

//-------------------------------------------//
//         TABLE VIEW RELATED STUFF          //
//-------------------------------------------//
extension AddProductTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            switch indexPath.row {
                case 0:
                    if self.prodImage == nil {
                        return 0.0
                    }
                    return 150
                case 1:
                    return 70
                case 2:
                    return 56
                case 3:
                    return 90
                default:
                    return 70
            }
        }
        
        // its the second section
        return 140
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        } else {
            return 30.0
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
}

//-------------------------------------------//
//                  ACTIONS                 //
//-------------------------------------------//
extension AddProductTableViewController {
    
    @IBAction func selectImage(_ sender: Any) {
        let alert = UIAlertController(title: "Imagem do produto", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Importar da biblioteca", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "Tirar foto", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                let alertMsg = UIAlertController(title: "Permissão necessária", message: "Por favor permita o acesso à camera nas configurações do aplicativo", preferredStyle: UIAlertControllerStyle.alert)
                alertMsg.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            }
        }))
        
        if prodImage != nil {
            alert.addAction(UIAlertAction(title: "Remover imagem", style: .destructive, handler: { (action) in
                self.prodImage = nil
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveInfo(_ sender: Any) {
        guard let image = self.prodImage, let name = self.nameTxtFld.text, let price = Double(self.priceTxtFld.text!), let desc = self.descTxtFld.text else {
            let alert = UIAlertController(title: "Informações faltando", message: "Por favor, preencha todas as informações para salvar o produto.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if self.selectedTags.count <= 0 {
            let alert = UIAlertController(title: "Informações faltando", message: "Por favor, selecione ao menos uma tag para classificar seu produto.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if let product = self.currentProduct {
            product.name = name
            product.prodDescription = desc
            product.price = price
            product.photo = image
            product.tags = self.selectedTags
            
            NotificationCenter.default.addObserver(self, selector: #selector(AddProductTableViewController.productSaved(notification:)), name: FDNotification.productUpdateSucceeded, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(AddProductTableViewController.productNotSaved(notification:)), name: FDNotification.productUpdateFailed, object: nil)
            
            self.manager.updateProduct(product, allTags: self.tags)
        } else {
            let product = FDProduct(withName: name, andDesc: desc, andPhoto: image, andPrice: price, andSeller: self.manager.currentUser!, andTags: self.selectedTags)
            
            NotificationCenter.default.addObserver(self, selector: #selector(AddProductTableViewController.productSaved(notification:)), name: FDNotification.productCreatedSuccessfully, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(AddProductTableViewController.productNotSaved(notification:)), name: FDNotification.productCreationFailed, object: nil)
            
            self.manager.saveProduct(product)
        }
        
        // Add Loading indicator
//        let blurView = UIVisualEffectView(frame: self.view.frame)
//        blurView.effect = UIBlurEffect(style: UIBlurEffectStyle.light)
//        let blurView = UIView(frame: self.view.frame)
//        blurView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        
//        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
//        self.loadingView = blurView
//        self.view.addSubview(self.loadingView!)
//        self.loadingView!.addSubview(activityIndicator)
//        activityIndicator.frame.
        
        self.toggleLoading(true)
        
    }
    
    @IBAction func cancelAdd(_ sender: Any) {
        let alert = UIAlertController(title: "Descartar produto ", message: "Ao sair sem salvar, as infomações inseridas serão descartadas. Deseja descartar as informações do novo produto?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Descartar", style: .default, handler: { (action) in
            self.navigationController?.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func toggleLoading(_ shouldLoad: Bool) {
        if shouldLoad {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            activityIndicator.startAnimating()
            let rightButton = UIBarButtonItem(customView: activityIndicator)
            self.navigationItem.rightBarButtonItem = rightButton
        } else {
            let rightButton = UIBarButtonItem(title: "Salvar", style: UIBarButtonItemStyle.done, target: self, action: #selector(AddProductTableViewController.saveInfo(_:)))
            self.navigationItem.rightBarButtonItem = rightButton
        }
        
        // change the status of the elements:
        self.navigationItem.leftBarButtonItem?.isEnabled = !shouldLoad
        self.photoProd.isEnabled = !shouldLoad
        self.nameTxtFld.isEnabled = !shouldLoad
        self.priceTxtFld.isEnabled = !shouldLoad
        self.descTxtFld.isEnabled = !shouldLoad
        self.tagsCollection.isUserInteractionEnabled = !shouldLoad
    }
    
}

//-------------------------------------------//
//          NOTIFICATION LISTENERS           //
//-------------------------------------------//
extension AddProductTableViewController {
    func productSaved(notification: Notification) {
        let alert = UIAlertController(title: "Produto Salvo", message: "Seu produto foi salvo com sucesso!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.navigationController?.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func productNotSaved(notification: Notification) {
        let alert = UIAlertController(title: "Falha", message: "Ocorreu uma falha ao salvar o produto. Por favor, tente novamente.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


//-------------------------------------------//
//                COLLECTION                 //
//-------------------------------------------//

extension AddProductTableViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let tag = tags[(indexPath as NSIndexPath).row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath as IndexPath) as! TagsCellCollection
        cell.tagTitle.text = "#\(tag.name)"
        cell.tagTitle.sizeToFit()
        cell.tagTitle.textAlignment = .center;
        cell.layer.cornerRadius = cell.bounds.height/2;
        
        let isSelected = self.selectedTagsDict[tags[(indexPath as NSIndexPath).row].name] ?? false
        if isSelected {
            cell.contentView.backgroundColor = UIColor(red:0.95, green:0.51, blue:0.36, alpha:1.00)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("You selected cell #\(indexPath.item)!")
        
        let tag = self.tags[indexPath.row]
        
        let hightLightColor = UIColor(red:0.95, green:0.51, blue:0.36, alpha:1.00) // orange
        
        let selectedCell:UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
        
        if selectedCell.contentView.backgroundColor != hightLightColor {
            selectedCell.contentView.backgroundColor = hightLightColor
            self.selectedTags.append(tag)
            self.selectedTagsDict[tag.name] = true
        }else{
            selectedCell.contentView.backgroundColor = UIColor(red:0.68, green:0.68, blue:0.68, alpha:1.00) // gray
            
            // remove from selected
            for (index, currentTag) in self.selectedTags.enumerated() {
                if currentTag.name == tag.name {
                    self.selectedTags.remove(at: index)
                    break
                }
            }
            self.selectedTagsDict[tag.name] = false
            
            for (index, currentTag) in self.tags.enumerated() {
                if currentTag.name == tag.name {
                    self.selectedTags.remove(at: index)
                }
            }
        }
        
    }
    
}

//-------------------------------------------//
//               IMAGE PICKER                //
//-------------------------------------------//
extension AddProductTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [AnyHashable: Any]!) {
        self.prodImage = image
        self.dismiss(animated: true, completion: nil);
    }
}


//-------------------------------------------//
//             TEXT FIELD DELEGATE            //
//-------------------------------------------//
extension AddProductTableViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newSize = textField.text!.characters.count + (string.characters.count - range.length)
        if newSize <= 140 {
            self.charactersCount.text = "\(140-newSize)/140"
            return true
        }
        return false
    }
}
