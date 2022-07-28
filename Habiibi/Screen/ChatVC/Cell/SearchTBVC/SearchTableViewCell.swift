//
//  SearchTableViewCell.swift
//  Habiibi
//
//  Created by KhanhVu on 7/28/22.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvt: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpView()
    }
    func setUpView() {
        imgAvt.layer.cornerRadius = imgAvt.frame.height/2
        imgAvt.layer.borderWidth = 1
        imgAvt.layer.borderColor = UIColor.systemPink.cgColor
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with user: FriendModel) {
        lbName.text = user.userName
        guard let url = URL(string: user.avata ?? "") else{
            return
        }
        imgAvt.sd_setImage(with: url, placeholderImage: UIImage(named: "img_placeHolder"))
    }
    
}
