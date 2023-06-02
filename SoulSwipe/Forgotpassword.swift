//
//  Forgotpassword.swift
//  SoulSwipe
//
//  Created by Adapa,Venkata Rayudu on 5/24/23.
//

import UIKit
import Firebase

class Forgotpassword: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var emailLBL: UITextField!
    
    @IBAction func resetPassword(_ sender: UIButton) {
        guard let email = emailLBL.text, !email.isEmpty else{
            showAlertModal(title: "Alert", message: "Email field cannot be empty.")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email){error in
            if let e = error{
                self.showAlertModal(title: "Error", message: e.localizedDescription)
                self.emailLBL.text = ""
                //self.showAlertModal(title: "Alert", message: "Email is not registered. Please provide registered email only.")
            }else{
                let alertController = UIAlertController(title: "Success", message: "Reset password link is successfully send to your registered email.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    print("OK button tapped")
                    let login = self.storyboard?.instantiateViewController(withIdentifier: "Login")as! Login
                    self.navigationController?.pushViewController(login, animated: true)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)

            }
        }
    }
    
    private func showAlertModal(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
