//
//  AdminDashBoard.swift
//  SoulSwipe
//
//  Created by Adapa,Venkata Rayudu on 5/24/23.
//

import UIKit

class AdminDashBoard: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func ViewUsers(_ sender: UIButton) {
        let list = self.storyboard?.instantiateViewController(withIdentifier: "userslist")as! UsersList
        self.navigationController?.pushViewController(list, animated: true)
    }
    
    
    @IBAction func Logout(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
