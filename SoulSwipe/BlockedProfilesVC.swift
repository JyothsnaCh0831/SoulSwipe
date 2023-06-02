//
//  BlockedProfilesVC.swift
//  SoulSwipe
//
//  Created by Adapa,Venkata Rayudu on 5/25/23.
//

import UIKit

class BlockedProfilesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.blockedTV.delegate = self
        self.blockedTV.dataSource = self
    }
    
    @IBOutlet weak var blockedTV: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        blockedTV.reloadData()
    }

}

extension BlockedProfilesVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        blockedProfiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = blockedTV.dequeueReusableCell(withIdentifier: "blockedCell", for: indexPath) as? BlockedTVC else{
            return  UITableViewCell()
        }
        
        let dictionary = blockedProfiles[indexPath.row]
        cell.nameLBL.text = dictionary["name"]
        cell.userImage.image = UIImage(named: dictionary["image"]!)
        cell.unblockBTN.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        guard let cell = sender.superview?.superview?.superview?.superview as? UITableViewCell else {
            return
        }
        guard let indexPath = blockedTV.indexPath(for: cell) else {
            return
        }
        
        let alertController = UIAlertController(title: "Alert", message: "Do you want to proceed?", preferredStyle: .alert)
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }
            
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            print(indexPath.row)
            print(profiles.count)
            let unblockedDictionary = blockedProfiles.remove(at: indexPath.row)
            profiles.append(unblockedDictionary)
            print(profiles.count)
            self.blockedTV.reloadData()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)

    }

}
