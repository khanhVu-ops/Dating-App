//
//  EditProfileCollectionViewCell.swift
//  Habiibi
//
//  Created by KhanhVu on 7/8/22.
//

import UIKit

class EditProfileCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var vCLTV: UIView!
    @IBOutlet weak var imvPicture: UIImageView!
    let index = -1
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vCLTV.layer.cornerRadius = 20
        imvPicture.layer.cornerRadius = 20
        vCLTV.layer.masksToBounds = true
        
        // Initialization code
    }
    
    func confifure(imgStr: String) {
        if imgStr == "" {
            imvPicture.image = UIImage(named: "plus")
        }else {
            guard let url = URL(string: imgStr) else{return}
            imvPicture.sd_setImage(with: url, placeholderImage: UIImage(named: "img_placeHolder"))
        }
        
    }
    
}
