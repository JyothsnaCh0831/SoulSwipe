//
//  ProfileVC.swift
//  SoulSwipe
//
//  Created by Adapa,Venkata Rayudu on 5/25/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileVC: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var nameLBL: UITextField!
    
    @IBOutlet weak var ageLBL: UITextField!
    
    @IBOutlet weak var jobLBL: UITextField!
    
    @IBOutlet weak var likesCountBTN: UILabel!
    
    @IBOutlet weak var aboutMeTV: UITextView!
    
    @IBOutlet weak var datePV: UIDatePicker!
    
    @IBOutlet weak var quizBtn: UIButton!
    
    @IBOutlet weak var updateBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.datePV.isEnabled = false
        self.ageLBL.isEnabled = false

        self.aboutMeTV.layer.borderColor = CGColor(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        self.aboutMeTV.layer.borderWidth = 1.0
        self.aboutMeTV.layer.cornerRadius = 5.0
        
        self.getDataFromDB()
        
    }
    
    @IBAction func Settings(_ sender: UIButton) {
        let Setting = self.storyboard?.instantiateViewController(withIdentifier: "settings")as! SettingsVC
        self.navigationController?.pushViewController(Setting, animated: true)
    }
    
    
    @IBAction func LikedProfiles(_ sender: UIButton) {
        let likedprofiles = self.storyboard?.instantiateViewController(withIdentifier: "LikedProfiles")as! LikedProfilesVC
        self.navigationController?.pushViewController(likedprofiles, animated: true)
        
    }
    
    @IBAction func updateBtn(_ sender: UIButton) {
        self.db.collection("Users").document((Auth.auth().currentUser?.email)!).updateData([
            "About Me": self.aboutMeTV.text as Any,
            "Job": self.jobLBL.text as Any,
            "First Name": self.nameLBL.text?.split(separator: " ")[0] as Any,
            "Last Name": self.nameLBL.text?.split(separator: " ")[1...].joined(separator: " ") as Any,
        ]) { err in
            if let _ = err {
                self.showAlertModal(title: "Error", message: "Error in updating your profile")
            } else {
                self.showAlertModal(title: "Success✅", message: "Your Profile is updated successfully😃")
            }
        }
    }
    
    
    @IBAction func viewEditQuizBtn(_ sender: UIButton) {
        let editQuiz = self.storyboard?.instantiateViewController(withIdentifier: "editQuiz") as! EditCompatabilityQuizVC
        self.navigationController?.pushViewController(editQuiz, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    /* Alert */
    private func showAlertModal(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

}

extension ProfileVC {
    func getDataFromDB() {
        let usersProfileRef = self.db.collection("Users").document((Auth.auth().currentUser?.email)!)
        
        usersProfileRef.getDocument {
            (document, error) in
            if let document = document, document.exists {
                let details = document.data()!
                
                self.nameLBL.text = details["First Name"] as? String
                self.nameLBL.text! += " "
                self.nameLBL.text! += details["Last Name"] as! String
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd"
                let date = dateFormatter.date(from: details["dateOfBirth"] as! String)
                self.datePV.setDate(date!, animated: true)
                
                self.jobLBL.text = details["Job"] as? String
                
                self.aboutMeTV.text = details["About Me"] as? String
                
                self.likesCountBTN.text = "❤️"
                self.likesCountBTN.text! += "\(details["Likes"] as! Int)"
                
                let calendar = Calendar.current
                let now = Date()
                let ageComponents = calendar.dateComponents([.year], from: date!, to: now)
                guard let age = ageComponents.year else {
                    return
                    
                }
                self.ageLBL.text = "\(age)"
                
            }
        }
    }
}
