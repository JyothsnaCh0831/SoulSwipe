//
//  Settings.swift
//  SoulSwipe
//
//  Created by Adapa,Venkata Rayudu on 5/25/23.
//

import UIKit

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func UpdatePassword(_ sender: UIButton) {
        let forgotpassword = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPassword")as! Forgotpassword
        self.navigationController?.pushViewController(forgotpassword, animated: true)
    }
    
    
    @IBAction func ViewBlockedProfiles(_ sender: UIButton) {
        
        let BlockedUsers = self.storyboard?.instantiateViewController(withIdentifier: "blockedProfiles")as! BlockedProfilesVC
        self.navigationController?.pushViewController(BlockedUsers, animated: true)
        
    }
    
    
    @IBAction func Logout(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
