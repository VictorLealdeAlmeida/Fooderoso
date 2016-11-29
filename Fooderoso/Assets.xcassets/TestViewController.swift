//
//  TestViewController.swift
//  fooderoso
//
//  Created by Bruno Barbosa on 20/11/16.
//  Copyright © 2016 AlunosDeKiev. All rights reserved.
//

import UIKit

class TestViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.manager.loginAnonymously()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func createProduct(_ sender: Any) {
        let tags = [FDProductTag(withName: "chocolate"), FDProductTag(withName: "doce")]
        let prod = FDProduct(withName: "Cookie", andDesc: "Cookies deliciosos, feitos com muito amor", andPhoto: #imageLiteral(resourceName: "feijoada"), andPrice: 2.5, andSeller: self.currentUser!, andTags: tags)
        self.manager.saveProduct(prod)
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
