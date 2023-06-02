//
//  Register.swift
//  Soul Swipe
//
//  Created by Adapa,Venkata Rayudu on 5/17/23.
//

import UIKit
import Firebase

class Register: UIViewController {

    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var Email: UITextField!
    
    @IBOutlet weak var Firstname: UITextField!
    
    @IBOutlet weak var Lastname: UITextField!
    
    @IBAction func Email(_ sender: UITextField) {
    }
    
    
    @IBAction func Login(_ sender: UIButton) {
        
        let login = self.storyboard?.instantiateViewController(withIdentifier: "Login")as! Login
        self.navigationController?.pushViewController(login, animated: true)
        
    }
    
    @IBAction func Register(_ sender: UIButton) {
        
        /* Getting date and converting into string */
        let selectedDate = datePicker.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let formattedDate = dateFormatter.string(from: selectedDate)
        
        let calendar = Calendar.current
        let now = Date()
        
        /* Checking the age of the user */
        let ageComponents = calendar.dateComponents([.year], from: selectedDate, to: now)
        guard let age = ageComponents.year else {
            return
        }
    
        
        guard let email = self.Email.text, !email.isEmpty else{
            showAlertModal(title: "Alert", message: "Email field cannot be empty.")
            return
        }
        guard let firstname = self.Firstname.text, !firstname.isEmpty else{
            showAlertModal(title: "Alert", message: "First Name cannot be empty.")
            return
        }
        guard let lastname = self.Lastname.text, !lastname.isEmpty else{
            showAlertModal(title: "Alert", message: "Last Name cannot be empty.")
            return
        }
        
        if(age < 18) {
            showAlertModal(title: "Alert", message: "You must be at least 18 years old.")
            return
        }
        
        if self.hasCorrectDomain(email: email) {
                Auth.auth().createUser(withEmail: email, password: "dummypswdnwmsu@!123") { firebaserslt, err in
                    if let e = err{
                        print(e)
                        let alertController = UIAlertController(title: "Error", message: "User with same email already exists.", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                            print("OK button tapped")
                            let login = self.storyboard?.instantiateViewController(withIdentifier: "Login")as! Login
                            self.navigationController?.pushViewController(login, animated: true)
                        }
                        alertController.addAction(okAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else{
                        self.db.collection("Users").whereField("Email", isEqualTo: email).getDocuments { (snapshot, error) in
                            if let error = error {
                                print("Error getting documents: \(error)")
                                return
                            }
                            if let snapshot = snapshot {
                                if !snapshot.isEmpty {
                                    for document in snapshot.documents {
                                        let documentData = document.data()
                                        print(documentData)
                                    }
                                    print("Success")
                                } else {
                                    self.db.collection("Users").document(email).setData(["First Name": firstname,"Last Name": lastname,"Email": email, "role" : "user", "emailInLowerCase":email.lowercased(),
                                        "dateOfBirth": formattedDate,
                                        "Job": String(),
                                        "Likes": 0,
                                        "About Me": String()
                                    ])
                                    print("Inserted user record")
                                    self.Lastname.text = ""
                                    self.Firstname.text = ""
                                    self.Email.text = ""
                                }
                            }
                        }
                        Auth.auth().sendPasswordReset(withEmail: email){error in
                            if let e = error{
                                self.showAlertModal(title: "Error", message: e.localizedDescription)
                            }else{
                                let alertController = UIAlertController(title: "Success", message: "User registered successfully with default password. A password link is send to your registered email for setting your password.", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                    print("OK button tapped")
                                    let otp = self.storyboard?.instantiateViewController(withIdentifier: "Login")as! Login
                                    self.navigationController?.pushViewController(otp, animated: true)
                                }
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true, completion: nil)
                                
                            }
                        }
                    }
                }
            }else {
            self.showAlertModal(title: "Alert", message: "Email does not have the correct domain. Please try with registered email id.")
            self.Email.text = ""
        }
          
    }
    
    private func hasCorrectDomain(email: String) -> Bool {
        let emailDomain = "@gmail.com"
        return email.hasSuffix(emailDomain)
    }
    
    private func showAlertModal(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!

}


