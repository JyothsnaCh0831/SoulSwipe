//
//  EditCompatabilityQuizVC.swift
//  SoulSwipe
//
//  Created by Chaparala,Jyothsna on 5/25/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class EditCompatabilityQuizVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var questionsTV: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.questionsTV.dataSource = self
        self.questionsTV.delegate = self
        
        // Do any additional setup after loading the view.
        // self.getAnswersFromDB()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return compatabilityQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.questionsTV.dequeueReusableCell(withIdentifier: "question", for: indexPath) as? CompatabilityQuestionCell else{
            print("Error")
            return  UITableViewCell()
        }
        cell.questionTV.text = compatabilityQuestions[indexPath.row]["question"] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "editQuestion") as! EditQuestionVC
        destination.question = compatabilityQuestions[indexPath.row]["question"] as! String
        destination.choose = compatabilityQuestions[indexPath.row]["choose"] as! String
        destination.buttonsArray = compatabilityQuestions[indexPath.row]["options"] as! [String]
        destination.questionNumber = indexPath.row
        self.navigationController?.pushViewController(destination, animated: true)
        self.questionsTV.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
//    @IBOutlet var optionsBtn: [UIButton]!

   
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
//    @IBAction func optionsBtn(_ sender: UIButton) {
//        if(!self.selectedQuestionOneOptions.contains((sender.titleLabel?.text)!) && self.selectedQuestionOneOptions.count < 2) {
//            sender.backgroundColor = UIColor.systemRed
//            sender.tintColor = UIColor.white
//            self.selectedQuestionOneOptions.append((sender.titleLabel?.text)!)
//        } else if(self.selectedQuestionOneOptions.contains((sender.titleLabel?.text)!)){
//            self.selectedQuestionOneOptions.remove(at: self.selectedQuestionOneOptions.lastIndex(of: (sender.titleLabel?.text)!)!)
//            sender.backgroundColor = .clear
//            sender.tintColor = UIColor.systemBlue
//        } else {
//            self.showAlertModal(title: "Info⚠️", message: "You can't select more than 2 options")
//        }
//    }
    
    
//    @IBAction func continueBtn(_ sender: UIButton) {
//
//        /* If no option is selected */
//        if(self.selectedQuestionOneOptions.count == 0) {
//            self.showAlertModal(title: "Warning❌", message: "Please select any two options of your choice.")
//        }
//
//        /* If less than 2 options are selected */
//        else if(self.selectedQuestionOneOptions.count < 2) {
//            self.showAlertModal(title: "Info⚠️", message: "Choose another option to proceed further.")
//        }
//
//        /* Everything is good */
//        else {
//          let Q5 = self.storyboard?.instantiateViewController(withIdentifier: "s6") as! CompatabilityQuizQTwo
//        Q5.selectedQuestionOneOptions = self.selectedQuestionOneOptions
//        self.navigationController?.pushViewController(Q5, animated: true)
//            self.updateDataToDB()
//            self.showAlertModal(title: "Info", message: "Your options are updated to the database")
//        }
//    }
    
    
    
}

extension EditCompatabilityQuizVC {
    
}

extension EditCompatabilityQuizVC {
//    func getAnswersFromDB() {
//        let quizAnswersRef = self.db.collection("CompatabilityQuiz").document((Auth.auth().currentUser?.email)!)
//
//        quizAnswersRef.getDocument {
//            (document, error) in
//            if let document = document, document.exists {
//                let details = document.data()!
//
//                self.selectedQuestionOneOptions.append(contentsOf: details["questionOne"] as! [String])
//
//                for i in self.optionsBtn {
//                    if(self.selectedQuestionOneOptions.contains(i.titleLabel!.text!)) {
//                        i.backgroundColor = UIColor.systemRed
//                        i.tintColor = UIColor.white
//                    }
//                }
//            }
//        }
//    }
//
//    func updateDataToDB() {
//        let quizAnswersRef = self.db.collection("CompatabilityQuiz").document((Auth.auth().currentUser?.email)!)
//
//        /* Removing the previous answers */
//        quizAnswersRef.updateData([
//            "questionOne": FieldValue.delete()
//        ]) { err in
//            if let _ = err {
//                self.showAlertModal(title: "Error", message: "Error in updating your profile")
//            } else {
//                self.showAlertModal(title: "Success✅", message: "Your Profile is updated successfully😃")
//            }
//        }
//
//        /* Updating with the new answers */
//        quizAnswersRef.updateData([
//            "questionOne": FieldValue.arrayUnion(self.selectedQuestionOneOptions as [Any])
//        ]) { err in
//            if let _ = err {
//                self.showAlertModal(title: "Error", message: "Error in updating your profile")
//            } else {
//                self.showAlertModal(title: "Success✅", message: "Your Profile is updated successfully😃")
//            }
//        }
//    }
}
