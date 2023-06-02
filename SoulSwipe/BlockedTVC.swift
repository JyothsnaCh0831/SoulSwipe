//
//  BlockedTVC.swift
//  SoulSwipe
//
//  Created by Devineni,Vasavi on 5/31/23.
//

import UIKit

class BlockedTVC: UITableViewCell {
    
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var unblockBTN: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
