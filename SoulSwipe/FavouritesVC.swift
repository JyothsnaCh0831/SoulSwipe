//
//  FavouritesVC.swift
//  SoulSwipe
//
//  Created by Devineni,Vasavi on 5/31/23.
//

import UIKit

class FavouritesVC: UIViewController {
    
    @IBOutlet weak var favouritesTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.favouritesTV.dataSource = self
        self.favouritesTV.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favouritesTV.reloadData()
    }

}

extension FavouritesVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favouriteProfiles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = favouritesTV.dequeueReusableCell(withIdentifier: "favouriteCell", for: indexPath) as? FavouriteProfileTVC else{
            return  UITableViewCell()
        }
        
        let dictionary = favouriteProfiles[indexPath.row]
        cell.nameLBL.text = dictionary["name"]
        cell.userImage.image = UIImage(named: dictionary["image"]!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeFromFavourites = UIContextualAction(style: .normal, title: "Remove", handler: {
            [weak self] (act, view, cmp) in
            favouriteProfiles.remove(at: indexPath.row)
            self!.favouritesTV.reloadData()
            cmp(true)
        })
        removeFromFavourites.backgroundColor = UIColor.purple
        return UISwipeActionsConfiguration(actions: [removeFromFavourites])
    }
}
