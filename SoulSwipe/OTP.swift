//
//  OTP.swift
//  SoulSwipe
//
//  Created by Adapa,Venkata Rayudu on 5/18/23.
//

import UIKit

class OTP: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var OTP: UITextField!
    
    @IBOutlet weak var Password: UITextField!
    
    @IBOutlet weak var ConfirmPassword: UITextField!
    
    @IBOutlet weak var m: UISwitch!
    
    @IBOutlet weak var w: UISwitch!
    
    @IBAction func m(_ sender: Any) {
        if m.isOn == true {
            w.isEnabled = false
        }else{
            w.isEnabled = true
        }
    }
    
    @IBAction func w(_ sender: Any) {
        if w.isOn == true {
            m.isEnabled = false
        }else{
            m.isEnabled = true
        }
    }
    
    
    @IBOutlet weak var mm: UISwitch!
    
    @IBOutlet weak var ww: UISwitch!
    
    
    @IBAction func mm(_ sender: UISwitch) {
        if mm.isOn == true {
            ww.isEnabled = false
        }else{
            ww.isEnabled = true
        }
    }
    
    
    @IBAction func ww(_ sender: Any) {
        if ww.isOn == true {
            mm.isEnabled = false
        }else{
            mm.isEnabled = true
        }
    }
    
    
    @IBAction func Password(_ sender: Any) {
    }
    
    
    @IBAction func Verify(_ sender: UIButton) {
        if (OTP.text == ""){
            guard let password = self.OTP.text, !password.isEmpty else{
                showAlertModal(title: "Alert", message: "OTP field cannot be empty.")
                return
            }
        }
        if (OTP.text != ""){
            let Password = self.storyboard?.instantiateViewController(withIdentifier: "password")as! OTP
            self.navigationController?.pushViewController(Password, animated: true)
        }
        
    }
    
    @IBAction func Resend(_ sender: UIButton) {
        OTP.text = ""
        
    }
    
    @IBAction func QN(_ sender: Any) {
        
        if (m.isOn == false && w.isOn == false){
            showAlertModal(title: "Alert", message: "Please select the prefer gender.")
            return
        }
        if (mm.isOn == false && ww.isOn == false){
            showAlertModal(title: "Alert", message: "Please select the prefer gender.")
            return
        }
        
        
        if (m.isOn ==  true || w.isOn ==  true || mm.isOn ==  true || ww.isOn ==  true  ){
       // if ((m.isOn ==  true || w.isOn == false)&&(m.isOn ==  true || w.isOn == false)){
            let Q1 = self.storyboard?.instantiateViewController(withIdentifier: "q1")as! OTP
            self.navigationController?.pushViewController(Q1, animated: true)
        }
        
      /*  if (w.isOn ==  true || mm.isOn ==  true || ww.isOn ==  true  ){
            let Q1 = self.storyboard?.instantiateViewController(withIdentifier: "q1")as! OTP
            self.navigationController?.pushViewController(Q1, animated: true)
        }
        if (m.isOn ==  true || w.isOn ==  true || mm.isOn ==  true || ww.isOn ==  true  ){
            let Q1 = self.storyboard?.instantiateViewController(withIdentifier: "q1")as! OTP
            self.navigationController?.pushViewController(Q1, animated: true)
        }*/
        
        
        /*let Q1 = self.storyboard?.instantiateViewController(withIdentifier: "q1")as! OTP
         self.navigationController?.pushViewController(Q1, animated: true)*/
        
    }
    
    
    
    @IBAction func CreateAccount(_ sender: UIButton) {
        if (Password.text == "" || ConfirmPassword.text == ""){
            guard let username = self.Password.text, !username.isEmpty else{
                showAlertModal(title: "Alert", message: "password field cannot be empty.")
                return
            }
            guard let password = self.ConfirmPassword.text, !password.isEmpty else{
                showAlertModal(title: "Alert", message: "ConfirmPassword field cannot be empty.")
                return
            }
        }
        if (Password.text != ConfirmPassword.text ){
                showAlertModal(title: "Alert", message: "password and ConfirmPassword field must be same.")
                return
        }
        
        if (Password.text == ConfirmPassword.text ){
            let Q = self.storyboard?.instantiateViewController(withIdentifier: "g1")as! OTP
            self.navigationController?.pushViewController(Q, animated: true)
        }
        
        /*let Q = self.storyboard?.instantiateViewController(withIdentifier: "g1")as! OTP
        self.navigationController?.pushViewController(Q, animated: true)
        */
    }
    
    @IBAction func Q1N(_ sender: Any) {
        let Q2 = self.storyboard?.instantiateViewController(withIdentifier: "q2")as! OTP
        self.navigationController?.pushViewController(Q2, animated: true)
        
    }
    
    @IBAction func Q2N(_ sender: Any) {
        let Q3 = self.storyboard?.instantiateViewController(withIdentifier: "q3")as! OTP
        self.navigationController?.pushViewController(Q3, animated: true)
    }
    
    
    @IBAction func Q3N(_ sender: Any) {
        let Q4 = self.storyboard?.instantiateViewController(withIdentifier: "q4")as! OTP
        self.navigationController?.pushViewController(Q4, animated: true)
    }
    
    
    @IBAction func Q4N(_ sender: Any) {
    }
    
    private func showAlertModal(title: String, message: String){
     let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
     let okAction = UIAlertAction(title: "OK", style: .default)
     alertController.addAction(okAction)
     self.present(alertController, animated: true, completion: nil)
     }
    
}

