//
//  CompatabilityQuizVC.swift
//  SoulSwipe
//
//  Created by Adapa,Venkata Rayudu on 5/24/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CompatabilityQuizVC: UIViewController {
    
    let db = Firestore.firestore()
    
    /* Storing user's choices */
    var selectedQuestionOneOptions: [String] = []
    var selectedQuestionTwoOptions: [String] = []
    var selectedQuestionThreeOptions: [String] = []
    var selectedQuestionFourOptions: [String] = []
    var selectedQuestionFiveOptions: [String] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /* User's Choice */
    @IBOutlet weak var man1: UISwitch!
    @IBOutlet weak var woman1: UISwitch!
    
    @IBAction func man1(_ sender: Any) {
        if man1.isOn == true {
            woman1.isEnabled = false
        }else{
            woman1.isEnabled = true
        }
    }
    
    @IBAction func woman1(_ sender: Any) {
        if woman1.isOn == true {
            man1.isEnabled = false
        }else{
            man1.isEnabled = true
        }
    }
    
    
    /* User's Match Gender */
    @IBOutlet weak var man2: UISwitch!
    @IBOutlet weak var woman2: UISwitch!
    
    @IBAction func man2(_ sender: UISwitch) {
        if man2.isOn == true {
            woman2.isEnabled = false
        }else{
            woman2.isEnabled = true
        }
    }
    
    @IBAction func woman2(_ sender: Any) {
        if woman2.isOn == true {
            man2.isEnabled = false
        }else{
            man2.isEnabled = true
        }
    }
    
    
    /* User's Genders Selection Verification */
    @IBAction func steps1(_ sender: Any) {
        
        /* For User's Gender - if nothing is selected */
        if (man1.isOn == false && woman1.isOn == false){
            showAlertModal(title: "Alert", message: "Please select the prefer gender.")
            return
        }
        
        /* For User's Match Gender - if nothing is selected */
        if (man2.isOn == false && woman2.isOn == false){
            showAlertModal(title: "Alert", message: "Please select the prefer gender.")
            return
        }
        
        /* Everything is good */
        if (man1.isOn ==  true || woman1.isOn ==  true || man2.isOn ==  true || woman2.isOn ==  true  ){
       
            let Q1 = self.storyboard?.instantiateViewController(withIdentifier: "s2")as! CompatabilityQuizVC
            self.navigationController?.pushViewController(Q1, animated: true)
        }
        
    }
    
    /* Welcome to Compatability Quiz Screen */
    @IBAction func steps2(_ sender: Any) {
        let Q2 = self.storyboard?.instantiateViewController(withIdentifier: "s3")as! CompatabilityQuizVC
        self.navigationController?.pushViewController(Q2, animated: true)
        
    }
    
    /* Tips for Compatability Quiz Screen */
    @IBAction func step3s3(_ sender: Any) {
        let Q3 = self.storyboard?.instantiateViewController(withIdentifier: "s5")as! CompatabilityQuizQOne
        self.navigationController?.pushViewController(Q3, animated: true)
    }
    
    
    /* Submitting all user's answers to database */
    @IBAction func stepfinal(_ sender: UIButton) {
        self.db.collection("CompatabilityQuiz").document((Auth.auth().currentUser?.email)!).setData([
            "questionOne": self.selectedQuestionOneOptions,
            "questionTwo": self.selectedQuestionTwoOptions,
            "questionThree": self.selectedQuestionThreeOptions,
            "questionFour": self.selectedQuestionFourOptions,
            "questionFive": self.selectedQuestionFiveOptions
        ]) { err in
            if let _ = err {
                self.showAlertModal(title: "Error", message: "Error in quiz answers to database")
            } else {
                self.showAlertModal(title: "Success✅", message: "Your answers are saved successfully😃")
            }
        }
        let tabbar = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar")as! UserTabBarVC
        self.navigationController?.pushViewController(tabbar, animated: true)
    }

    
    
    /* Alert */
    private func showAlertModal(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}




