//
//  ListFriendCollectionViewCell.swift
//  Habiibi
//
//  Created by KhanhVu on 7/27/22.
//

import UIKit

class ListFriendCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imgAvt: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
        // Initialization code
    }
    
    func setUpView() {
        imgAvt.layer.cornerRadius = imgAvt.frame.height/2
        imgAvt.layer.borderWidth = 1
        imgAvt.layer.borderColor = UIColor.systemPink.cgColor
        
    }
    
    
    func configure(with friend: FriendModel) {
        guard let url = URL(string: friend.avata ?? "") else{return}
        
        self.imgAvt.sd_setImage(with: url, placeholderImage: UIImage(named: "img_placeHolder"))
        self.lbName.text = friend.userName
        
//        DatabaseManager.auth.fetchDataUser(uid: uid) {[weak self] (user, error) in
//            guard let user = user , error == nil else{return}
//            guard let url = URL(string: user.avata ?? "") else{return}
//
//            self?.imgAvt.sd_setImage(with: url, placeholderImage: UIImage(named: "img_placeHolder"))
//            self?.lbName.text = user.userName
//        }
    }

}
