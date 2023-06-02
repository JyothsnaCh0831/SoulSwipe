//
//  CompatabilityQuizQThree.swift
//  SoulSwipe
//
//  Created by Chaparala,Jyothsna on 5/25/23.
//

import UIKit

class CompatabilityQuizQThree: UIViewController {
    
    var selectedQuestionOneOptions: [String] = []
    var selectedQuestionTwoOptions: [String] = []
    var selectedQuestionThreeOptions: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func optionsBtn(_ sender: UIButton) {
        if(!self.selectedQuestionThreeOptions.contains((sender.titleLabel?.text)!) && self.selectedQuestionThreeOptions.count < 2) {
            sender.backgroundColor = UIColor.systemRed
            sender.tintColor = UIColor.white
            self.selectedQuestionThreeOptions.append((sender.titleLabel?.text)!)
        } else if(self.selectedQuestionThreeOptions.contains((sender.titleLabel?.text)!)){
            self.selectedQuestionThreeOptions.remove(at: self.selectedQuestionThreeOptions.lastIndex(of: (sender.titleLabel?.text)!)!)
            sender.backgroundColor = .clear
            sender.tintColor = UIColor.systemBlue
        } else {
            self.showAlertModal(title: "Info⚠️", message: "You can't select more than 2 options")
        }
    }
    
    
    @IBAction func continueBtn(_ sender: UIButton) {
        /* If no option is selected */
        if(self.selectedQuestionThreeOptions.count == 0) {
            self.showAlertModal(title: "Warning❌", message: "Please select any two options of your choice.")
        }
        
        /* If less than 2 options are selected */
        else if(self.selectedQuestionThreeOptions.count < 2) {
            self.showAlertModal(title: "Info⚠️", message: "Choose another option to proceed further.")
        }
        
        /* Everything is good */
        else {
            let Q7 = self.storyboard?.instantiateViewController(withIdentifier: "s8")as! CompatabilityQuizQFour
            Q7.selectedQuestionOneOptions = self.selectedQuestionOneOptions
            Q7.selectedQuestionTwoOptions = self.selectedQuestionTwoOptions
            Q7.selectedQuestionThreeOptions = self.selectedQuestionThreeOptions
            self.navigationController?.pushViewController(Q7, animated: true)
        }
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
