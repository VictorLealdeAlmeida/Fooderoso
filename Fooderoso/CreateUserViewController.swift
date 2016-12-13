//
//  CreateUserViewController.swift
//  fooderoso
//
//  Created by Bruno Barbosa on 13/12/16.
//  Copyright © 2016 AlunosDeKiev. All rights reserved.
//

import UIKit

class CreateUserViewController: UITableViewController {

    @IBOutlet var nameTxtFld: UITextField!
    @IBOutlet var descTxtFld: UITextField!
    @IBOutlet var emailTxtFld: UITextField!
    @IBOutlet var passwordTxtFld: UITextField!
    @IBOutlet var confirmPasswordTxtFld: UITextField!
    
    var manager: FooderosoManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.manager = FooderosoManager.instance

        // Do any additional setup after loading the view.
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
    
    @IBAction func cancel_btn(_ sender: Any) {
        let alert = UIAlertController(title: "Cancelar", message: "Tem certeza de que deseja cancelar a criação do usuário?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Não", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Sim", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func save_btn(_ sender: Any) {
        guard let name = self.nameTxtFld.text,
            let desc = self.descTxtFld.text,
            let email = self.emailTxtFld.text,
            let password = self.passwordTxtFld.text,
            let passwordConfirm = self.confirmPasswordTxtFld.text else {
                
                let alert = UIAlertController(title: "Campos faltando", message: "Por favor, preencha todos os campos para criar seu usário.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        if password != passwordConfirm {
            let alert = UIAlertController(title: "Senha não confere", message: "Por favor, certifique-se de digitar a mesma senha no campo de confirmação.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
//        let user = FDUser(
<<<<<<< HEAD
//        self.manager.saveNewUser(<#T##user: FDUser##FDUser#>)
=======
     //   self.manager.saveNewUser(<#T##user: FDUser##FDUser#>)
>>>>>>> 1ea01746a9d0c4ccf9a343771bb0f2b04f88d0b1
        
    }
    

}
