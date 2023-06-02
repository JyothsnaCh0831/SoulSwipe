//
//  Adminlogin.swift
//  SoulSwipe
//
//  Created by Adapa,Venkata Rayudu on 5/24/23.
//

import UIKit
import Firebase

class Adminlogin: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    let db = Firestore.firestore()
    
    
    @IBAction func Email(_ sender: Any) {
    }
    
    @IBAction func Password(_ sender: UITextField) {
    }
    
    @IBAction func AdminLogin(_ sender: UIButton) {
            guard let username = self.Email.text, !username.isEmpty else{
                showAlertModal(title: "Alert", message: "Email field cannot be empty.")
                return
            }
            guard let password = self.Password.text, !password.isEmpty else{
                showAlertModal(title: "Alert", message: "Password field cannot be empty.")
                return
            }
     
        Auth.auth().signIn(withEmail: username, password: password) { firebaseResult, error in
            if let err = error{
                let alertController = UIAlertController(title: "Error", message: "Invalid credentails. Please try agaian with correct credentails.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                print(err)
            }else{
                self.db.collection("Admin").document(username).getDocument { (document, error) in
                    if let document = document, document.exists {
                        let data = document.data()
                        if let role = data?["role"] as? String, role == "admin" {
                            let dashboard = self.storyboard?.instantiateViewController(withIdentifier: "Dashboard")as! AdminDashBoard
                            self.navigationController?.pushViewController(dashboard, animated: true)
                        } else {
                            print("Role is not 'admin' or does not exist")
                        }
                    } else {
                        print("Document does not exist")
                        self.showAlertModal(title: "Alert", message: "User does not exist.")
                    }
                }
            }
        }
    }
        
        @IBAction func Forgotpassword(_ sender: UIButton) {
            let forgotpassword = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPassword")as! Forgotpassword
            self.navigationController?.pushViewController(forgotpassword, animated: true)
        }
        
    private func showAlertModal(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
        
    }
    
 


