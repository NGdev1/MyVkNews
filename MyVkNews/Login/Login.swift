//
//  Login.swift
//  MyVkNews
//
//  Created by Apple on 25.06.17.
//  Copyright © 2017 flatstack. All rights reserved.
//

import UIKit
import SwiftyVK

class Login: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return tableView.frame.height / 2 - tableView.rowHeight / 2
        } else if indexPath.row == 1 {
            return tableView.rowHeight
        } else {
            return tableView.frame.height
        }
    }

    @IBAction func login(_ sender: Any) {
        VK.logIn()
        
        let _ = self.navigationController?.popToRootViewController(animated: true)
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
