//
//  LoadingViewController.swift
//  fooderoso
//
//  Created by Bruno Barbosa on 29/11/16.
//  Copyright © 2016 AlunosDeKiev. All rights reserved.
//

import UIKit

class LoadingViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(LoadingViewController.infoLoaded(notification:)), name: FDNotification.userLoggedInSuccessfully, object: nil)
        self.manager.loginAnonymously()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func infoLoaded(notification: Notification) {
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        let vc = mainSB.instantiateInitialViewController()
        self.show(vc!, sender: nil)
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
