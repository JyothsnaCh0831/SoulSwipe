//
//  Login.swift
//  SoulSwipe
//
//  Created by Adapa,Venkata Rayudu on 5/18/23.
//

import UIKit
import Firebase

class Login: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Password: UITextField!
    let db = Firestore.firestore()
    
    
    @IBAction func Email(_ sender: UITextField) {
        
    }
    
    @IBAction func Password(_ sender: UITextField) {
    }
    
    @IBAction func Login(_ sender: UIButton) {
        
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
                self.db.collection("Users").document(username).getDocument { (document, error) in
                    if let document = document, document.exists {
                        let data = document.data()
                        if let role = data?["role"] as? String, role == "user" {
                            self.db.collection("CompatabilityQuiz").document(username).getDocument { (document, error) in
                                if let document = document, document.exists {
                                    let tabbar = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar")as! UserTabBarVC
                                    self.navigationController?.pushViewController(tabbar, animated: true)
                                } else {
                                    print("Document does not exist")
                                    let gender = self.storyboard?.instantiateViewController(withIdentifier: "s1")as! CompatabilityQuizVC
                                    self.navigationController?.pushViewController(gender, animated: true)
                                }
                            }
                        } else {
                            print("Role is not 'user' or does not exist")
                        }
                    } else {
                        print("Document does not exist")
                        self.showAlertModal(title: "Alert", message: "User does not exist.")
                    }
                }
                
                /*let gender = self.storyboard?.instantiateViewController(withIdentifier: "s1")as! CompatabilityQuizVC
                self.navigationController?.pushViewController(gender, animated: true)
                
                let tabbar = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar")as! UserTabBarVC
                self.navigationController?.pushViewController(tabbar, animated: true)*/
                
            }
        }
    }
    
    private func showAlertModal(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func Register(_ sender: UIButton) {
        let register = self.storyboard?.instantiateViewController(withIdentifier: "Register")as! Register
        self.navigationController?.pushViewController(register, animated: true)
    }
    
    @IBAction func AdminLogin(_ sender: UIButton) {
        let adminlogin = self.storyboard?.instantiateViewController(withIdentifier: "Adminlogin")as! Adminlogin
        self.navigationController?.pushViewController(adminlogin, animated: true)
        
    }
    
    @IBAction func Forgotpassword(_ sender: UIButton) {
        let forgotpassword = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPassword")as! Forgotpassword
        self.navigationController?.pushViewController(forgotpassword, animated: true)
        
    }
    
    
    
}

