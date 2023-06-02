//
//  CompatabilityQuizQTwo.swift
//  SoulSwipe
//
//  Created by Chaparala,Jyothsna on 5/25/23.
//

import UIKit

class CompatabilityQuizQTwo: UIViewController {
    
    var selectedQuestionOneOptions: [String] = []
    var selectedQuestionTwoOptions: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func optionsBtn(_ sender: UIButton) {
        if(!self.selectedQuestionTwoOptions.contains((sender.titleLabel?.text)!) && self.selectedQuestionTwoOptions.count < 2) {
            sender.backgroundColor = UIColor.systemRed
            sender.tintColor = UIColor.white
            self.selectedQuestionTwoOptions.append((sender.titleLabel?.text)!)
        } else if(self.selectedQuestionTwoOptions.contains((sender.titleLabel?.text)!)){
            self.selectedQuestionTwoOptions.remove(at: self.selectedQuestionTwoOptions.lastIndex(of: (sender.titleLabel?.text)!)!)
            sender.backgroundColor = .clear
            sender.tintColor = UIColor.systemBlue
        } else {
            self.showAlertModal(title: "Info⚠️", message: "You can't select more than 2 options")
        }
    }
    
    @IBAction func continueBtn(_ sender: UIButton) {
        /* If no option is selected */
        if(self.selectedQuestionTwoOptions.count == 0) {
            self.showAlertModal(title: "Warning❌", message: "Please select any two options of your choice.")
        }
        
        /* If less than 2 options are selected */
        else if(self.selectedQuestionTwoOptions.count < 2) {
            self.showAlertModal(title: "Info⚠️", message: "Choose another option to proceed further.")
        }
        
        /* Everything is good */
        else {
            let Q6 = self.storyboard?.instantiateViewController(withIdentifier: "s7") as! CompatabilityQuizQThree
            Q6.selectedQuestionOneOptions = self.selectedQuestionOneOptions
            Q6.selectedQuestionTwoOptions = self.selectedQuestionTwoOptions
            self.navigationController?.pushViewController(Q6, animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    */
    
    /* Alert */
    private func showAlertModal(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

}
