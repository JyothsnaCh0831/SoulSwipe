//
//  CompatabilityQuizQFour.swift
//  SoulSwipe
//
//  Created by Chaparala,Jyothsna on 5/25/23.
//

import UIKit

class CompatabilityQuizQFour: UIViewController {
    
    var selectedQuestionOneOptions: [String] = []
    var selectedQuestionTwoOptions: [String] = []
    var selectedQuestionThreeOptions: [String] = []
    var selectedQuestionFourOptions: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func optionsBtn(_ sender: UIButton) {
        if(!self.selectedQuestionFourOptions.contains((sender.titleLabel?.text)!) && self.selectedQuestionFourOptions.count < 1) {
            sender.backgroundColor = UIColor.systemRed
            sender.tintColor = UIColor.white
            self.selectedQuestionFourOptions.append((sender.titleLabel?.text)!)
        } else if(self.selectedQuestionFourOptions.contains((sender.titleLabel?.text)!)){
            self.selectedQuestionFourOptions.remove(at: self.selectedQuestionFourOptions.lastIndex(of: (sender.titleLabel?.text)!)!)
            sender.backgroundColor = .clear
            sender.tintColor = UIColor.systemBlue
        } else {
            self.showAlertModal(title: "Info⚠️", message: "You can't select more than 1 options")
        }
    }
    
    
    @IBAction func continueBtn(_ sender: UIButton) {
        /* If no option is selected */
        if(self.selectedQuestionFourOptions.count == 0) {
            self.showAlertModal(title: "Warning❌", message: "Choose an option to proceed further.")
        }
        
        /* Everything is good */
        else {
            let Q8 = self.storyboard?.instantiateViewController(withIdentifier: "s9")as! CompatabilityQuizQFive
            Q8.selectedQuestionOneOptions = self.selectedQuestionOneOptions
            Q8.selectedQuestionTwoOptions = self.selectedQuestionTwoOptions
            Q8.selectedQuestionThreeOptions = self.selectedQuestionThreeOptions
            Q8.selectedQuestionFourOptions = self.selectedQuestionFourOptions
            self.navigationController?.pushViewController(Q8, animated: true)
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
