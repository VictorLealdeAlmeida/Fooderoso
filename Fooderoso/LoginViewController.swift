//
//  LoginViewController.swift
//  fooderoso
//
//  Created by Bruno Barbosa on 13/12/16.
//  Copyright © 2016 AlunosDeKiev. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet var emailTxtFld: UITextField!
    @IBOutlet var passwordTxtFld: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    @IBAction func login(_ sender: Any) {
        guard let email = emailTxtFld.text, let password = passwordTxtFld.text else {
            let alert = UIAlertController(title: "Campos vazios", message: "Por favor, certifique-se de preencher e-mail e senha", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        self.manager.login(withEmail: email, withAndPassword: password)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.userLoggedSuccessfully), name: FDNotification.userLoggedInSuccessfully, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.userLoginFailed), name: FDNotification.userNotLogged, object: nil)
        
        
    }
    
    func userLoggedSuccessfully() {
        // Dissmiss
    }
    
    func userLoginFailed() {
        let alert = UIAlertController(title: "Oops!", message: "Algo deu errado ao tentar fazer login :( \nCertifique-se de que o e-mail e senha estão corretos.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

}
