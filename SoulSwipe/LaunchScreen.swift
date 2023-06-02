//
//  LaunchScreen.swift
//  SoulSwipe
//
//  Created by Adapa,Venkata Rayudu on 5/18/23.
//

import UIKit
import Lottie

class LaunchScreen: UIViewController {

    override func viewDidLoad() {
        //self?.logo.isHidden = true
        self.logo.animation = LottieAnimation.named("go")
        self.logo.loopMode = .playOnce
        self.logo.play {
            [weak self] _ in
            self?.logo.isHidden = true
        }
        super.viewDidLoad()
       

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var logo: LottieAnimationView!
    
    
    
    @IBAction func login(_ sender: UIButton) {
        
        let login = self.storyboard?.instantiateViewController(withIdentifier: "Login")as! Login
        self.navigationController?.pushViewController(login, animated: true)
    }
    
    
    @IBAction func Register(_ sender: UIButton) {
        let register = self.storyboard?.instantiateViewController(withIdentifier: "Register")as! Register
        self.navigationController?.pushViewController(register, animated: true)
    }
        
    }
    


