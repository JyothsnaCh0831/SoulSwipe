//
//  EditQuestionVC.swift
//  SoulSwipe
//
//  Created by Chaparala,Jyothsna on 6/1/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class EditQuestionVC: UIViewController {
    
    let db = Firestore.firestore()
    
    var selectedQuestionOneOptions: [String] = []
    
    var buttonsArray: [String] = []
    var question: String = ""
    var choose: String = ""
    var questionNumber: Int = 0
    var questionFromDB: String = ""
    
    @IBOutlet weak var questionLBL: UILabel!
    
    @IBOutlet weak var chooseLBL: UILabel!
    
    @IBOutlet weak var buttonSV: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        switch questionNumber {
        case 0:
            self.questionFromDB = "questionOne"
        case 1:
            self.questionFromDB = "questionTwo"
        case 2:
            self.questionFromDB = "questionThree"
        case 3:
            self.questionFromDB = "questionFour"
        case 4:
            self.questionFromDB = "questionFive"
        case 5:
            self.questionFromDB = "questionSix"
        case 6:
            self.questionFromDB = "questionSeven"
        case 7:
            self.questionFromDB = "questionEight"
        default:
            self.questionFromDB = ""
        }
        
        self.getAnswersFromDB()
        
        self.questionLBL.text = self.question
        self.chooseLBL.text = self.choose
        
    }
    
    @IBAction func selectOption(_ sender: UIButton) {
        print("Button Clicked \(String(describing: sender.titleLabel!.text!))")
    }
    
    
    @IBAction func saveBTN(_ sender: UIButton) {
        self.showAlertModal(title: "Info", message: "Your answers will be updated to the database soon")
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
    
    
    func getAnswersFromDB() {
        let quizAnswersRef = self.db.collection("CompatabilityQuiz").document((Auth.auth().currentUser?.email)!)
        
        quizAnswersRef.getDocument {
            (document, error) in
            if let document = document, document.exists {
                let details = document.data()!
                
                self.selectedQuestionOneOptions.append(contentsOf: details[self.questionFromDB] as! [String])

            }
            for(index, element) in self.buttonsArray.enumerated() {
                if(self.selectedQuestionOneOptions.contains(element)) {
                    let btn: UIButton = {
                        let button = UIButton()
                        button.setTitle(element, for: .normal)
                        button.backgroundColor = UIColor.systemRed
                        button.setTitleColor(UIColor.white, for: .normal)
                        button.titleLabel?.lineBreakMode = .byWordWrapping
                        button.contentVerticalAlignment = .center
                        button.contentHorizontalAlignment = .center
                        button.addTarget(self, action: #selector(self.selectOption(_:)), for: .touchUpInside)
                        button.tag = index
                        
                        return button
                    }()
                    self.buttonSV.addArrangedSubview(btn)
                } else {
                    let btn: UIButton = {
                        let button = UIButton()
                        button.setTitle(element, for: .normal)
                        button.backgroundColor = UIColor.secondarySystemFill
                        button.setTitleColor(UIColor.systemBlue, for: .normal)
                        button.titleLabel?.lineBreakMode = .byWordWrapping
                        button.contentVerticalAlignment = .center
                        button.contentHorizontalAlignment = .center
                        button.addTarget(self, action: #selector(self.selectOption(_:)), for: .touchUpInside)
                        button.tag = index
                        
                        return button
                    }()
                    self.buttonSV.addArrangedSubview(btn)
                }
            }
        }
    }
}
