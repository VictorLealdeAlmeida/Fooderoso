//
//  AddProductTableViewController.swift
//  fooderoso
//
//  Created by Bruno Barbosa on 20/12/16.
//  Copyright © 2016 AlunosDeKiev. All rights reserved.
//

import UIKit

class AddProductTableViewController: UITableViewController {

    @IBOutlet var prodImageView: UIImageView!
    @IBOutlet var nameTxtFld: UITextField!
    @IBOutlet var priceTxtFld: UITextField!
    @IBOutlet var descTxtFld: UITextField!
    
    @IBOutlet var tagsCollection: UICollectionView!
    
    var prodImage: UIImage? {
        didSet {
            self.prodImageView.image = self.prodImage
            
            // reload the table to show or hide the image
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.top)
//            self.tableView.reloadData()
        }
    }
    
    var tags = ["#Doce", "#Salgado", "#Chocolate", "#Espacial", "#Bebida"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            return 0.0
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
        let alert = UIAlertController(title: "Imagem do produto", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Importar da biblioteca", style: .default, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction(title: "Imagem da câmera", style: .default, handler: { (action) in
            
        }))
        
        if prodImage != nil {
            alert.addAction(UIAlertAction(title: "Remover imagem", style: .destructive, handler: { (action) in
                self.prodImage = nil
            }))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveInfo(_ sender: Any) {
    }
    
    @IBAction func cancelAdd(_ sender: Any) {
        let alert = UIAlertController(title: "Cancelar", message: "Tem certeza de que deseja cancelar a adição de um novo produto?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continuar editando", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirmar", style: .default, handler: { (action) in
            self.navigationController?.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

//-------------------------------------------//
//Extesion para cuidar da Collection das tags//
//-------------------------------------------//

extension AddProductTableViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
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