//
//  LikedTVC.swift
//  SoulSwipe
//
//  Created by Devineni,Vasavi on 5/31/23.
//

import UIKit

class LikedTVC: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLBL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
