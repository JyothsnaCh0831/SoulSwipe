//
//  LikedProfilesVC.swift
//  SoulSwipe
//
//  Created by Adapa,Venkata Rayudu on 5/25/23.
//

import UIKit

class LikedProfilesVC: UIViewController {
    
    @IBOutlet weak var likedTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.likedTV.delegate = self
        self.likedTV.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        likedTV.reloadData()
    }
    
}

extension LikedProfilesVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        likedProfiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = likedTV.dequeueReusableCell(withIdentifier: "likedCell", for: indexPath) as? LikedTVC else{
            return  UITableViewCell()
        }
        
        let dictionary = likedProfiles[indexPath.row]
        cell.nameLBL.text = dictionary["name"]
        cell.userImage.image = UIImage(named: dictionary["image"]!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addToFavourites = UIContextualAction(style: .normal, title: "Add", handler: {
            [weak self] (act, view, cmp) in
            
            let isValid = favouriteProfiles.contains { $0 == likedProfiles[indexPath.row] }
            if isValid == false{
                favouriteProfiles.append(likedProfiles[indexPath.row])
            }
            
            self!.likedTV.reloadData()
            cmp(true)
        })
        addToFavourites.backgroundColor = UIColor.purple
        return UISwipeActionsConfiguration(actions: [addToFavourites])
    }
    
}
