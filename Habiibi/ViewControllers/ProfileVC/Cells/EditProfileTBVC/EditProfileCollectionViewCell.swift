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
            imvPicture.image = imgStr.toImage()
        }
        
    }
    
}
